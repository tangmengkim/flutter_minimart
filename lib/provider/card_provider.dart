import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ministore/dio/models/card_item_model.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/sale/sale_item_model.dart';
import 'package:ministore/dio/models/sale/sale_req_model.dart';
import 'package:ministore/dio/models/sale/sale_resp_model.dart';
import 'package:ministore/dio/services/sale_service.dart';
import 'package:ministore/util/data.dart';

enum PaymentMethod {
  cash,
  card,
  qr,
  bank,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.qr:
        return 'QR Payment';
      case PaymentMethod.bank:
        return 'Bank Transfer';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  String get apiValue => name; // Sends 'cash', 'card', etc.
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  CartProvider() {
    _loadFromLocalStorage();
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

  double get total => _items.fold(
        0,
        (sum, item) =>
            sum + (double.tryParse(item.product.price) ?? 0) * item.quantity,
      );

  void clearCart() {
    _items.clear();
    _saveToLocalStorage();
    notifyListeners();
  }

  Future<void> _saveToLocalStorage() async {
    final encoded = jsonEncode(_items.map((item) => item.toJson()).toList());
    await Data().put<String>(DataKeys.cartItems, encoded);
  }

  Future<void> _loadFromLocalStorage() async {
    final raw = await Data().get<String>(DataKeys.cartItems);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _items.clear();
        _items.addAll(decoded.map((e) => CartItem.fromJson(e)).toList());
        notifyListeners();
      } catch (e) {
        print("Failed to decode cart: $e");
        await Data().remove(DataKeys.cartItems); // Clean corrupted data
      }
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

    final items = _items
        .map((item) => SaleItem(
              productId: item.product.id!,
              quantity: item.quantity,
            ))
        .toList();
    print("==========${items}");

    final request = SaleRequest(
      items: items,
      paymentMethod: paymentMethod,
      tax: tax,
      discount: discount,
    );

    final SaleResp response = await SaleService().createSale(request);

    clearCart();
    return response.data;
  }
}
