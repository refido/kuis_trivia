import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kuis_trivia/models/category.dart';
import 'package:kuis_trivia/models/question.dart';
import 'package:kuis_trivia/resources/api_provider.dart';
import 'error.dart';
import 'quiz_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category category;

  const QuizOptionsDialog({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  QuizOptionsDialogState createState() => QuizOptionsDialogState();
}

class QuizOptionsDialogState extends State<QuizOptionsDialog> {
  late int _noOfQuestions;
  late String _difficulty;
  late bool processing;

  static const myColorOption = Color.fromARGB(255, 212, 170, 125);
  static const myColorSelect = Color.fromARGB(255, 255, 175, 240);

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.purple,
            child: Text(
              widget.category.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const Text("Select Total Number of Questions"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: const Text("10"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _noOfQuestions == 10 ? myColorSelect : myColorOption,
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: const Text("20"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _noOfQuestions == 20 ? myColorSelect : myColorOption,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: const Text("30"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _noOfQuestions == 30 ? myColorSelect : myColorOption,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: const Text("40"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _noOfQuestions == 40 ? myColorSelect : myColorOption,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: const Text("50"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _noOfQuestions == 50 ? myColorSelect : myColorOption,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text("Select Difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 0.0),
                ActionChip(
                  label: const Text("Easy"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _difficulty == "easy" ? myColorSelect : myColorOption,
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: const Text("Medium"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _difficulty == "medium" ? myColorSelect : myColorOption,
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: const Text("Hard"),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  backgroundColor:
                      _difficulty == "hard" ? myColorSelect : myColorOption,
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          processing
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.flagCheckered,
                  ),
                  onPressed: _startQuiz,
                  label: const Text("Start Quiz"),
                ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions = await getQuestions(
        widget.category,
        _noOfQuestions,
        _difficulty,
      );
      await Future.delayed(
        const Duration(seconds: 1),
      );
      if (!mounted) return;
      Navigator.pop(context);
      if (questions.isEmpty) {
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: const ErrorPage(
              message:
                  "There are not enough questions in the category, with the options you selected.",
              key: null,
            ),
          ),
        );
        return;
      }
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: QuizPage(
            questions: questions,
            category: widget.category,
          ),
        ),
      );
    } on SocketException catch (_) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const ErrorPage(
            message:
                "Can't reach the servers, \n Please check your internet connection.",
          ),
        ),
      );
    } catch (e) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const ErrorPage(
            message: "Unexpected error trying to connect to the API",
          ),
        ),
      );
    }
    setState(() {
      processing = false;
    });
  }
}
