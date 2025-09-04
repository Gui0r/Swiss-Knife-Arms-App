import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  final TextEditingController _passwordController = TextEditingController();
  int _passwordLength = 12;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  bool _excludeSimilar = false;
  bool _excludeAmbiguous = false;
  double _passwordStrength = 0.0;
  String _strengthText = '';

  final String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  final String _numbers = '0123456789';
  final String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  final String _similar = 'il1Lo0O';
  final String _ambiguous = '{}[]()/\\\'"`~,;.<>';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    String charset = '';
    
    if (_includeUppercase) charset += _uppercase;
    if (_includeLowercase) charset += _lowercase;
    if (_includeNumbers) charset += _numbers;
    if (_includeSymbols) charset += _symbols;
    
    if (charset.isEmpty) {
      _passwordController.text = 'Selecione pelo menos um tipo de caractere';
      return;
    }

    if (_excludeSimilar) {
      for (int i = 0; i < _similar.length; i++) {
        charset = charset.replaceAll(_similar[i], '');
      }
    }

    if (_excludeAmbiguous) {
      for (int i = 0; i < _ambiguous.length; i++) {
        charset = charset.replaceAll(_ambiguous[i], '');
      }
    }

    if (charset.isEmpty) {
      _passwordController.text = 'Charset vazio após exclusões';
      return;
    }

    final random = Random.secure();
    String password = '';
    
    for (int i = 0; i < _passwordLength; i++) {
      password += charset[random.nextInt(charset.length)];
    }

    _passwordController.text = password;
    _calculatePasswordStrength(password);
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    String strengthText = '';

    // Length factor
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.2;
    if (password.length >= 16) strength += 0.1;

    // Character variety
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSymbols = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasUppercase) strength += 0.15;
    if (hasLowercase) strength += 0.15;
    if (hasNumbers) strength += 0.15;
    if (hasSymbols) strength += 0.15;

    // Determine strength text
    if (strength < 0.3) {
      strengthText = 'Muito Fraca';
    } else if (strength < 0.5) {
      strengthText = 'Fraca';
    } else if (strength < 0.7) {
      strengthText = 'Média';
    } else if (strength < 0.9) {
      strengthText = 'Forte';
    } else {
      strengthText = 'Muito Forte';
    }

    setState(() {
      _passwordStrength = strength;
      _strengthText = strengthText;
    });
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.3) return const Color(0xFFFF6B6B);
    if (_passwordStrength < 0.5) return const Color(0xFFFFA726);
    if (_passwordStrength < 0.7) return const Color(0xFFFFD54F);
    if (_passwordStrength < 0.9) return const Color(0xFF81C784);
    return const Color(0xFF4CAF50);
  }

  void _copyPassword() {
    if (_passwordController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _passwordController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Senha copiada para a área de transferência!'),
          backgroundColor: const Color(0xFF6C5CE7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Senhas Pro'),
        backgroundColor: const Color(0xFF2D3436),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D3436),
              Color(0xFF636E72),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Password Display
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6C5CE7),
                        Color(0xFFA29BFE),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C5CE7).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Senha Gerada:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _copyPassword,
                              icon: const Icon(Icons.copy, color: Colors.white),
                              tooltip: 'Copiar senha',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _passwordController.text,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Força: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _strengthText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getStrengthColor(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _passwordStrength,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Length Slider
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Comprimento da Senha',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B894),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_passwordLength',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF00B894),
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: const Color(0xFF00B894),
                          overlayColor: const Color(0xFF00B894).withOpacity(0.2),
                          valueIndicatorColor: const Color(0xFF00B894),
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: _passwordLength.toDouble(),
                          min: 4,
                          max: 50,
                          divisions: 46,
                          onChanged: (value) {
                            setState(() {
                              _passwordLength = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Character Options
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipos de Caracteres',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        'Maiúsculas (A-Z)',
                        _includeUppercase,
                        (value) {
                          setState(() {
                            _includeUppercase = value;
                          });
                        },
                        const Color(0xFF74B9FF),
                      ),
                      _buildSwitchTile(
                        'Minúsculas (a-z)',
                        _includeLowercase,
                        (value) {
                          setState(() {
                            _includeLowercase = value;
                          });
                        },
                        const Color(0xFF55A3FF),
                      ),
                      _buildSwitchTile(
                        'Números (0-9)',
                        _includeNumbers,
                        (value) {
                          setState(() {
                            _includeNumbers = value;
                          });
                        },
                        const Color(0xFF00B894),
                      ),
                      _buildSwitchTile(
                        'Símbolos (!@#...)',
                        _includeSymbols,
                        (value) {
                          setState(() {
                            _includeSymbols = value;
                          });
                        },
                        const Color(0xFFFF7675),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Exclusion Options
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opções de Exclusão',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSwitchTile(
                        'Excluir caracteres similares (il1Lo0O)',
                        _excludeSimilar,
                        (value) {
                          setState(() {
                            _excludeSimilar = value;
                          });
                        },
                        const Color(0xFFFDCB6E),
                      ),
                      _buildSwitchTile(
                        'Excluir caracteres ambíguos ({[()]})',
                        _excludeAmbiguous,
                        (value) {
                          setState(() {
                            _excludeAmbiguous = value;
                          });
                        },
                        const Color(0xFFE17055),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Generate Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00B894),
                        Color(0xFF00CEC9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B894).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _generatePassword,
                      borderRadius: BorderRadius.circular(16),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Gerar Nova Senha',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tips
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDCB6E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lightbulb,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Dicas de Segurança',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '• Use pelo menos 12 caracteres\n'
                        '• Combine maiúsculas, minúsculas, números e símbolos\n'
                        '• Evite palavras do dicionário\n'
                        '• Não reutilize senhas entre contas\n'
                        '• Use um gerenciador de senhas\n'
                        '• Ative autenticação de dois fatores quando possível',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? color.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? color : Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            activeTrackColor: color.withOpacity(0.3),
            inactiveThumbColor: Colors.white.withOpacity(0.5),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
