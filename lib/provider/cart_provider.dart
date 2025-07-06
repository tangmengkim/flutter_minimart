import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ministore/dio/models/cart_item_model.dart';
import 'package:ministore/dio/models/invoice_model.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/sale/sale_req_model.dart';
import 'package:ministore/dio/models/sale/sale_model.dart';
import 'package:ministore/dio/services/sale_service.dart';
import 'package:ministore/util/data.dart';

enum PaymentMethod {
  cash,
  card,
  digital_wallet,
}

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.digital_wallet:
        return 'Digital Wallet';
    }
  }

  String get apiValue => name;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  CartProvider() {
    _loadFromLocalStorage();
  }

  // Add the missing setLoading method
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addToCart(Product product) {
    addToCartWithQty(product, 1);
  }

  void addToCartWithQty(Product product, int qty) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += qty;
    } else {
      _items.add(CartItem(product: product, quantity: qty));
    }
    _saveToLocalStorage();
    notifyListeners();
  }

  void updateQty(Product product, int qty) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && qty > 0) {
      _items[index].quantity = qty;
    } else if (index != -1 && qty == 0) {
      _items.removeAt(index);
    }
    _saveToLocalStorage();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    _saveToLocalStorage();
    notifyListeners();
  }

  // Helper method to get price as double
  double _getProductPrice(Product product) {
    // Handle both String and double types
    if (product.price is double) {
      return product.price as double;
    } else if (product.price is String) {
      return double.tryParse(product.price as String) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  // Calculate total handling string prices
  double get total => _items.fold(
        0.0,
        (sum, item) => sum + (_getProductPrice(item.product) * item.quantity),
      );

  // Helper method to get item total price
  double getItemTotalPrice(CartItem item) {
    return _getProductPrice(item.product) * item.quantity;
  }

  void clearCart() {
    _items.clear();
    _saveToLocalStorage();
    notifyListeners();
  }

  Future<void> _saveToLocalStorage() async {
    try {
      final encoded = jsonEncode(_items.map((item) => item.toJson()).toList());
      await Data().put<String>(DataKeys.cartItems, encoded);
    } catch (e) {
      print("Failed to save cart: $e");
    }
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      final raw = await Data().get<String>(DataKeys.cartItems);
      if (raw != null) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _items.clear();
        _items.addAll(decoded.map((e) => CartItem.fromJson(e)).toList());
        notifyListeners();
      }
    } catch (e) {
      print("Failed to decode cart: $e");
      await Data().remove(DataKeys.cartItems); // Clean corrupted data
    }
  }

  Future<InvoiceResponse> checkoutCartWithInvoice({
    required String paymentMethod,
    double? tax,
    double? discount,
  }) async {
    if (_items.isEmpty) {
      throw Exception("Cart is empty");
    }

    try {
      setLoading(true);

      // Create the sale request with null safety checks
      final saleRequest = SaleRequest(
        items: _items
            .where((item) =>
                item.product.id != null) // Filter out items with null IDs
            .map((item) => SaleRequestItem(
                  productId: item
                      .product.id!, // Safe to use ! because we filtered above
                  quantity: item.quantity,
                ))
            .toList(),
        paymentMethod: paymentMethod,
        tax: tax,
        discount: discount,
      );

      // Validate that we have items after filtering
      if (saleRequest.items.isEmpty) {
        throw Exception("No valid items found in cart");
      }

      print("Creating sale with items: ${saleRequest.items.length}");
      print("Payment method: $paymentMethod");
      print("Cart total: \$${total.toStringAsFixed(2)}");

      // Use SaleService to create the sale
      final saleService = SaleService();
      final response = await saleService.createSaleForInvoice(saleRequest);

      if (response.success) {
        // Clear the cart after successful checkout
        clearCart();
        return response;
      } else {
        throw Exception(response.message ?? 'Sale creation failed');
      }
    } catch (e) {
      print('Checkout error: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<Sale> checkoutCart({
    required String paymentMethod,
    double? tax,
    double? discount,
  }) async {
    if (_items.isEmpty) {
      throw Exception("Cart is empty");
    }

    setLoading(true);

    try {
      // Create request items with null safety checks
      final requestItems = _items
          .where((item) =>
              item.product.id != null) // Filter out items with null IDs
          .map((item) => SaleRequestItem(
                productId:
                    item.product.id!, // Safe to use ! because we filtered above
                quantity: item.quantity,
              ))
          .toList();

      // Validate that we have items after filtering
      if (requestItems.isEmpty) {
        throw Exception("No valid items found in cart");
      }

      print("Creating sale with items: ${requestItems.length}");
      print("Payment method: $paymentMethod");
      print("Cart total: \$${total.toStringAsFixed(2)}");

      final request = SaleRequest(
        items: requestItems,
        paymentMethod: paymentMethod,
        tax: tax,
        discount: discount,
      );

      final saleService = SaleService();
      final response = await saleService.createSale(request);

      if (response.success) {
        clearCart();
        return response.data;
      } else {
        throw Exception(response.message ?? 'Sale creation failed');
      }
    } catch (e) {
      print("Checkout error: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
