import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorebooster/users/widgets/divider.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.questions});
  final List<Map<String, dynamic>> questions;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios, color: Colors.black),
        title: Text('Test Results',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 134, 23),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Score",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "85/100",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: CustomDivider(text: "Test Analysis"),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return McqResult(
                    question: widget.questions[index],
                    index: index,
                  );
                })
          ],
        ),
      ),
    );
  }
}

class McqResult extends StatelessWidget {
  const McqResult({
    super.key,
    required this.question,
    required this.index,
  });

  final int index;
  final Map<String, dynamic> question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.start,
            "${index + 1}. ${question['question']}",
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: question['options'].length,
              itemBuilder: (context, option) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: question['selectedAnswer'] ==
                            question['options'][option]
                        ? question['selectedAnswer'] ==
                                question['correctAnswer']
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3)
                        : question['correctAnswer'] == option
                            ? Colors.green.withOpacity(0.3)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: question['selectedAnswer'] == option
                          ? question['selectedAnswer'] ==
                                  question['correctAnswer']
                              ? Colors.green
                              : Colors.red
                          : question['correctAnswer'] == option
                              ? Colors.green
                              : Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${String.fromCharCode(65 + option)}.",
                        style: GoogleFonts.poppins(
                          color: question['selectedAnswer'] == option
                              ? question['selectedAnswer'] ==
                                      question['correctAnswer']
                                  ? Colors.green
                                  : Colors.red
                              : question['correctAnswer'] == option
                                  ? Colors.green
                                  : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          question['options'][option],
                          style: GoogleFonts.poppins(
                            color: question['selectedAnswer'] == option
                                ? question['selectedAnswer'] ==
                                        question['correctAnswer']
                                    ? Colors.green
                                    : Colors.red
                                : question['correctAnswer'] == option
                                    ? Colors.green
                                    : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(height: 10),
          Text(
            "Correct Answer: ${question['correctAnswer']}",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
