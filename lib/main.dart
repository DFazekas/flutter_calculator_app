import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final double activeFontSize = 48.0;
  final double inactiveFontSize = 38.0;

  String equation = "0"; // Displayed equation.
  String result = "0"; // Displayed result.
  double equationFontSize = 38.0; // Equation font size.
  double resultFontSize = 48.0; // Result font size.
  Color resultColor = Colors.black54;

  /// Delegates calculator button behaviour.
  buttonPressed(String buttonText) {
    setState(() {
      // Reset result color.
      resultColor = Colors.black54;

      if (buttonText == "C") {
        // Clear the equation and result, setting result active.
        equation = "0";
        result = "0";
        equationFontSize = inactiveFontSize;
        resultFontSize = activeFontSize;
      } else if (buttonText == "⌫") {
        // Remove last entry, setting equation active.
        equationFontSize = activeFontSize;
        resultFontSize = inactiveFontSize;
        equation = equation.substring(0, equation.length - 1);

        // Reset equation to "0" if empty.
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        // Evaluating current equation, display in active result.
        equationFontSize = inactiveFontSize;
        resultFontSize = activeFontSize;

        // Replace "×" and "÷" with "*" and "/" symbols for evaluation.
        String _expression = equation;
        _expression = _expression.replaceAll("×", "*");
        _expression = _expression.replaceAll("÷", "/");

        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          result = "${exp.evaluate(EvaluationType.REAL, cm)}";
        } catch (e) {
          resultColor = Colors.redAccent;
          result = "Error";
        }
      } else {
        // Update font sizes.
        equationFontSize = 48.0;
        resultFontSize = 38.0;

        // Remove leading zeros.
        if (equation == "0") {
          if (buttonText != "00") {
            equation = buttonText;
          }
        } else {
          equation = equation + buttonText;
        }
      }
      if (result == "Error") {
        result = equation;
      }
    });
  }

  /// Button assembly helper function.
  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () => buttonPressed(buttonText),
        padding: EdgeInsets.all(16.0),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: this.equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              result,
              style: TextStyle(
                  fontSize: this.resultFontSize, color: this.resultColor),
            ),
          ),
          Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Colors.redAccent),
                      buildButton("⌫", 1, Colors.blue),
                      buildButton("×", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.black54),
                      buildButton("8", 1, Colors.black54),
                      buildButton("9", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.black54),
                      buildButton("5", 1, Colors.black54),
                      buildButton("6", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.black54),
                      buildButton("2", 1, Colors.black54),
                      buildButton("3", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton(".", 1, Colors.black54),
                      buildButton("0", 1, Colors.black54),
                      buildButton("00", 1, Colors.black54),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [buildButton("÷", 1, Colors.blue)]),
                    TableRow(children: [buildButton("-", 1, Colors.blue)]),
                    TableRow(children: [buildButton("+", 1, Colors.blue)]),
                    TableRow(children: [buildButton("=", 2, Colors.redAccent)])
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
