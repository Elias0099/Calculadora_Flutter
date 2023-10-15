import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator Neumorphism',
      home: CalculatorNeuApp(),
    );
  }
}

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);
const double piValue = 3.14159265359;

class CalculatorNeuApp extends StatefulWidget {
  @override
  _CalculatorNeuAppState createState() => _CalculatorNeuAppState();
}

class _CalculatorNeuAppState extends State<CalculatorNeuApp> {
  bool darkMode = false;
  String equation = "";
  String result = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "";
        result = "";
      } else if (buttonText == "=") {
        if (equation.contains("π")) {
          equation = equation.replaceAll("π", "3.14159");
        }
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else if (buttonText == "⌫") {
        // Cambia el texto del botón a "⌫" (icono de retroceso)
        if (equation.isNotEmpty) {
          equation = equation.substring(0, equation.length - 1);
        }
      } else if (buttonText == "√") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          double? number = double.tryParse(result);
          if (number != null) {
            result = '${sqrt(number)}';
          } else {
            result = "Error";
          }
        } catch (e) {
          result = "Error";
        }
      } else if (buttonText == "π") {
        equation += 'π';
      } else if (buttonText == "log") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(equation);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          double? number = double.tryParse(result);
          if (number != null) {
            if (number > 0) {
              result = '${log(number)}';
            } else {
              result = "Error";
            }
          } else {
            result = "Error";
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        equation += buttonText;
      }
    });
  }

  Widget _buttonRounded({
    String title = "",
    double padding = 17,
    IconData? icon,
    Color iconColor = colorDark,
    Color textColor = colorDark,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: () => buttonPressed(title),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: NeuContainer(
          darkMode: darkMode,
          borderRadius: BorderRadius.circular(40),
          padding: EdgeInsets.all(padding),
          child: Container(
            width: padding * 2,
            height: padding * 2,
            child: Center(
              child: icon != null // Verifica si el icono no es nulo
                  ? Icon(
                      icon,
                      color: iconColor,
                      size: 30, // Aumenta el tamaño del icono
                    )
                  : Text(
                      // Usar Text en lugar de Container para mostrar el título
                      '$title',
                      style: TextStyle(
                        color: textColor != null
                            ? textColor
                            : darkMode
                                ? Colors.white
                                : Colors.black,
                        fontSize: 30,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonOval({String title = "", double padding = 17}) {
    return GestureDetector(
      onTap: () => buttonPressed(title),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: NeuContainer(
          darkMode: darkMode,
          borderRadius: BorderRadius.circular(50),
          padding:
              EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
          child: Container(
            width: padding * 2,
            child: Center(
              child: Text(
                '$title',
                style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return GestureDetector(
      onTap: () {
        setState(() {
          darkMode = !darkMode;
        });
      },
      child: NeuContainer(
        darkMode: darkMode,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 70,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(
              Icons.wb_sunny,
              color: darkMode ? Colors.grey : Colors.redAccent,
            ),
            Icon(
              Icons.nightlight_round,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ]),
        ),
      ),
    );
  }

  void deleteCharacter() {
    setState(() {
      if (equation.isNotEmpty) {
        equation = equation.substring(0, equation.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _switchMode(),
                    SizedBox(height: 20),

                    SingleChildScrollView(  
                    scrollDirection: Axis.horizontal,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        equation,
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: darkMode ? Colors.white : Colors.red, ),
                            textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '=',
                          style: TextStyle(
                              fontSize: 35,
                              color: darkMode ? Colors.green : Colors.grey),
                        ),
                        Text(
                          result,
                          style: TextStyle(
                              fontSize: 20,
                              color: darkMode ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonOval(title: '√'),
                      _buttonOval(title: '^'),
                      _buttonOval(title: 'π'),
                      _buttonOval(title: 'log'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonOval(title: 'sin'),
                      _buttonOval(title: 'cos'),
                      _buttonOval(title: 'tan'),
                      _buttonOval(title: '%'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: 'C',
                          textColor:
                              darkMode ? Colors.green : Colors.redAccent),
                      _buttonRounded(
                          title: '(',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: ')',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '/',
                          textColor: darkMode ? Colors.green : Colors.redAccent)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '7',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '8',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '9',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '*',
                          textColor: darkMode ? Colors.green : Colors.redAccent)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '4',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '5',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '6',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '-',
                          textColor: darkMode ? Colors.green : Colors.redAccent)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '1',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '2',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '3',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '+',
                          textColor: darkMode ? Colors.green : Colors.red)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonRounded(
                          title: '0',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                          title: '.',
                          textColor: darkMode
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.redAccent),
                      _buttonRounded(
                        icon: Icons.backspace_outlined,
                        title: "⌫",
                        iconColor: darkMode ? Colors.green : Colors.redAccent,
                        onPressed: deleteCharacter,
                      ),
                      _buttonRounded(
                          title: '=',
                          textColor: darkMode ? Colors.green : Colors.redAccent)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NeuContainer extends StatefulWidget {
  final bool darkMode;
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  NeuContainer({
    this.darkMode = false,
    this.child = const Text('This is a NeuContainer'),
    this.borderRadius = const BorderRadius.all(Radius.circular(23.0)),
    this.padding = const EdgeInsets.all(18),
  });

  @override
  _NeuContainerState createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
            color: darkMode ? colorDark : colorLight,
            borderRadius: widget.borderRadius,
            boxShadow: _isPressed
                ? null
                : [
                    BoxShadow(
                      color:
                          darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    BoxShadow(
                        color:
                            darkMode ? Colors.blueGrey.shade700 : Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0)
                  ]),
        child: widget.child,
      ),
    );
  }
}
