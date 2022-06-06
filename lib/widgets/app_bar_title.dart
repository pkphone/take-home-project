import 'package:flutter/material.dart';
import 'package:take_home_project/res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/firebase_logo.png',
          height: 20,
        ),
        const SizedBox(width: 8),
        const Text(
          'Take Home Project',
          style: TextStyle(
            color: CustomColors.secondary,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
