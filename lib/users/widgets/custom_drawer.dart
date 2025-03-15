import 'package:flutter/material.dart';
import 'package:scorebooster/users/widgets/checkmarks.dart';
import 'package:scorebooster/users/widgets/selection_type.dart';

class QuestionListDrawer extends StatelessWidget {
  const QuestionListDrawer({
    super.key,
    required this.questions,
    required this.onTap,
  });
  final void Function(int) onTap;

  final List<Map<String, dynamic>> questions;

  String _getCheckmarkState(Map<String, dynamic> question) {
    if (question['save'] == true && question['markForReview'] == true) {
      return 'reviewAndSaved';
    } else if (question['save'] == true) {
      return 'saved';
    } else if (question['markForReview'] == true) {
      return 'review';
    } else {
      return 'clear';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          selectionType(),
          GridView.count(
            crossAxisCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(
              questions.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    child: checkmarks(
                      status: _getCheckmarkState(questions[index]),
                      count: index + 1,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
