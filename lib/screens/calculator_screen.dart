import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  bool _isScientificMode = false;
  bool _isNewOperation = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (_isNewOperation && value != 'C' && value != 'CE' && value != '±' && value != '%') {
        _display = '';
        _expression = '';
        _isNewOperation = false;
      }

      switch (value) {
        case 'C':
          _display = '0';
          _expression = '';
          _isNewOperation = true;
          break;
        case 'CE':
          if (_display.length > 1) {
            _display = _display.substring(0, _display.length - 1);
          } else {
            _display = '0';
          }
          break;
        case '±':
          if (_display != '0') {
            if (_display.startsWith('-')) {
              _display = _display.substring(1);
            } else {
              _display = '-$_display';
            }
          }
          break;
        case '=':
          _calculate();
          break;
        case '.':
          if (!_display.contains('.')) {
            _display += '.';
          }
          break;
        case 'sin':
        case 'cos':
        case 'tan':
        case 'log':
        case 'ln':
        case '√':
        case 'x²':
        case 'x³':
        case '1/x':
          _handleScientificFunction(value);
          break;
        default:
          if (_display == '0' && value != '.') {
            _display = value;
          } else {
            _display += value;
          }
      }
    });
  }

  void _handleScientificFunction(String function) {
    try {
      double value = double.parse(_display);
      double result = 0;

      switch (function) {
        case 'sin':
          result = _sin(value);
          break;
        case 'cos':
          result = _cos(value);
          break;
        case 'tan':
          result = _tan(value);
          break;
        case 'log':
          result = _log(value);
          break;
        case 'ln':
          result = _ln(value);
          break;
        case '√':
          result = _sqrt(value);
          break;
        case 'x²':
          result = value * value;
          break;
        case 'x³':
          result = value * value * value;
          break;
        case '1/x':
          result = 1 / value;
          break;
      }

      _display = _formatResult(result);
      _isNewOperation = true;
    } catch (e) {
      _display = 'Erro';
      _isNewOperation = true;
    }
  }

  double _sin(double value) {
    return sin(value * pi / 180);
  }

  double _cos(double value) {
    return cos(value * pi / 180);
  }

  double _tan(double value) {
    return tan(value * pi / 180);
  }

  double _log(double value) {
    return log(value) / ln10;
  }

  double _ln(double value) {
    return log(value);
  }

  double _sqrt(double value) {
    return sqrt(value);
  }

  void _calculate() {
    try {
      _expression = _display;
      _expression = _expression.replaceAll('×', '*');
      _expression = _expression.replaceAll('÷', '/');
      _expression = _expression.replaceAll('π', '3.14159265359');
      _expression = _expression.replaceAll('e', '2.71828182846');

      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      _display = _formatResult(result);
      _isNewOperation = true;
    } catch (e) {
      _display = 'Erro';
      _isNewOperation = true;
    }
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(8).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Pro'),
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _isScientificMode ? const Color(0xFF6C5CE7) : Colors.grey[600],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isScientificMode ? Icons.science : Icons.calculate,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _isScientificMode ? 'Científica' : 'Básica',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isScientificMode,
            activeColor: const Color(0xFF6C5CE7),
            onChanged: (value) {
              setState(() {
                _isScientificMode = value;
                if (value) {
                  _display = '0';
                  _expression = '';
                  _isNewOperation = true;
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E2E),
              Color(0xFF2D2D44),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Display
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2D2D44),
                      Color(0xFF3D3D54),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 18,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _isScientificMode ? _buildScientificButtons() : _buildBasicButtons(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicButtons() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildButton('C', const Color(0xFFFF6B6B), textColor: Colors.white),
        _buildButton('CE', const Color(0xFFFF8E53), textColor: Colors.white),
        _buildButton('±', const Color(0xFFFFA726), textColor: Colors.white),
        _buildButton('÷', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('7', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('8', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('9', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('×', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('4', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('5', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('6', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('-', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('1', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('2', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('3', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('+', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('0', const Color(0xFF4ECDC4), textColor: Colors.white, flex: 2),
        _buildButton('.', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('=', const Color(0xFF00B894), textColor: Colors.white, flex: 2),
      ],
    );
  }

  Widget _buildScientificButtons() {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.1,
      children: [
        _buildButton('C', const Color(0xFFFF6B6B), textColor: Colors.white),
        _buildButton('CE', const Color(0xFFFF8E53), textColor: Colors.white),
        _buildButton('±', const Color(0xFFFFA726), textColor: Colors.white),
        _buildButton('π', const Color(0xFF74B9FF), textColor: Colors.white),
        _buildButton('e', const Color(0xFF74B9FF), textColor: Colors.white),
        _buildButton('sin', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('cos', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('tan', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('log', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('ln', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('√', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('x²', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('x³', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('1/x', const Color(0xFFA29BFE), textColor: Colors.white),
        _buildButton('÷', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('7', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('8', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('9', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('×', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('(', const Color(0xFF74B9FF), textColor: Colors.white),
        _buildButton('4', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('5', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('6', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('-', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton(')', const Color(0xFF74B9FF), textColor: Colors.white),
        _buildButton('1', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('2', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('3', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('+', const Color(0xFF6C5CE7), textColor: Colors.white),
        _buildButton('%', const Color(0xFF74B9FF), textColor: Colors.white),
        _buildButton('0', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('.', const Color(0xFF4ECDC4), textColor: Colors.white),
        _buildButton('=', const Color(0xFF00B894), textColor: Colors.white),
      ],
    );
  }

  Widget _buildButton(String text, Color color, {int flex = 1, Color? textColor}) {
    return GestureDetector(
      onTap: () => _onButtonPressed(text),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                fontSize: text.length > 3 ? 14 : 20,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
