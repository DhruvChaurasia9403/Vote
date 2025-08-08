import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/theme_notifier.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final lightColors = [
      Colors.blue.shade50,
      Colors.grey.shade200,
      Colors.white,
    ];
    final darkColors = [
      Colors.black,
      const Color(0xFF001f3f), // Deep Navy Blue
      Colors.lightBlue.shade900,
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeNotifier.isDarkMode ? darkColors : lightColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, _controller.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}