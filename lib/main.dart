import 'package:flutter/material.dart';
import 'package:ministore/provider/authProvider.dart';
import 'package:ministore/provider/productProvider.dart';
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
    _isDarkMode = !_isDarkMode;
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
    final isDarkMode = context.watch<RuntimeController>().isDarkMode;
    // final RouteObserver<ModalRoute<void>> routeObserver =
    //     RouteObserver<ModalRoute<void>>();

    return FutureBuilder<bool>(
      future: _getAuthStatus(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          // home: isAuth ? const HomePage() : const LoginPage(),
          // home: PageViewController(),
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: pageHome,
          onGenerateRoute: generateRoute,
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
}
