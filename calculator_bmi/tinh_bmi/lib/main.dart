import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

/// Ứng dụng **Máy tính BMI** (Body Mass Index).
///
/// - Người dùng chọn giới tính, nhập chiều cao (cm), cân nặng (kg) và tuổi.
/// - Ứng dụng sẽ tính toán chỉ số BMI và đưa ra phân loại cùng lời khuyên.
/// - Giao diện được thiết kế theo phong cách tối (dark theme).
void main() => runApp(BMICalculator());

/// Widget gốc của toàn bộ ứng dụng.
class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF111328), // Màu nền chung
      ),
      home: InputPage(), // Màn hình nhập dữ liệu
    );
  }
}

// ================================
// HẰNG SỐ DÙNG CHUNG CHO UI
// ================================
const kactiveCardColor = Colors.blueAccent; // Màu thẻ được chọn
const kinactiveCardColor = Color(0xFF1D1E33); // Màu thẻ chưa chọn
const kbottomContainHeight = 60.0; // Chiều cao nút tính BMI

const knumberTextStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900);
const klabelTextStyle = TextStyle(fontSize: 18.0, color: Colors.white);
const klargestButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);
const ktitleTextStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
const kresultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);
const kBMITextStyle = TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold);
const kbodyTextStyle = TextStyle(fontSize: 22.0);

// =================================
// LỚP XỬ LÝ LOGIC TÍNH BMI
// =================================
class CalculatorBrain {
  CalculatorBrain({required this.height, required this.weight});
  final int height; // Chiều cao (cm)
  final int weight; // Cân nặng (kg)

  double _bmi = 0.0; // Giá trị BMI nội bộ

  /// Tính BMI và trả về chuỗi đã làm tròn 1 chữ số thập phân.
  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  /// Phân loại kết quả BMI.
  String getResult() {
    if (_bmi >= 25) {
      return 'Thừa cân';
    } else if (_bmi > 18.5) {
      return 'Bình thường';
    } else {
      return 'Thiếu cân';
    }
  }

  /// Lời khuyên tương ứng với kết quả BMI.
  String getInterpretation() {
    if (_bmi >= 25) {
      return 'Bạn có cân nặng cao hơn bình thường. Hãy tập luyện thêm! 💪';
    } else if (_bmi > 18.5) {
      return 'Bạn có cân nặng bình thường. Tốt lắm! ☺';
    } else {
      return 'Bạn đang thiếu cân. Bạn có thể ăn thêm một chút. ☹';
    }
  }
}

// ==================================================
// WIDGET THẺ DÙNG LẠI (TỰ TẠO) – REUSABLE CARD
// ==================================================
class ReusableCard extends StatelessWidget {
  ReusableCard({required this.colour, required this.cardChild});
  final Color colour; // Màu nền của thẻ
  final Widget cardChild; // Nội dung con

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}

// =============================================
// WIDGET ICON + NHÃN CHO THẺ GIỚI TÍNH
// =============================================
class IconContent extends StatelessWidget {
  IconContent({required this.icon, required this.label});
  final IconData icon; // Icon đại diện
  final String label; // Nhãn hiển thị

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 60.0),
        SizedBox(height: 10.0),
        Text(label, style: klabelTextStyle),
      ],
    );
  }
}

/// Enum đại diện 2 giới tính.
enum GenderType { male, female }

// =======================================
// MÀN HÌNH CHÍNH – NHẬP DỮ LIỆU
// =======================================
class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int age = 18; // Tuổi
  int height = 180; // Chiều cao (cm)
  int weight = 60; // Cân nặng (kg)

  // Màu mặc định cho 2 thẻ
  Color maleCardColour = kinactiveCardColor;
  Color femaleCardColour = kinactiveCardColor;

  /// Cập nhật màu khi chọn giới tính.
  void updateColour(GenderType gender) {
    if (gender == GenderType.male) {
      if (maleCardColour == kinactiveCardColor) {
        maleCardColour = kactiveCardColor;
        femaleCardColour = kinactiveCardColor;
      } else {
        maleCardColour = kinactiveCardColor;
      }
    }

    if (gender == GenderType.female) {
      if (femaleCardColour == kinactiveCardColor) {
        femaleCardColour = kactiveCardColor;
        maleCardColour = kinactiveCardColor;
      } else {
        femaleCardColour = kinactiveCardColor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111328),
        title: Center(
          child: Text(
            'Máy tính BMI', // Tiêu đề ứng dụng
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ----------------- HÀNG CHỌN GIỚI TÍNH -----------------
          Expanded(
            child: Row(
              children: <Widget>[
                // NAM
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        updateColour(GenderType.male);
                      });
                    },
                    child: ReusableCard(
                      colour: maleCardColour,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.mars,
                        label: 'NAM',
                      ),
                    ),
                  ),
                ),

                // NỮ
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        updateColour(GenderType.female);
                      });
                    },
                    child: ReusableCard(
                      colour: femaleCardColour,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.venus,
                        label: 'NỮ',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----------------- SLIDER CHIỀU CAO -----------------
          Expanded(
            child: ReusableCard(
              colour: kactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('CHIỀU CAO', style: klabelTextStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(height.toString(), style: knumberTextStyle),
                      Text('cm'),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      inactiveTrackColor: Colors.grey,
                      activeTrackColor: Colors.white,
                      thumbColor: Colors.pinkAccent,
                      overlayColor: Colors.black54,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 15.0,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 30.0,
                      ),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ----------------- HÀNG CÂN NẶNG & TUỔI -----------------
          Expanded(
            child: Row(
              children: <Widget>[
                // ----------- CÂN NẶNG -----------
                Expanded(
                  child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('CÂN NẶNG', style: klabelTextStyle),
                        Text(weight.toString(), style: knumberTextStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Giảm cân nặng
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              backgroundColor: Colors.black54,
                            ),
                            SizedBox(width: 10.0),
                            // Tăng cân nặng
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              backgroundColor: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ----------- TUỔI -----------
                Expanded(
                  child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TUỔI', style: klabelTextStyle),
                        Text(age.toString(), style: knumberTextStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Giảm tuổi
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              backgroundColor: Colors.black54,
                            ),
                            SizedBox(width: 10.0),
                            // Tăng tuổi
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              backgroundColor: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----------------- NÚT TÍNH BMI -----------------
          GestureDetector(
            onTap: () {
              // Khởi tạo lớp tính toán BMI
              CalculatorBrain calc = CalculatorBrain(
                height: height,
                weight: weight,
              );

              // Chuyển sang màn hình kết quả, truyền dữ liệu cần thiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ResultsPage(
                      bmiResult: calc.calculateBMI(),
                      resultText: calc.getResult(),
                      interpretation: calc.getInterpretation(),
                    );
                  },
                ),
              );
            },
            child: Container(
              child: Card(
                color: Colors.pinkAccent,
                child: Center(
                  child: Text('TÍNH BMI', style: klargestButtonTextStyle),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              height: 70.0,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================
// MÀN HÌNH HIỂN THỊ KẾT QUẢ
// =====================================
class ResultsPage extends StatelessWidget {
  ResultsPage({
    required this.bmiResult,
    required this.resultText,
    required this.interpretation,
  });

  final String bmiResult; // Giá trị BMI
  final String resultText; // Phân loại (Bình thường / Thừa cân / Thiếu cân)
  final String interpretation; // Lời khuyên

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111328),
        title: Text('Máy tính BMI'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tiêu đề
          Expanded(
            child: Container(
              child: Center(child: Text('Kết quả', style: ktitleTextStyle)),
            ),
          ),

          // Thẻ kết quả chính
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: Color(0xFF1D1E33),
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(resultText.toUpperCase(), style: kresultTextStyle),
                  Text(bmiResult, style: kBMITextStyle),
                  Text(
                    interpretation,
                    style: kbodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // NÚT TÍNH LẠI
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Quay lại màn hình trước
            },
            child: Container(
              child: Card(
                color: Colors.pinkAccent,
                child: Center(
                  child: Text('TÍNH LẠI', style: klargestButtonTextStyle),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              height: 70.0,
            ),
          ),
        ],
      ),
    );
  }
}
