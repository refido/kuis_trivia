import 'package:flutter/material.dart';
import 'package:kuis_trivia/models/question.dart';
import 'check_answers.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const QuizFinishedPage({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  State<QuizFinishedPage> createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {
  late int correctAnswers;

  static const myColorBG = Color.fromARGB(255, 154, 72, 208);
  static const myColorBG2 = Color.fromARGB(255, 255, 175, 240);

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    widget.answers.forEach((index, value) {
      if (widget.questions[index].correctAnswer == value) correct++;
    });
    const TextStyle titleStyle = TextStyle(
      color: Colors.black87,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );
    const TextStyle trailingStyle = TextStyle(
      color: myColorBG2,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              myColorBG,
              myColorBG2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text(
                    "Total Questions",
                    style: titleStyle,
                  ),
                  trailing: Text(
                    "${widget.questions.length}",
                    style: trailingStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text("Score", style: titleStyle),
                  trailing: Text(
                    "${correct / widget.questions.length * 100}%",
                    style: trailingStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text(
                    "Correct Answers",
                    style: titleStyle,
                  ),
                  trailing: Text(
                    "$correct/${widget.questions.length}",
                    style: trailingStyle,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text(
                    "Incorrect Answers",
                    style: titleStyle,
                  ),
                  trailing: Text(
                    "${widget.questions.length - correct}/${widget.questions.length}",
                    style: trailingStyle,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Goto Home"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Check Answers"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckAnswersPage(
                              questions: widget.questions,
                              answers: widget.answers,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
