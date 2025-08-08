import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

class TutorialOverlay extends StatefulWidget {
  final GlobalKey addIdeaKey;
  final GlobalKey drawerKey;
  final VoidCallback onFinish;

  const TutorialOverlay({
    super.key,
    required this.addIdeaKey,
    required this.drawerKey,
    required this.onFinish,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _step = 0;

  void _nextStep() {
    if (_step == 1) {
      widget.onFinish(); // Tutorial is done
    } else {
      setState(() {
        _step++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which key to use for the current step
    final currentKey = _step == 0 ? widget.drawerKey : widget.addIdeaKey;
    final RenderBox? renderBox =
    currentKey.currentContext?.findRenderObject() as RenderBox?;

    // Default position if the key isn't ready yet
    Rect highlightRect = Rect.fromLTWH(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
        0,
        0);

    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      highlightRect = Rect.fromLTWH(
        position.dx,
        position.dy,
        renderBox.size.width,
        renderBox.size.height,
      );
    }

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _nextStep,
        child: Stack(
          children: [
            // Darkened background
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  // The highlighted area
                  Positioned(
                    left: highlightRect.left - 8,
                    top: highlightRect.top - 8,
                    child: Container(
                      width: highlightRect.width + 16,
                      height: highlightRect.height + 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tutorial Text
            _buildStepContent(context, highlightRect),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, Rect highlightRect) {
    final theme = Theme.of(context);
    String title = '';
    String description = '';
    Alignment alignment = Alignment.center;

    if (_step == 0) {
      title = 'Explore More';
      description = 'Tap here to open the menu, view the leaderboard, and change themes.';
      alignment = Alignment(0, -0.7); // Position text above center
    } else if (_step == 1) {
      title = 'Add Your Idea';
      description = 'Have a great startup idea? Tap here to submit it!';
      alignment = Alignment(0, 0.7); // Position text below center
    }

    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 32),
          const Text(
            'Tap anywhere to continue',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
