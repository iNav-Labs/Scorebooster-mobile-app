import 'package:flutter/material.dart';
import 'package:scorebooster/users/widgets/checkmarks.dart';

// ignore: camel_case_types
class selectionType extends StatelessWidget {
  const selectionType({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Text(
              'Score Booster',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 33, 105),
                fontSize: 24,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                checkmarks(
                  status: 'saved',
                  count: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Answer is Saved"),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                checkmarks(
                  status: 'review',
                  count: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Marked for Review"),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                checkmarks(
                  status: 'reviewAndSaved',
                  count: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Marked for Review Saved"),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                checkmarks(
                  status: 'clear',
                  count: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Not Answered"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
