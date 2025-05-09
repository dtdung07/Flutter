// Ứng dụng Quizzee - Trò chơi hỏi đáp True/False.
// Bản này đã được thêm chú thích chi tiết (tiếng Việt) và
// chuyển đổi một số nhãn/giao diện từ tiếng Anh sang tiếng Việt.
// **Lưu ý:** Phần logic và cấu trúc code gốc được giữ nguyên hoàn toàn.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:supercharged/supercharged.dart';

void main() {
  // Hàm khởi chạy ứng dụng Flutter
  runApp(MyApp());
}

/// Widget gốc của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Thiết lập màu thanh trạng thái (status bar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white),
    );

    return MaterialApp(
      title: 'Quizzee Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: QuizPage(), // Màn hình chính
    );
  }
}

//////////////////////////////////////
/// MÔ HÌNH DỮ LIỆU VÀ CÂU HỎI
//////////////////////////////////////

/// Lớp Question: đại diện cho một câu hỏi True/False
class Question {
  String questionText; // Nội dung câu hỏi
  bool questionAnswer; // Đáp án: true = Đúng, false = Sai

  Question(this.questionText, this.questionAnswer);
}

/// Lớp QuizBrain: lưu trữ danh sách câu hỏi và điều khiển luồng câu hỏi
class QuizBrain {
  int _questionNumber = 0; // Chỉ số câu hỏi hiện tại

  // Danh sách câu hỏi (giữ nguyên tiếng Anh để minh họa)
  final List<Question> _questions = [
    Question('Some cats are actually allergic to humans', true),
    Question('You can lead a cow down stairs but not up stairs.', false),
    Question('Approximately one quarter of human bones are in the feet.', true),
    Question('A slug\'s blood is green.', true),
    Question('Buzz Aldrin\'s mother\'s maiden name was "Moon".', true),
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
    Question('Google was originally called "Backrub".', true),
    Question(
      'Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.',
      true,
    ),
    Question(
      'In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.',
      true,
    ),
  ];

  /// Chuyển sang câu hỏi tiếp theo (nếu còn)
  void nextQuestion() {
    if (_questionNumber < _questions.length - 1) {
      _questionNumber++;
    }
  }

  /// Lấy nội dung câu hỏi hiện tại
  String getQuestionText() {
    return _questions[_questionNumber].questionText;
  }

  /// Lấy đáp án câu hỏi hiện tại
  bool getQuestionAnswer() {
    return _questions[_questionNumber].questionAnswer;
  }

  /// Kiểm tra đã đến câu hỏi cuối cùng hay chưa
  bool isFinished() {
    if (_questionNumber == _questions.length - 1) {
      // Debug log
      print('Đã hoàn thành!');
      return true;
    } else {
      print('Chưa hoàn thành!');
      return false;
    }
  }

  /// Đặt lại chỉ số về câu hỏi đầu tiên
  void reset() {
    _questionNumber = 0;
  }

  int getTotalQuestions() {
    return _questions.length;
  }
}

//////////////////////////////////////
/// WIDGET HIỂN THỊ
//////////////////////////////////////

/// Khung hiển thị nội dung câu hỏi
class QuestionBox extends StatelessWidget {
  final String question;

  const QuestionBox({required this.question, Key? key}) : super(key: key);

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

/// Nút trả lời Đúng/Sai
class AnswerButton extends StatelessWidget {
  final bool answer; // True = Đúng, False = Sai
  final VoidCallback onTap; // Hàm xử lý khi nhấn

  const AnswerButton({required this.answer, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        answer ? 'Đúng' : 'Sai',
        style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 64.0),
        backgroundColor: answer ? Colors.greenAccent : Colors.redAccent,
        foregroundColor: answer ? Colors.green[600] : Colors.white,
      ),
    );
  }
}

//////////////////////////////////////
/// MÀN HÌNH CHÍNH
//////////////////////////////////////

QuizBrain quizBrain = QuizBrain(); // Đối tượng điều khiển câu hỏi

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Danh sách icon kết quả (đúng/sai) hiển thị trên đầu màn hình
  List<Widget> scoreKeeper = [];
  int correctAnswers = 0;

  /// Kiểm tra đáp án người dùng
  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();

    setState(() {
      // Nếu đã tới câu hỏi cuối
      if (quizBrain.isFinished()) {
        // Kiểm tra câu trả lời cuối cùng trước khi hiển thị kết quả
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(markIcon(true));
          correctAnswers++;
        } else {
          scoreKeeper.add(markIcon(false));
        }

        // Tính số câu đúng
        double scorePercentage =
            (correctAnswers / quizBrain.getTotalQuestions()) * 100;

        // Show alert
        Alert(
          context: context,
          title: 'Kết quả',
          desc:
              'Bạn đã trả lời đúng $correctAnswers/${quizBrain.getTotalQuestions()} câu hỏi (${scorePercentage.toStringAsFixed(1)}%)',
          image: const Icon(
            Icons.emoji_events,
            size: 64.0,
            color: Colors.amber,
          ),
          buttons: [
            DialogButton(
              child: Text(
                'Làm lại',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () {
                // Đóng cảnh báo
                Navigator.pop(context);

                // Đặt lại câu hỏ
                quizBrain.reset();
                // Xóa trình giữ điểm
                scoreKeeper.clear();
                // Đặt lại số câu trả lời đúng
                correctAnswers = 0;
              },
            ),
          ],
        ).show();
      } else {
        // Thêm icon kết quả cho câu hiện tại
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(markIcon(true));
          correctAnswers++;
        } else {
          scoreKeeper.add(markIcon(false));
        }

        // Chuyển sang câu tiếp theo
        quizBrain.nextQuestion();
      }
    });
  }

  /// Icon minh họa đúng / sai
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
            // Dãy icon kết quả
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(children: scoreKeeper),
            ),
            // Khung câu hỏi
            QuestionBox(question: quizBrain.getQuestionText()),
            // Hai nút Đúng / Sai
            Container(
              padding: const EdgeInsets.only(top: 32.0),
              child: Column(
                children: [
                  // Nút Đúng
                  AnswerButton(
                    onTap: () {
                      checkAnswer(true);
                    },
                    answer: true,
                  ),
                  const SizedBox(height: 16.0),
                  // Nút Sai
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
