import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool withScrollView;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.padding,
    this.withScrollView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        // Determine the appropriate padding based on screen width
        final horizontalPadding = width < 480 ? 12.0 : 
                              width < 600 ? 16.0 : 
                              width < 960 ? 24.0 : 
                              width < 1200 ? 32.0 : 48.0;
        
        final effectivePadding = padding ?? 
                                EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: 16.0,
                                );
        
        // Wrap with SingleChildScrollView if needed
        Widget content = Padding(
          padding: effectivePadding,
          child: child,
        );
        
        if (withScrollView) {
          content = SingleChildScrollView(
            child: content,
          );
        }
        
        return content;
      },
    );
  }
}
