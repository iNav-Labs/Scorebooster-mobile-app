// custom_widgets/login_container.dart
import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
