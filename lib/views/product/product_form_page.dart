import 'package:flutter/material.dart';
import 'package:ministore/provider/productProvider.dart';
import 'package:provider/provider.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/category_model.dart';
import 'package:ministore/dio/models/section_model.dart';
import 'package:ministore/dio/models/shelf_model.dart';
import 'package:ministore/dio/services/categories_service.dart';
import 'package:ministore/dio/services/section_service.dart';
import 'package:ministore/dio/services/shelves_service.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  // Text field controllers
  late final TextEditingController nameController;
  late final TextEditingController descController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  late final TextEditingController minStockController;

  // Dropdown selections
  int? selectedCategoryId;
  int? selectedSectionId;
  int? selectedShelfId;

  // Data lists
  List<Category> categories = [];
  List<Section> sections = [];
  List<Shelf> shelves = [];

  final categoryService = CategoryService();
  final sectionService = SectionService();
  final shelvesService = ShelvesService();

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    nameController = TextEditingController(text: p?.name ?? '');
    descController = TextEditingController(text: p?.description ?? '');
    priceController = TextEditingController(text: p?.price?.toString() ?? '');
    stockController =
        TextEditingController(text: p?.stockQuantity?.toString() ?? '');
    minStockController =
        TextEditingController(text: p?.minStockLevel?.toString() ?? '');

    selectedCategoryId = p?.categoryId;
    selectedSectionId = p?.sectionId;
    selectedShelfId = p?.shelfId;

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final fetchedSections = await sectionService.getSections();
      print("=====>get from api");
      final fetchedCategories = await categoryService.getCategories();

      setState(() {
        categories = fetchedCategories.categories;
        sections = fetchedSections.sections;
      });

      if (selectedSectionId != null) {
        await _loadShelvesForSection(selectedSectionId!);
      }
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> _loadShelvesForSection(int sectionId) async {
    try {
      final fetchedShelves =
          await shelvesService.getShelves(sectionId.toString());
      setState(() {
        shelves = fetchedShelves.shelfs;
      });
    } catch (e) {
      print('Error loading shelves: $e');
    }
  }

  Future<void> _saveProduct() async {
    final product = Product(
      id: widget.product?.id,
      name: nameController.text,
      description: descController.text,
      price: priceController.text,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      minStockLevel: int.tryParse(minStockController.text) ?? 0,
      categoryId: selectedCategoryId ?? 0,
      sectionId: selectedSectionId ?? 0,
      shelfId: selectedShelfId ?? 0,
      imageUrl: widget.product?.imageUrl,
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);

    if (widget.product == null) {
      await provider.createProduct(product);
    } else {
      await provider.updateProduct(widget.product!.id.toString(), product);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stock Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: minStockController,
              decoration: InputDecoration(labelText: 'Min Stock Level'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              decoration: InputDecoration(labelText: 'Category'),
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name ?? 'Unnamed'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),

            // Section Dropdown
            DropdownButtonFormField<int>(
              value: selectedSectionId,
              decoration: InputDecoration(labelText: 'Section'),
              items: sections
                  .map((sec) => DropdownMenuItem(
                        value: sec.id,
                        child: Text(sec.name ?? 'Unnamed'),
                      ))
                  .toList(),
              onChanged: (value) async {
                selectedSectionId = value;
                selectedShelfId = null;
                shelves = [];
                setState(() {});
                if (value != null) {
                  await _loadShelvesForSection(value);
                }
              },
            ),

            // Shelf Dropdown (based on section)
            DropdownButtonFormField<int>(
              value: selectedShelfId,
              decoration: InputDecoration(labelText: 'Shelf'),
              items: shelves
                  .map((shelf) => DropdownMenuItem(
                        value: shelf.id,
                        child: Text(shelf.name ?? 'Unnamed'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedShelfId = value;
                });
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
