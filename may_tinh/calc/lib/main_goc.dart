// =============================================
// ỨNG DỤNG MÁY TÍNH ĐƠN GIẢN SỬ DỤNG FLUTTER
// ---------------------------------------------
// File: calculator_with_comments.dart
// Mục tiêu: Minh hoạ cách xây dựng UI + logic
// cho máy tính cơ bản + giải thích chi tiết.
// =============================================

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// Hàm main – điểm khởi chạy ứng dụng
void main() {
  runApp(const MyApp());
}

/**********************
 *  LỚP MYAPP (ROOT)  *
 **********************/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // build() tạo widget gốc của ứng dụng
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      // ThemeData quy định chủ đề màu sắc chung
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const CalculatorView(), // Trang chính hiển thị Calculator
    );
  }
}

/*********************************
 *  WIDGET CALCULATOR (STATEFUL) *
 *********************************/
class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

// State chứa toàn bộ logic + UI biến đổi theo thời gian
class _CalculatorViewState extends State<CalculatorView> {
  /* -------------------------------------------
   * BIẾN TRẠNG THÁI
   * ------------------------------------------- */
  String equation = "0"; // Phần biểu thức người dùng đang nhập
  String result = "0"; // Kết quả hiển thị
  String expression = ""; // Biểu thức convert cho math_expressions

  // Kích thước font (có thể dùng để phóng to/thu nhỏ tuỳ trường hợp)
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  /* -------------------------------------------
   * HÀM XỬ LÝ SỰ KIỆN BẤM NÚT
   * ------------------------------------------- */
  void buttonPressed(String buttonText) {
    // Hàm con: loại bỏ phần thập phân ".0" nếu không cần thiết
    String doesContainDecimal(dynamic value) {
      if (value.toString().contains('.')) {
        List<String> splitDecimal = value.toString().split('.');
        // Nếu phần thập phân chỉ toàn số 0 → bỏ đi
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return splitDecimal[0];
        }
      }
      return value.toString();
    }

    // Cập nhật UI
    setState(() {
      switch (buttonText) {
        case "AC": // Reset mọi thứ
          equation = "0";
          result = "0";
          break;

        case "⌫": // Xoá 1 ký tự cuối
          equation = equation.substring(0, equation.length - 1);
          if (equation.isEmpty) equation = "0";
          break;

        case "+/-": // Đảo dấu số (âm/dương)
          if (equation.startsWith('-')) {
            equation = equation.substring(1);
          } else {
            equation = '-$equation';
          }
          break;

        case "=": // Tính toán kết quả
          // Thay ký hiệu ×, ÷ thành * và /
          expression = equation.replaceAll('×', '*').replaceAll('÷', '/');
          try {
            Parser p = Parser();
            Expression exp = p.parse(expression);
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm).toString();

            // Bỏ ".0" nếu là số nguyên
            if (expression.contains('%')) {
              result = doesContainDecimal(result);
            }
          } catch (e) {
            result = "Error"; // Trường hợp nhập sai biểu thức
          }
          break;

        default: // Thêm ký tự mới vào equation
          equation = (equation == "0") ? buttonText : equation + buttonText;
      }
    });
  }

  /* -------------------------------------------
   * WIDGET TẠO NÚT (TÁI SỬ DỤNG)
   * ------------------------------------------- */
  Widget calcButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      width: 75,
      height: text == '=' ? 150 : 70, // Nút '=' cao gấp đôi
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 27, color: Colors.white),
        ),
      ),
    );
  }

  /* -------------------------------------------
   * BUILD() – GIAO DIỆN CHÍNH
   * ------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        leading: const Icon(Icons.settings, color: Colors.orange),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Text('Máy Tính', style: TextStyle(color: Colors.white38)),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Đẩy keypad xuống dưới
          children: [
            /* ---------------------
             * KHU VỰC HIỂN THỊ KQ
             * --------------------- */
            Align(
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Dòng hiển thị RESULT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            result,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 80,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.more_vert,
                          color: Colors.orange,
                          size: 30,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    // Dòng hiển thị EQUATION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            equation,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        // Nút backspace
                        IconButton(
                          icon: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.orange,
                            size: 30,
                          ),
                          onPressed: () => buttonPressed("⌫"),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /* ---------------------
             * CÁC HÀNG NÚT CHỨC NĂNG
             * --------------------- */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('AC', Colors.white10, () => buttonPressed('AC')),
                calcButton('%', Colors.white10, () => buttonPressed('%')),
                calcButton('÷', Colors.white10, () => buttonPressed('÷')),
                calcButton('×', Colors.white10, () => buttonPressed('×')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('7', Colors.white24, () => buttonPressed('7')),
                calcButton('8', Colors.white24, () => buttonPressed('8')),
                calcButton('9', Colors.white24, () => buttonPressed('9')),
                calcButton('-', Colors.white10, () => buttonPressed('-')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('4', Colors.white24, () => buttonPressed('4')),
                calcButton('5', Colors.white24, () => buttonPressed('5')),
                calcButton('6', Colors.white24, () => buttonPressed('6')),
                calcButton('+', Colors.white10, () => buttonPressed('+')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /* Cột bên trái gồm 2 hàng nhỏ: 1-2-3 và +/- 0 . */
                Column(
                  children: [
                    Row(
                      children: [
                        calcButton(
                          '1',
                          Colors.white24,
                          () => buttonPressed('1'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        calcButton(
                          '2',
                          Colors.white24,
                          () => buttonPressed('2'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        calcButton(
                          '3',
                          Colors.white24,
                          () => buttonPressed('3'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        calcButton(
                          '+/-',
                          Colors.white24,
                          () => buttonPressed('+/-'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        calcButton(
                          '0',
                          Colors.white24,
                          () => buttonPressed('0'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        calcButton(
                          '.',
                          Colors.white24,
                          () => buttonPressed('.'),
                        ),
                      ],
                    ),
                  ],
                ),
                // Nút '=' (cao gấp đôi) đặt bên phải
                calcButton('=', Colors.orange, () => buttonPressed('=')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
