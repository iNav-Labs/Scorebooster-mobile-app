import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(
        image: AssetImage('assets/loader.gif'),
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
    );
  }
}