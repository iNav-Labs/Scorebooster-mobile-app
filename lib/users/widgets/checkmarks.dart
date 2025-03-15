import 'package:flutter/material.dart';

// ignore: camel_case_types
class checkmarks extends StatefulWidget {
  const checkmarks({
    required this.status,
    super.key,
    required this.count,
  });
  final String status;
  final int count;

  @override
  State<checkmarks> createState() => _checkmarksState();
}

// ignore: camel_case_types
class _checkmarksState extends State<checkmarks> {
  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case 'saved':
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${widget.count}', style: TextStyle(color: Colors.white)),
          // child: Icon(Icons.check, color: Colors.white),
        );
      case 'reviewAndSaved':
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${widget.count}', style: TextStyle(color: Colors.white)),
        );
      case 'review':
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.orange[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${widget.count}', style: TextStyle(color: Colors.white)),
        );
      case 'clear':
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${widget.count}', style: TextStyle(color: Colors.white)),
        );
      default:
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${widget.count}', style: TextStyle(color: Colors.white)),
        );
    }
  }
}
