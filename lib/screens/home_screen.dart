import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/smart_grid.dart';
import '../widgets/responsive_layout.dart';
import 'unit_converter_screen.dart';
import 'measure_converter_screen.dart';
import 'text_tools_screen.dart';
import 'calculator_screen.dart';
import 'password_generator_screen.dart';
import 'currency_converter_screen.dart';
import 'date_time_tools_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controlador único para otimização
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Swiss Army Knife',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E2E),
              Color(0xFF2D2D44),
              Color(0xFF3D3D54),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ResponsivePadding(
                    mobile: const EdgeInsets.all(12.0),
                    tablet: const EdgeInsets.all(16.0),
                    desktop: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 24),
                          _buildToolsGrid(),
                        ],
                      ),
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

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C5CE7),
            Color(0xFFA29BFE),
            Color(0xFF74B9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ResponsiveRow(
        breakpoint: 500,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.build_circle_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Bem-vindo!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  mobileFontSize: 24,
                  tabletFontSize: 28,
                  desktopFontSize: 32,
                ),
                const SizedBox(height: 8),
                ResponsiveText(
                  'Seu canivete suíço digital com todas as ferramentas que você precisa em um só lugar!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    height: 1.4,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  mobileFontSize: 14,
                  tabletFontSize: 16,
                  desktopFontSize: 18,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid() {
    final tools = [
      {
        'title': 'Conversor de Unidades',
        'subtitle': 'Converta medidas facilmente',
        'icon': Icons.straighten_rounded,
        'color': const Color(0xFF3B82F6), // Blue
        'screen': const UnitConverterScreen(),
      },
      {
        'title': 'Conversor de Medidas',
        'subtitle': 'Sistema métrico e imperial',
        'icon': Icons.architecture_rounded,
        'color': const Color(0xFF10B981), // Green
        'screen': const MeasureConverterScreen(),
      },
      {
        'title': 'Ferramentas de Texto',
        'subtitle': 'Manipule textos facilmente',
        'icon': Icons.text_fields_rounded,
        'color': const Color(0xFFF59E0B), // Orange
        'screen': const TextToolsScreen(),
      },
      {
        'title': 'Calculadora',
        'subtitle': 'Cálculos básicos e científicos',
        'icon': Icons.calculate_rounded,
        'color': const Color(0xFF8B5CF6), // Purple
        'screen': const CalculatorScreen(),
      },
      {
        'title': 'Gerador de Senhas',
        'subtitle': 'Senhas seguras e personalizadas',
        'icon': Icons.lock_rounded,
        'color': const Color(0xFFEF4444), // Red
        'screen': const PasswordGeneratorScreen(),
      },
      {
        'title': 'Conversor de Moedas',
        'subtitle': 'Taxas de câmbio atualizadas',
        'icon': Icons.currency_exchange_rounded,
        'color': const Color(0xFF14B8A6), // Teal
        'screen': const CurrencyConverterScreen(),
      },
      {
        'title': 'Data e Hora',
        'subtitle': 'Ferramentas de tempo',
        'icon': Icons.schedule_rounded,
        'color': const Color(0xFF6366F1), // Indigo
        'screen': const DateTimeToolsScreen(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B894),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              ResponsiveText(
                'Ferramentas Disponíveis',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                mobileFontSize: 18,
                tabletFontSize: 20,
                desktopFontSize: 22,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SmartGridView(
          maxColumns: 2,
          spacing: 12,
          runSpacing: 12,
          childAspectRatio: 1.3,
          children: tools.map((tool) {
            return _buildToolCard(tool);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToolCard(Map<String, dynamic> tool) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToScreen(tool['screen'] as Widget),
          borderRadius: BorderRadius.circular(20),
                      child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (tool['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (tool['color'] as Color).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    tool['icon'] as IconData,
                    size: 24,
                    color: tool['color'] as Color,
                  ),
                ),
                const SizedBox(height: 12),
                ResponsiveText(
                  tool['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  mobileFontSize: 14,
                  tabletFontSize: 16,
                  desktopFontSize: 18,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                ResponsiveText(
                  tool['subtitle'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  mobileFontSize: 10,
                  tabletFontSize: 12,
                  desktopFontSize: 14,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E2E),
              Color(0xFF2D2D44),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6C5CE7),
                    Color(0xFFA29BFE),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.build_circle_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Swiss Army Knife',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Ferramentas em um só lugar',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home_rounded,
                      title: 'Início',
                      onTap: () => Navigator.pop(context),
                      isSelected: true,
                    ),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(
                      icon: Icons.straighten_rounded,
                      title: 'Conversor de Unidades',
                      onTap: () => _navigateToScreen(const UnitConverterScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.architecture_rounded,
                      title: 'Conversor de Medidas',
                      onTap: () => _navigateToScreen(const MeasureConverterScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.text_fields_rounded,
                      title: 'Ferramentas de Texto',
                      onTap: () => _navigateToScreen(const TextToolsScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calculate_rounded,
                      title: 'Calculadora',
                      onTap: () => _navigateToScreen(const CalculatorScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.lock_rounded,
                      title: 'Gerador de Senhas',
                      onTap: () => _navigateToScreen(const PasswordGeneratorScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Conversor de Moedas',
                      onTap: () => _navigateToScreen(const CurrencyConverterScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.schedule_rounded,
                      title: 'Data e Hora',
                      onTap: () => _navigateToScreen(const DateTimeToolsScreen()),
                    ),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(
                      icon: Icons.info_rounded,
                      title: 'Sobre',
                      onTap: () => _showAboutDialog(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF6C5CE7) : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _navigateToScreen(Widget screen) {
    // Fecha o drawer primeiro
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    
    // Navega para a tela desejada
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showAboutDialog() {
    Navigator.pop(context); // Fecha o drawer
    showAboutDialog(
      context: context,
      applicationName: 'Swiss Army Knife',
      applicationVersion: '2.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF6C5CE7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.build_circle_rounded,
          size: 40,
          color: Color(0xFF6C5CE7),
        ),
      ),
      children: [
        const Text(
          'Um aplicativo multifuncional moderno que reúne diversas ferramentas úteis em um só lugar. '
          'Desenvolvido com Flutter para máxima compatibilidade entre plataformas.',
        ),
      ],
    );
  }
}
