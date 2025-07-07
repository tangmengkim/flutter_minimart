import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/provider/auth_provider.dart';
import 'package:ministore/views/home/cart_page.dart';
import 'package:ministore/views/home/custom_bottom_appBar.dart';
import 'package:ministore/views/home/home_page.dart';
import 'package:ministore/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class PageViewController extends StatefulWidget {
  const PageViewController({Key? key}) : super(key: key);

  @override
  State<PageViewController> createState() => _PageViewControllerState();
}

class _PageViewControllerState extends State<PageViewController> {
  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController();
  User? user;
  String? role;

  int _currentPage = 0;

  final List<Widget> _pages = [HomePage(), CartPage(), ProfilePage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      final userProvider = Provider.of<AuthProvider>(context, listen: false);
      user = userProvider.currentUser;
      role =
          (user?.role == 'shop_owner' || user?.role == 'cashier')
              ? 'Sell'
              : 'Cart';

      _currentPage = index;
      // _controller.jumpTo(_currentPage);
    });
  }

  void _onBottomNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = userProvider.currentUser;

    final String cartLabel =
        (user?.role == 'shop_owner' || user?.role == 'cashier')
            ? 'Sell'
            : 'Cart';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(
        notchBottomBarController: _controller,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home, color: Theme.of(context).iconTheme.color),
            activeItem: Icon(Icons.home, color:Theme.of(context).iconTheme.color),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.shopping_cart, color:Theme.of(context).iconTheme.color),
            activeItem: Icon(Icons.shopping_cart, color: Theme.of(context).iconTheme.color),
            itemLabel: 'Cart',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
            activeItem: Icon(Icons.person, color:Theme.of(context).iconTheme.color),
            itemLabel: 'Profile',
          ),
        ],
        onTabSelected: (int index) {
          _onBottomNavTap(index);
          // _controller.jumpTo(index);
          setState(() {});
        },
      ),
    );
  }
}
