import 'package:flutter/material.dart';

/// Widget de grid inteligente que se adapta perfeitamente a qualquer tamanho de tela
class SmartGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? maxColumns;
  final double? minItemWidth;
  final double? maxItemWidth;

  const SmartGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.maxColumns,
    this.minItemWidth,
    this.maxItemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula o número de colunas baseado na largura disponível
        int columns = _calculateColumns(constraints.maxWidth);
        
        // Calcula a largura de cada item
        double itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        
        // Ajusta a largura se necessário
        if (minItemWidth != null && itemWidth < minItemWidth!) {
          columns = (constraints.maxWidth / (minItemWidth! + spacing)).floor();
          itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        }
        
        if (maxItemWidth != null && itemWidth > maxItemWidth!) {
          columns = (constraints.maxWidth / (maxItemWidth! + spacing)).ceil();
          itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  int _calculateColumns(double width) {
    if (maxColumns != null) {
      if (width > 1200) {
        return maxColumns!;
      } else if (width > 800) {
        return maxColumns!;
      } else if (width > 600) {
        return (maxColumns! - 1).clamp(2, maxColumns!);
      } else if (width > 400) {
        return 2;
      } else {
        return 1;
      }
    } else {
      if (width > 1200) {
        return 4;
      } else if (width > 900) {
        return 3;
      } else if (width > 600) {
        return 2;
      } else {
        return 1;
      }
    }
  }
}

/// Widget que usa GridView com cálculo inteligente de colunas
class SmartGridView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? maxColumns;
  final double? childAspectRatio;

  const SmartGridView({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.maxColumns,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _calculateColumns(constraints.maxWidth);
        double aspectRatio = _calculateAspectRatio(constraints.maxWidth);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
          childAspectRatio: childAspectRatio ?? aspectRatio,
          children: children,
        );
      },
    );
  }

  int _calculateColumns(double width) {
    if (maxColumns != null) {
      if (width > 1200) {
        return maxColumns!;
      } else if (width > 800) {
        return maxColumns!;
      } else if (width > 600) {
        return (maxColumns! - 1).clamp(2, maxColumns!);
      } else if (width > 400) {
        return 2;
      } else {
        return 1;
      }
    } else {
      if (width > 1200) {
        return 4;
      } else if (width > 900) {
        return 3;
      } else if (width > 600) {
        return 2;
      } else {
        return 1;
      }
    }
  }

  double _calculateAspectRatio(double width) {
    if (width > 1200) {
      return 1.0;
    } else if (width > 800) {
      return 1.1;
    } else if (width > 600) {
      return 1.2;
    } else {
      return 1.1;
    }
  }
}

/// Widget que cria um grid responsivo com Wrap para melhor controle
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? maxColumns;
  final double? minItemWidth;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.maxColumns,
    this.minItemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = _calculateColumns(constraints.maxWidth);
        double itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  int _calculateColumns(double width) {
    if (maxColumns != null) {
      if (width > 1200) {
        return maxColumns!;
      } else if (width > 800) {
        return maxColumns!;
      } else if (width > 600) {
        return (maxColumns! - 1).clamp(2, maxColumns!);
      } else if (width > 400) {
        return 2;
      } else {
        return 1;
      }
    } else {
      if (width > 1200) {
        return 4;
      } else if (width > 900) {
        return 3;
      } else if (width > 600) {
        return 2;
      } else {
        return 1;
      }
    }
  }
}
