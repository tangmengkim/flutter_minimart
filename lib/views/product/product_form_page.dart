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
  final bool isEdit;

  const ProductFormPage({super.key, this.product, this.isEdit = false});

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
  late final TextEditingController barcodeController;
  late final TextEditingController costPriceController;
  late final TextEditingController imageController;

  late bool? isActive;

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
    // print('====>${p!.toJson()}');
    nameController = TextEditingController(text: p?.name ?? '');
    descController = TextEditingController(text: p?.description ?? '');
    priceController = TextEditingController(text: p?.price?.toString() ?? '');
    stockController =
        TextEditingController(text: p?.stockQuantity?.toString() ?? '');
    minStockController =
        TextEditingController(text: p?.minStockLevel?.toString() ?? '');
    barcodeController = TextEditingController(text: p?.barcode ?? '');
    costPriceController = TextEditingController(text: p?.costPrice ?? '');
    imageController = TextEditingController(text: p?.image ?? '');

    selectedCategoryId = p?.categoryId;
    selectedSectionId = p?.sectionId;
    selectedShelfId = p?.shelfId;
    isActive = p?.isActive ?? true;
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

  bool _validateProductData() {
    if (nameController.text.trim().isEmpty) {
      _showError("Product name is required");
      return false;
    }
    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null) {
      _showError("Valid price is required");
      return false;
    }
    if (stockController.text.trim().isEmpty ||
        int.tryParse(stockController.text.trim()) == null) {
      _showError("Valid stock quantity is required");
      return false;
    }
    if (selectedCategoryId == null) {
      _showError("Category must be selected");
      return false;
    }
    if (selectedSectionId == null) {
      _showError("Section must be selected");
      return false;
    }
    if (selectedShelfId == null) {
      _showError("Shelf must be selected");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _saveProduct() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (!_validateProductData()) return;

    final tempProduct = Product(
      id: widget.product?.id,
      name: nameController.text,
      barcode: barcodeController.text.isNotEmpty
          ? barcodeController.text
          : widget.product?.barcode,
      description: descController.text,
      price: priceController.text,
      costPrice: costPriceController.text.isNotEmpty
          ? costPriceController.text
          : widget.product?.costPrice,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
      minStockLevel: int.tryParse(minStockController.text) ?? 0,
      categoryId: selectedCategoryId ?? 0,
      sectionId: selectedSectionId ?? 0,
      shelfId: selectedShelfId ?? 0,
      image: imageController.text.isNotEmpty
          ? imageController.text
          : widget.product?.image,
      isActive: isActive,
      imageUrl: widget.product?.imageUrl,
      isLowStock: widget.product?.isLowStock,
      isOutOfStock: widget.product?.isOutOfStock,
    );
    try {
      if (widget.product == null) {
        await provider.createProduct(tempProduct);
      } else {
        await provider.updateProduct(
            widget.product!.id.toString(), tempProduct);
      }

      Navigator.pop(context);
    } catch (e) {
      print("=====> error create or update");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    minStockController.dispose();
    barcodeController.dispose();
    costPriceController.dispose();
    imageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent, // allows taps on empty space
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Product Information", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  
                  _buildInputField(nameController, "Name", Icons.shopping_bag),
                  _buildInputField(descController, "Description", Icons.description),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(child: _buildInputField(stockController, "Stock Qty", Icons.confirmation_number, isDecimal: true)),
                      Expanded(child: _buildInputField( minStockController, "Min Qty", Icons.warning, isDecimal: true)),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Text("Barcode & Pricing", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
          
                  _buildInputField(barcodeController, "Barcode", Icons.qr_code, isDecimal: true),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(child: _buildInputField(priceController, "Price", Icons.attach_money, isDecimal: true)),
                      Expanded(child: _buildInputField(costPriceController, "Cost Price", Icons.money, isDecimal: true)),
                    ],
                  ),
                  _buildInputField( imageController, "Image Path or URL", Icons.image),
                  
                  const SizedBox(height: 16),
                  Text("Product Placement",  style: Theme.of(context).textTheme.titleMedium),

                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: categories
                        .map((cat) => DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.name ?? 'Unnamed'),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedCategoryId = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedSectionId,
                    decoration: InputDecoration(
                      labelText: 'Section',
                      prefixIcon: Icon(Icons.view_module),
                      border: OutlineInputBorder(),
                    ),
                    items: sections
                        .map((sec) => DropdownMenuItem(
                              value: sec.id,
                              child: Text(sec.name ?? 'Unnamed'),))
                        .toList(),
                    onChanged: (value) async {
                      selectedSectionId = value;
                      selectedShelfId = null;
                      shelves = [];
                      setState(() {});
                      if (value != null) await _loadShelvesForSection(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedShelfId,
                    decoration: InputDecoration(
                      labelText: 'Shelf',
                      prefixIcon: Icon(Icons.layers),
                      border: OutlineInputBorder(),
                    ),
                    items: shelves
                        .map((shelf) => DropdownMenuItem(
                              value: shelf.id,
                              child: Text(shelf.name ?? 'Unnamed'),))
                        .toList(),
                    onChanged: (value) => setState(() => selectedShelfId = value),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(title: Text("Active"),
                    value: isActive ?? true,
                    onChanged: (val) => setState(() => isActive = val),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveProduct,
                        icon: Icon(Icons.save),
                        label: Text('Save Product'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isDecimal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isDecimal
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
