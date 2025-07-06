import 'package:flutter/material.dart';
import 'package:ministore/provider/auth_provider.dart';
import 'package:ministore/provider/cart_provider.dart';
import 'package:ministore/provider/product_provider.dart';
import 'package:ministore/route_page.dart';
import 'package:ministore/util/data.dart';
import 'package:ministore/util/theme.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

// Example of a simple ChangeNotifier for runtime control
class RuntimeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Fixed syntax error here
    notifyListeners();
  }

  // Optional: Set initial theme based on system preference
  void setInitialTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // Optional: Method to set theme explicitly
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RuntimeController()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _getAuthStatus() async {
    return await Data().get<bool>(DataKeys.isUserAuth) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes from RuntimeController
    return Consumer<RuntimeController>(
      builder: (context, themeController, _) {
        return FutureBuilder<bool>(
          future: _getAuthStatus(),
          builder: (context, snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Mini Store',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode:
                  themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              initialRoute: pageHome,
              onGenerateRoute: generateRoute,
              navigatorObservers: [routeObserver],
            );
          },
        );
      },
    );
  }
}
