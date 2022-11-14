import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:kuis_trivia/models/question.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  static const myColorBG = Color.fromARGB(255, 39, 39, 39);
  static const myColorCardBG = Color.fromARGB(255, 212, 170, 125);

  const CheckAnswersPage({
    Key? key,
    required this.questions,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Answers'),
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
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return ElevatedButton.icon(
        icon: const Icon(
          FontAwesomeIcons.check,
        ),
        label: const Text("Done"),
        onPressed: () {
          Navigator.of(context).popUntil(
            ModalRoute.withName(Navigator.defaultRouteName),
          );
        },
      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      color: myColorCardBG,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.question),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              HtmlUnescape().convert("${answers[index]}"),
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: "Answer: "),
                      TextSpan(
                          text: HtmlUnescape().convert(question.correctAnswer),
                          style: const TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: const TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
