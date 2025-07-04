import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/product_resp_model.dart';
import 'package:ministore/dio/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  final TextEditingController searchController = TextEditingController();

  List<Product> _products = [];
  bool _loading = false;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;

  String _search = '';

  ProductProvider() {
    searchController.addListener(() {
      setSearch(searchController.text);
    });
  }

  List<Product> get products {
    return _products
        .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  bool get loading => _loading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

  /// Fetch first page of products
  Future<void> fetchProducts() async {
    _loading = true;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      ProductResponse res = await _service.getProductsPaginated(_currentPage);
      _products = res.data.data;
      _hasMore = res.data.currentPage < res.data.lastPage;
    } catch (e) {
      print("Error fetching products: $e");
      _products = [];
      _hasMore = false;
    }

    _loading = false;
    notifyListeners();
  }

  /// Fetch next page (pagination)
  Future<void> fetchMoreProducts() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      ProductResponse res = await _service.getProductsPaginated(_currentPage);
      final newProducts = res.data.data;
      _products.addAll(newProducts);
      _hasMore = res.data.currentPage < res.data.lastPage;
    } catch (e) {
      print("Error fetching more products: $e");
      _hasMore = false;
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _service.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<Product?> scanProduct(String barcode) async {
    try {
      return await _service.scanProductByBarcode(barcode);
    } catch (e) {
      print("Error scanning product: $e");
      return null;
    }
  }

  Future<Product?> createProduct(Product body) async {
    try {
      final product = await _service.createProduct(body as Product);
      await fetchProducts();
      return product;
    } catch (e) {
      print("Error creating product: $e");
      return null;
    }
  }

  Future<Product?> updateProduct(String id, Product product) async {
    try {
      final updatedProduct = await _service.updateProduct(id, product);
      await fetchProducts();
      return updatedProduct;
    } catch (e) {
      print("Error updating product: $e");
      return null;
    }
  }
}
