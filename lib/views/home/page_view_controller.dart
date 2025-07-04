import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/views/home/custom_bottom_appBar.dart';
import 'package:ministore/views/home/home_page.dart';

class PageViewController extends StatefulWidget {
  const PageViewController({Key? key}) : super(key: key);

  @override
  State<PageViewController> createState() => _PageViewControllerState();
}

class _PageViewControllerState extends State<PageViewController> {
  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController();
  User? user;

  int _currentPage = 0;

  final List<Widget> _pages = [
    HomePage(),
    Center(child: Text('Page 2', style: TextStyle(fontSize: 24))),
    Center(child: Text('Page 3', style: TextStyle(fontSize: 24))),
  ];

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
          const BottomBarItem(
            inActiveItem: Icon(Icons.home, color: Colors.blueGrey),
            activeItem: Icon(Icons.home, color: Colors.blue),
            itemLabel: 'Home',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.shopping_cart, color: Colors.blueGrey),
            activeItem: Icon(Icons.shopping_cart, color: Colors.blue),
            itemLabel: 'Cart',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.blueGrey),
            activeItem: Icon(Icons.person, color: Colors.blue),
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
