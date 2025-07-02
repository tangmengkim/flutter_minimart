import 'package:flutter/material.dart';
import 'package:ministore/provider/authProvider.dart';
import 'package:provider/provider.dart';

// 3. Provider

// 4. Login Page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  void _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _submitOtp(BuildContext context) async {
    if (_otpFormKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.verifyOtp(_otpController.text.trim());
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Navigate to home or another page
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.awaitingOtp) {
                return Form(
                  key: _otpFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Enter OTP sent to your email'),
                      TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(labelText: 'OTP'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter OTP' : null,
                      ),
                      const SizedBox(height: 24),
                      if (auth.error != null)
                        Text(
                          auth.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 8),
                      auth.isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => _submitOtp(context),
                              child: const Text('Verify OTP'),
                            ),
                    ],
                  ),
                );
              }
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter password'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    if (auth.error != null)
                      Text(
                        auth.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),
                    auth.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _submit(context),
                            child: const Text('Login'),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
