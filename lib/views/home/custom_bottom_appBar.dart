import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class CustomBottomAppBar extends StatelessWidget {
  final NotchBottomBarController notchBottomBarController;
  final ValueChanged<int>? onTabSelected;
  final List<BottomBarItem> bottomBarItems;

  const CustomBottomAppBar({
    super.key,
    required this.notchBottomBarController,
    required this.bottomBarItems,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      showBlurBottomBar: true,
      removeMargins: true,
      notchBottomBarController: notchBottomBarController,
      bottomBarItems: bottomBarItems,
      color: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
      notchColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
      onTap: (int index) {
        if (onTabSelected != null) {
          onTabSelected!(index);
        }
      },
      kIconSize: 24.0,
      kBottomRadius: 16.0,
    );
  }
}
