import 'package:flutter/material.dart';

/// Constrains content to a max width for desktop while filling on mobile.
/// Keeps the app looking nice on both phone and computer.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.maxWidth = 600});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Returns true when the screen is wider than a phone (>600px).
bool isWideScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 600;
