import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  // Example data
  String _serviceStatus = 'inactive';

  String get serviceStatus => _serviceStatus;

  void activateService() {
    _serviceStatus = 'active';
    notifyListeners();
  }

  void deactivateService() {
    _serviceStatus = 'inactive';
    notifyListeners();
  }
}
