import 'package:flutter/material.dart';
import 'package:ministore/provider/authProvider.dart';
import 'package:ministore/views/auth/login.dart';
import 'package:provider/provider.dart';

// Example of a simple ChangeNotifier for runtime control
class RuntimeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RuntimeController()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<RuntimeController>().isDarkMode;
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const HomeWithTabs(),
    );
  }
}

class HomeWithTabs extends StatelessWidget {
  const HomeWithTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Runtime Control'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: const Text('Toggle Theme'),
              ),
            ),
            const Center(child: Text('Second Tab')),
          ],
        ),
      ),
    );
  }
}
