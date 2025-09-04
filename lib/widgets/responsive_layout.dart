import 'package:flutter/material.dart';

/// Widget que adapta o layout baseado no tamanho da tela
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 800) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Widget que quebra Row em Column quando há overflow
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double breakpoint;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.breakpoint = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          // Layout vertical para telas pequenas
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children
                .expand((child) => [child, SizedBox(height: spacing)])
                .take(children.length * 2 - 1)
                .toList(),
          );
        } else {
          // Layout horizontal para telas maiores
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children
                .expand((child) => [child, SizedBox(width: spacing)])
                .take(children.length * 2 - 1)
                .toList(),
          );
        }
      },
    );
  }
}

/// Widget que ajusta o tamanho da fonte automaticamente para evitar overflow
class AutoSizeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? minFontSize;
  final double? maxFontSize;
  final TextOverflow overflow;

  const AutoSizeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.minFontSize = 8.0,
    this.maxFontSize = 24.0,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
        final fontSize = textStyle.fontSize ?? 14.0;
        
        // Calcula se o texto vai caber
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );
        
        textPainter.layout(maxWidth: constraints.maxWidth);
        
        if (textPainter.didExceedMaxLines || 
            textPainter.width > constraints.maxWidth) {
          // Se exceder, usa FittedBox para ajustar
          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: textStyle,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
          );
        } else {
          // Se couber, usa o texto normal
          return Text(
            text,
            style: textStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }
      },
    );
  }
}

/// Widget que previne overflow em GridView
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int maxColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.maxColumns = 4,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        double aspectRatio;
        
        // Sistema de breakpoints mais inteligente
        if (constraints.maxWidth > 1400) {
          // Desktop grande
          columns = maxColumns;
          aspectRatio = childAspectRatio ?? 1.0;
        } else if (constraints.maxWidth > 1000) {
          // Desktop médio
          columns = maxColumns;
          aspectRatio = childAspectRatio ?? 1.1;
        } else if (constraints.maxWidth > 800) {
          // Tablet grande
          columns = (maxColumns - 1).clamp(2, maxColumns);
          aspectRatio = childAspectRatio ?? 1.1;
        } else if (constraints.maxWidth > 600) {
          // Tablet pequeno
          columns = 3.clamp(2, maxColumns);
          aspectRatio = childAspectRatio ?? 1.2;
        } else if (constraints.maxWidth > 400) {
          // Mobile grande
          columns = 2;
          aspectRatio = childAspectRatio ?? 1.1;
        } else {
          // Mobile pequeno
          columns = 2;
          aspectRatio = childAspectRatio ?? 1.0;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
          childAspectRatio: aspectRatio,
          children: children,
        );
      },
    );
  }
}

/// Widget que adapta padding baseado no tamanho da tela
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? mobile;
  final EdgeInsetsGeometry? tablet;
  final EdgeInsetsGeometry? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsetsGeometry padding;
        
        if (constraints.maxWidth >= 1200) {
          padding = desktop ?? tablet ?? mobile ?? const EdgeInsets.all(24);
        } else if (constraints.maxWidth >= 800) {
          padding = tablet ?? mobile ?? const EdgeInsets.all(20);
        } else {
          padding = mobile ?? const EdgeInsets.all(16);
        }
        
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}

/// Widget que adapta o tamanho da fonte baseado no tamanho da tela
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize;
        
        if (constraints.maxWidth >= 1200) {
          fontSize = desktopFontSize ?? tabletFontSize ?? mobileFontSize ?? 16;
        } else if (constraints.maxWidth >= 800) {
          fontSize = tabletFontSize ?? mobileFontSize ?? 14;
        } else {
          fontSize = mobileFontSize ?? 12;
        }
        
        return Text(
          text,
          style: style?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Widget que adapta o espaçamento baseado no tamanho da tela
class ResponsiveSpacing extends StatelessWidget {
  final Widget child;
  final double? mobileSpacing;
  final double? tabletSpacing;
  final double? desktopSpacing;
  final Axis direction;

  const ResponsiveSpacing({
    super.key,
    required this.child,
    this.mobileSpacing,
    this.tabletSpacing,
    this.desktopSpacing,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing;
        
        if (constraints.maxWidth >= 1200) {
          spacing = desktopSpacing ?? tabletSpacing ?? mobileSpacing ?? 16;
        } else if (constraints.maxWidth >= 800) {
          spacing = tabletSpacing ?? mobileSpacing ?? 12;
        } else {
          spacing = mobileSpacing ?? 8;
        }
        
        if (direction == Axis.horizontal) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: child,
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: spacing),
            child: child,
          );
        }
      },
    );
  }
}

/// Widget que previne overflow horizontal usando SingleChildScrollView
class OverflowSafeWidget extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final bool reverse;

  const OverflowSafeWidget({
    super.key,
    required this.child,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      child: child,
    );
  }
}

/// Widget que cria um container flexível que se adapta ao conteúdo
class FlexibleContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? maxWidth;
  final double? minWidth;
  final double? maxHeight;
  final double? minHeight;

  const FlexibleContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        minWidth: minWidth ?? 0,
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? 0,
      ),
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}
