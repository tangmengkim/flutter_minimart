import 'package:flutter/material.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/provider/authProvider.dart';
import 'package:ministore/route_page.dart';
import 'package:ministore/util/data.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final fetchedUser =
          await Data().get<User>(DataKeys.userInfo, fromJson: User.fromJson);
      setState(() {
        user = fetchedUser;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _onResetPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset password tapped')),
    );
  }

  void _onDisplaySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Display settings tapped')),
    );
  }

  void _onLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.logout();
      if (!mounted) return;
      Navigator.of(context).restorablePushNamedAndRemoveUntil(
          pageHome, (Route<dynamic> route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user?.name ?? 'Guest User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.display_settings),
            title: const Text('Display Settings'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _onDisplaySettings(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Reset Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _onResetPassword(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _onLogout(context),
          ),
        ],
      ),
    );
  }
}
