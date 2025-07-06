import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/provider/auth_provider.dart';
import 'package:ministore/views/auth/login.dart';
import 'package:ministore/views/home/cart_page.dart';
import 'package:ministore/views/home/checkout_page.dart';
import 'package:ministore/views/auth/change_password.dart';
import 'package:ministore/views/home/page_view_controller.dart';
import 'package:ministore/views/product/product_form_page.dart';
import 'package:ministore/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

// Define constant route names
const String pageHome = 'home/home.dart';
const String productPageRoute = '/product';

const String pageProfile = '/profile';
const String pageProductForm = '/product_form_page.dart';
const String pageChangePassword = '/change_password';

const String pageCart = '/cart_page.dart';
const String pageCheckout = '/checkout_page.dart';

// Authentication routes
const String loginPageRoute = 'auth/login.dart';

// Route generator function
Route<dynamic> generateRoute(RouteSettings settings) {
  return MaterialPageRoute(builder: (context) {
    switch (settings.name) {
      case loginPageRoute:
        // Handle login page route
        return LoginPage();
      case pageHome:
        return PageViewController();

      case pageProfile:
        return ProfilePage();

      case pageProductForm:
        return ProductFormPage(product: settings.arguments as Product?);

      case pageCart:
        return CartPage();
      case pageCheckout:
        return CheckoutPage();
      case pageChangePassword:
        return ChangePasswordPage();

      // case productPageRoute:
      //   final args = settings.arguments as int?;
      //   return MaterialPageRoute(builder: (_) => ProductPage(productId: args));
      // case cartPageRoute:
      //   final args = settings.arguments as String?;
      //   return MaterialPageRoute(builder: (_) => CartPage(userId: args));

      default:
        return Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        );
    }
  });
}
