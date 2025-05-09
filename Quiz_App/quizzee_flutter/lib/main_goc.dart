import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
    );
    return MaterialApp(
      title: 'Quizzee Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

// Models
class Question {
  String questionText;
  bool questionAnswer;

  Question(this.questionText, this.questionAnswer);
}

// Data
class QuizBrain {
  int _questionNumber = 0;

  List<Question> _questions = [
    Question('Some cats are actually allergic to humans', true),
    Question('You can lead a cow down stairs but not up stairs.', false),
    Question('Approximately one quarter of human bones are in the feet.', true),
    Question('A slug\'s blood is green.', true),
    Question('Buzz Aldrin\'s mother\'s maiden name was \"Moon\".', true),
    Question('It is illegal to pee in the Ocean in Portugal.', true),
    Question(
      'No piece of square dry paper can be folded in half more than 7 times.',
      false,
    ),
    Question(
      'In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.',
      true,
    ),
    Question(
      'The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.',
      false,
    ),
    Question(
      'The total surface area of two human lungs is approximately 70 square metres.',
      true,
    ),
    Question('Google was originally called \"Backrub\".', true),
    Question(
      'Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.',
      true,
    ),
    Question(
      'In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.',
      true,
    ),
  ];

  void nextQuestion() {
    if (_questionNumber < _questions.length - 1) {
      _questionNumber++;
    }
  }

  String getQuestionText() {
    return _questions[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _questions[_questionNumber].questionAnswer;
  }

  bool isFinished() {
    if (_questionNumber == _questions.length - 1) {
      print('It\'s Finish!');
      return true;
    } else {
      print('Not finish yet!');
      return false;
    }
  }

  void reset() {
    _questionNumber = 0;
  }
}

// Widgets
class QuestionBox extends StatelessWidget {
  final String question;
  const QuestionBox({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: 300.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          question,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 20.0),
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final bool answer;
  final Function() onTap;
  const AnswerButton({required this.answer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        answer ? 'True' : 'False',
        style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 64.0),
        backgroundColor: answer ? Colors.greenAccent : Colors.redAccent,
        foregroundColor: answer ? Colors.green[600] : Colors.white,
      ),
    );
  }
}

// Pages
QuizBrain quizBrain = QuizBrain();

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();

    setState(() {
      if (quizBrain.isFinished()) {
        // Show alert
        Alert(
          context: context,
          title: 'Congrats!',
          desc: 'You have reached the last question',
          image: Icon(Icons.emoji_events, size: 64.0, color: Colors.amber),
          buttons: [
            DialogButton(
              child: Text(
                'Okay',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () {
                // Close the alert
                Navigator.pop(context);
              },
            ),
          ],
        ).show();

        // Reset question
        quizBrain.reset();
        // Clear score keeper
        scoreKeeper.clear();
      } else {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(markIcon(true));
        } else {
          scoreKeeper.add(markIcon(false));
        }

        quizBrain.nextQuestion();
      }
    });
  }

  Widget markIcon(bool isCorrect) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        Icons.circle,
        size: 12.0,
        color: isCorrect ? Colors.greenAccent : Colors.red[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#F5F5F7'.toColor(),
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Quizzee', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(children: scoreKeeper),
            ),
            QuestionBox(question: quizBrain.getQuestionText()),
            Container(
              padding: const EdgeInsets.only(top: 32.0),
              child: Column(
                children: [
                  AnswerButton(
                    onTap: () {
                      checkAnswer(true);
                    },
                    answer: true,
                  ),
                  SizedBox(height: 16.0),
                  AnswerButton(
                    onTap: () {
                      checkAnswer(false);
                    },
                    answer: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
