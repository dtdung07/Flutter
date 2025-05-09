import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF111328),
      ),
      home: InputPage(),
    );
  }
}

// Constants
const kactiveCardColor = Colors.deepPurple;
const kinactiveCardColor = Color(0xFF1D1E33);
const kbottomContainHeight = 60.0;
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

// Calculator Brain Logic
class CalculatorBrain {
  CalculatorBrain({required this.height, required this.weight});
  final int height;
  final int weight;

  double _bmi = 0.0;

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 25) {
      return 'Over-Weight';
    } else if (_bmi > 18.5) {
      return 'Normal';
    } else {
      return 'Under-Weight';
    }
  }

  String getInterpretation() {
    if (_bmi >= 25) {
      return 'You have a higher than normal body weight. Try to exercise more. 💪';
    } else if (_bmi > 18.5) {
      return 'You have a normal body weight. Good Job! ☺';
    } else {
      return 'You weight falls within the underweight range. You can eat a bit more. ☹';
    }
  }
}

// Reusable Card Component
class ReusableCard extends StatelessWidget {
  ReusableCard({required this.colour, required this.cardChild});
  final Color colour;
  final Widget cardChild;

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

// Icon Content Component
class IconContent extends StatelessWidget {
  IconContent({required this.icon, required this.label});
  final IconData icon;
  final String label;

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

// Enum for Gender Type
enum GenderType { male, female }

// Input Page (Main Screen)
class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int age = 18;
  int height = 180;
  int weight = 60;
  Color maleCardColour = kinactiveCardColor;
  Color femaleCardColour = kinactiveCardColor;

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
            'B.M.I Calculator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                // MALE
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
                        label: 'MALE',
                      ),
                    ),
                  ),
                ),

                // FEMALE
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
                        label: 'FEMALE',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // HEIGHT SLIDER
          Expanded(
            child: ReusableCard(
              colour: kactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('HEIGHT', style: klabelTextStyle),
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

          // WEIGHT AND AGE
          Expanded(
            child: Row(
              children: <Widget>[
                // WEIGHT
                Expanded(
                  child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('WEIGHT', style: klabelTextStyle),
                        Text(weight.toString(), style: knumberTextStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                // AGE
                Expanded(
                  child: ReusableCard(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('AGE', style: klabelTextStyle),
                        Text(age.toString(), style: knumberTextStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

          // CALCULATE BUTTON
          GestureDetector(
            onTap: () {
              CalculatorBrain calc = CalculatorBrain(
                height: height,
                weight: weight,
              );
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
                  child: Text('CALCULATE', style: klargestButtonTextStyle),
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

// Results Page
class ResultsPage extends StatelessWidget {
  ResultsPage({
    required this.bmiResult,
    required this.resultText,
    required this.interpretation,
  });

  final String bmiResult;
  final String resultText;
  final String interpretation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111328),
        title: Text('B.M.I Calculator'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Center(child: Text('Your Result', style: ktitleTextStyle)),
            ),
          ),
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

          // RE-CALCULATE BUTTON
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Card(
                color: Colors.pinkAccent,
                child: Center(
                  child: Text('Re-Calculate', style: klargestButtonTextStyle),
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
