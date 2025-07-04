import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/views/auth/login.dart';
import 'package:ministore/views/home/page_view_controller.dart';
import 'package:ministore/views/product/product_form_page.dart';
import 'package:ministore/views/profile/profile_page.dart';

// Define constant route names
const String pageHome = 'home/home.dart';
const String productPageRoute = '/product';
const String cartPageRoute = '/cart';

const String pageProfile = '/profile';
const String pageProductForm = '/product_form_page.dart';

// Authentication routes
const String loginPageRoute = 'auth/login.dart';

// Route generator function
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginPageRoute:
      // Handle login page route
      return MaterialPageRoute(builder: (_) => LoginPage());
    case pageHome:
      return MaterialPageRoute(
        builder: (_) => const PageViewController(),
      );

    case pageProfile:
      return MaterialPageRoute(builder: (_) => const ProfilePage());

    case pageProductForm:
      return MaterialPageRoute(
        builder: (_) =>
            ProductFormPage(product: settings.arguments as Product?),
      );

    // case productPageRoute:
    //   final args = settings.arguments as int?;
    //   return MaterialPageRoute(builder: (_) => ProductPage(productId: args));
    // case cartPageRoute:
    //   final args = settings.arguments as String?;
    //   return MaterialPageRoute(builder: (_) => CartPage(userId: args));

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}
