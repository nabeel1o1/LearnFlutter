import 'package:flutter/material.dart';
import 'package:flutteroid_app/quiz_app/answer_button.dart';
import 'package:flutteroid_app/quiz_app/data/questions.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[0];
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('The question...'),
          const SizedBox(
            height: 30,
          ),
          ...currentQuestion.answers.map(
            (answer) {
              return AnswerButton(answer: answer, onSelectAnswer: () {});
            },
          ),
        ],
      ),
    );
  }
}
