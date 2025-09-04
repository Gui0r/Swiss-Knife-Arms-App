import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/responsive_layout.dart';

class MeasureConverterScreen extends StatefulWidget {
  const MeasureConverterScreen({super.key});

  @override
  State<MeasureConverterScreen> createState() => _MeasureConverterScreenState();
}

class _MeasureConverterScreenState extends State<MeasureConverterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'Comprimento';
  String _fromUnit = 'Metro (m)';
  String _toUnit = 'Pé (ft)';
  String _result = '';

  final Map<String, Map<String, double>> _conversionFactors = {
    'Comprimento': {
      'Metro (m)': 1.0,
      'Pé (ft)': 3.28084,
      'Polegada (in)': 39.3701,
      'Jarda (yd)': 1.09361,
      'Milha (mi)': 0.000621371,
      'Centímetro (cm)': 100.0,
      'Milímetro (mm)': 1000.0,
      'Quilômetro (km)': 0.001,
    },
    'Peso': {
      'Quilograma (kg)': 1.0,
      'Libra (lb)': 2.20462,
      'Onça (oz)': 35.274,
      'Stone (st)': 0.157473,
      'Grama (g)': 1000.0,
      'Tonelada (t)': 0.001,
    },
    'Volume': {
      'Litro (L)': 1.0,
      'Galão US (gal)': 0.264172,
      'Galão UK (gal)': 0.219969,
      'Quarto US (qt)': 1.05669,
      'Pinta US (pt)': 2.11338,
      'Xícara (cup)': 4.22675,
      'Onça fluida (fl oz)': 33.814,
      'Mililitro (mL)': 1000.0,
    },
    'Área': {
      'Metro quadrado (m²)': 1.0,
      'Pé quadrado (ft²)': 10.7639,
      'Polegada quadrada (in²)': 1550.0,
      'Jarda quadrada (yd²)': 1.19599,
      'Acre (ac)': 0.000247105,
      'Hectare (ha)': 0.0001,
      'Quilômetro quadrado (km²)': 0.000001,
    },
    'Velocidade': {
      'Quilômetro por hora (km/h)': 1.0,
      'Milha por hora (mph)': 0.621371,
      'Metro por segundo (m/s)': 0.277778,
      'Pé por segundo (ft/s)': 0.911344,
      'Nó (kn)': 0.539957,
    },
    'Pressão': {
      'Pascal (Pa)': 1.0,
      'Bar (bar)': 0.00001,
      'PSI (psi)': 0.000145038,
      'Atmosfera (atm)': 0.00000986923,
      'Torr (torr)': 0.00750062,
      'Milímetro de mercúrio (mmHg)': 0.00750062,
    },
  };

  final Map<String, IconData> _categoryIcons = {
    'Comprimento': Icons.straighten_rounded,
    'Peso': Icons.scale_rounded,
    'Volume': Icons.local_drink_rounded,
    'Área': Icons.crop_square_rounded,
    'Velocidade': Icons.speed_rounded,
    'Pressão': Icons.compress_rounded,
  };

  final Map<String, Color> _categoryColors = {
    'Comprimento': const Color(0xFF3B82F6),
    'Peso': const Color(0xFF10B981),
    'Volume': const Color(0xFFF59E0B),
    'Área': const Color(0xFF8B5CF6),
    'Velocidade': const Color(0xFFEF4444),
    'Pressão': const Color(0xFF14B8A6),
  };

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_convert);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() {
        _result = '';
      });
      return;
    }

    try {
      double inputValue = double.parse(_inputController.text);
      double fromFactor = _conversionFactors[_selectedCategory]![_fromUnit]!;
      double toFactor = _conversionFactors[_selectedCategory]![_toUnit]!;
      double result = inputValue * (toFactor / fromFactor);

      setState(() {
        _result = result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
      });
    } catch (e) {
      setState(() {
        _result = 'Erro na conversão';
      });
    }
  }

  void _copyResult() {
    if (_result.isNotEmpty && _result != 'Erro na conversão') {
      Clipboard.setData(ClipboardData(text: _result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Resultado copiado para a área de transferência!'),
          backgroundColor: _categoryColors[_selectedCategory]!,
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
        title: const Text(
          'Conversor de Medidas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _categoryColors[_selectedCategory]!,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _categoryColors[_selectedCategory]!,
              _categoryColors[_selectedCategory]!.withOpacity(0.8),
              _categoryColors[_selectedCategory]!.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ResponsivePadding(
                  mobile: const EdgeInsets.all(12.0),
                  tablet: const EdgeInsets.all(16.0),
                  desktop: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategorySelector(),
                        const SizedBox(height: 20),
                        _buildConversionInputs(),
                        const SizedBox(height: 20),
                        _buildResult(),
                        const SizedBox(height: 20),
                        _buildQuickConversions(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _categoryIcons[_selectedCategory],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Categoria:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintText: 'Selecione uma categoria',
                hintStyle: TextStyle(color: Colors.white70),
              ),
              dropdownColor: _categoryColors[_selectedCategory]!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items: _conversionFactors.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _categoryIcons[category]!,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                    _fromUnit = _conversionFactors[newValue]!.keys.first;
                    _toUnit = _conversionFactors[newValue]!.keys.elementAt(1);
                    _result = '';
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionInputs() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Input field
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B894),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.input,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Valor de entrada:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Digite o valor',
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Unit selectors
          ResponsiveRow(
            breakpoint: 500,
            spacing: 16,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7675),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'De:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _fromUnit,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        dropdownColor: _categoryColors[_selectedCategory]!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                        items: _conversionFactors[_selectedCategory]!.keys.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: AutoSizeText(
                              unit,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _fromUnit = newValue;
                              _result = '';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF74B9FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Para:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _toUnit,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        dropdownColor: _categoryColors[_selectedCategory]!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                        items: _conversionFactors[_selectedCategory]!.keys.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: AutoSizeText(
                              unit,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _toUnit = newValue;
                              _result = '';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_result.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Resultado:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_result != 'Erro na conversão')
                IconButton(
                  onPressed: _copyResult,
                  icon: const Icon(Icons.copy, color: Colors.white),
                  tooltip: 'Copiar resultado',
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
            child: Column(
              children: [
                Text(
                  _result,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_fromUnit → $_toUnit',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickConversions() {
    final units = _conversionFactors[_selectedCategory]!.keys.toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
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
                  Icons.flash_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Conversões Rápidas:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: units.map((String unit) {
              bool isSelected = unit == _fromUnit;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _fromUnit = unit;
                    _result = '';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
