import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/dio/services/auth_service.dart';
import 'package:ministore/util/data.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _awaitingOtp = false;
  String? _email;

  String? get email => _email;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get awaitingOtp => _awaitingOtp;

  AuthProvider();

  Future<void> login(String email, String password, {Function? onError}) async {
    _isLoading = true;
    _error = null;
    _awaitingOtp = false;
    notifyListeners();

    try {
      final LoginResp response = await AuthService().login(
        LoginReq(email: email, password: password),
      );
      print("Login response: ${response}");
      if (response.success) {
        print("Login successful");
        Data().put<LoginData>(DataKeys.userAuth, response.data);
        Data().put<User>(DataKeys.userInfo, response.data.user);
        Data().put<bool>(DataKeys.isUserAuth, true);
        _awaitingOtp = false;
        _email = null;
        _isLoading = false;
        notifyListeners();
        return;
      }
      // if (response.requiresOtp) {
      //   _awaitingOtp = true;
      //   _email = email;
      // } else {
      //   // Login success, handle accordingly
      // }
    } catch (e) {
      print(e);
      _error = "Login failed";
      throw Exception("Login failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate logout process
      await Future.delayed(const Duration(seconds: 1));
      Data().put<bool>(DataKeys.isUserAuth, false);
      Data().removeAll();
      _awaitingOtp = false;
      _email = null;
    } catch (e) {
      _error = "Logout failed";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // try {
    //   final res = await api.verifyOtp(OtpRequest(email: _email!, otp: otp));
    //   if (res.response.statusCode == 200) {
    //     _awaitingOtp = false;
    //     _email = null;
    //     _isLoading = false;
    //     notifyListeners();
    //     return true;
    //   } else {
    //     _error = "OTP verification failed";
    //   }
    // } catch (e) {
    //   _error = "OTP verification failed";
    // }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
