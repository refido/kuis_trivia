import 'package:flutter/material.dart';
import 'package:kuis_trivia/models/category.dart';
import 'package:kuis_trivia/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({
    Key? key,
    required this.questions,
    required this.category,
  }) : super(key: key);

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  static const myColorBG = Color.fromARGB(255, 39, 39, 39);
  static const myColorSelect = Color.fromARGB(255, 255, 175, 240);

  final TextStyle _questionStyle = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.category.name,
          ),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: const BoxDecoration(
                  color: myColorBG,
                ),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${_currentIndex + 1}",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              widget.questions[_currentIndex].question),
                          softWrap: true,
                          style: MediaQuery.of(context).size.width > 800
                              ? _questionStyle.copyWith(fontSize: 30.0)
                              : _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map(
                          (option) => RadioListTile(
                            title: Text(
                              HtmlUnescape().convert("$option"),
                              style: MediaQuery.of(context).size.width > 800
                                  ? const TextStyle(fontSize: 30.0)
                                  : null,
                            ),
                            groupValue: _answers[_currentIndex],
                            value: option,
                            activeColor: myColorSelect,
                            onChanged: (value) {
                              setState(() {
                                _answers[_currentIndex] = option;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 64.0,
                        ),
                        child: ElevatedButton(
                          onPressed: _nextSubmit,
                          child: Text(
                            _currentIndex == (widget.questions.length - 1)
                                ? "Submit"
                                : "Next",
                            style: MediaQuery.of(context).size.width > 800
                                ? const TextStyle(fontSize: 30.0)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("You must select an answer to continue."),
        ),
      );
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              QuizFinishedPage(questions: widget.questions, answers: _answers),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text(
              "Are you sure you want to quit the quiz? All your progress will be lost.",
            ),
            title: const Text("Warning!"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              ElevatedButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          ),
        )) ??
        false;
  }
}
