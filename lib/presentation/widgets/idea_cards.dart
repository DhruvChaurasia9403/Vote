import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/idea_model.dart';
import '../../utils/vote_store.dart';
class IdeaCard extends StatefulWidget {
  final Idea idea;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  // Key for this specific card instance
  final GlobalKey<FlipCardState> cardKey;
  // Notifier from the parent to track the globally flipped card
  final ValueNotifier<GlobalKey<FlipCardState>?> currentlyFlippedCard;

  const IdeaCard({
    super.key,
    required this.idea,
    required this.onUpvote,
    required this.onDownvote,
    required this.cardKey,
    required this.currentlyFlippedCard,
  });

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  bool _expanded = false;
  bool _hasVoted = false;
  bool _isProcessingVote = false;
  int _displayVotes = 0;

  @override
  void initState() {
    super.initState();
    _displayVotes = widget.idea.votes;
    _checkIfVoted();
    // Listen for changes to the globally flipped card
    widget.currentlyFlippedCard.addListener(_handleFlipLogic);
  }

  @override
  void dispose() {
    // Clean up the listener
    widget.currentlyFlippedCard.removeListener(_handleFlipLogic);
    super.dispose();
  }

  // This logic ensures only one card is flipped at a time
  void _handleFlipLogic() {
    // If the globally tracked card is not this card, and this card is currently flipped, flip it back.
    if (widget.currentlyFlippedCard.value != widget.cardKey &&
        !(widget.cardKey.currentState?.isFront ?? true)) {
      widget.cardKey.currentState?.toggleCard();
    }
  }

  void _toggleCard() {
    // If this card is about to be flipped, check if another card is already flipped.
    if (widget.cardKey.currentState?.isFront ?? true) {
      if (widget.currentlyFlippedCard.value != null &&
          widget.currentlyFlippedCard.value != widget.cardKey) {
        // Flip the other card back first
        widget.currentlyFlippedCard.value?.currentState?.toggleCard();
      }
      // Now, set this card as the currently flipped one
      widget.currentlyFlippedCard.value = widget.cardKey;
    } else {
      // If this card is being flipped back, clear the global tracker
      widget.currentlyFlippedCard.value = null;
    }
    // Execute the flip
    widget.cardKey.currentState?.toggleCard();
  }

  Future<void> _checkIfVoted() async {
    final voted = await VoteStore.hasVoted(widget.idea.id);
    if (mounted) {
      setState(() {
        _hasVoted = voted;
      });
    }
  }

  Future<void> _handleVote() async {
    if (_isProcessingVote) return;
    setState(() => _isProcessingVote = true);

    if (_hasVoted) {
      widget.onDownvote();
      setState(() {
        _hasVoted = false;
        _displayVotes--;
      });
    } else {
      widget.onUpvote();
      setState(() {
        _hasVoted = true;
        _displayVotes++;
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isProcessingVote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final idea = widget.idea;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Widget cardFront = Card(
      elevation: isDarkMode ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDarkMode
            ? BorderSide(color: Colors.grey.shade800)
            : BorderSide.none,
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        idea.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        idea.tagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleCard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: isDarkMode
                              ? [
                            Colors.lightBlue.shade900,
                            Colors.lightBlue.shade700
                          ]
                              : [Colors.blue.shade100, Colors.blue.shade200]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          idea.rating,
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.lightBlue.shade100
                                  : Colors.blue.shade800),
                        ),
                        Text(
                          'AI Score',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: isDarkMode
                                  ? Colors.lightBlue.shade200
                                  : Colors.blue.shade700),
                        ),
                      ],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
                      end: 1.05,
                      duration: 1500.ms,
                      curve: Curves.easeInOut),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: 400.ms,
              curve: Curves.easeInOut,
              child: Text(
                idea.description,
                maxLines: _expanded ? null : 3,
                overflow: _expanded ? null : TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                    color:
                    theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                    height: 1.5),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'Show Less' : 'Read More...'),
                ),
                Row(
                  children: [
                    Text(
                      '$_displayVotes votes',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.6)),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: _hasVoted
                          ? Icon(Icons.thumb_up_alt, color: theme.primaryColor)
                          : const Icon(Icons.thumb_up_alt_outlined),
                      onPressed: _isProcessingVote ? null : _handleVote,
                    )
                        .animate(target: _hasVoted ? 1 : 0)
                        .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.3, 1.3),
                        duration: 200.ms,
                        curve: Curves.easeOut)
                        .then()
                        .scale(end: const Offset(1, 1), duration: 200.ms),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget cardBack = Card(
      elevation: isDarkMode ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDarkMode
            ? BorderSide(color: Colors.grey.shade800)
            : BorderSide.none,
      ),
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.lightBlue.shade900, Colors.black]
                  : [Colors.blue.shade200, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AI Viability Score',
                style: theme.textTheme.titleMedium?.copyWith(
                    color:
                    theme.textTheme.titleMedium?.color?.withOpacity(0.7)),
              ),
              Text(
                idea.rating,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                icon: const Icon(Icons.flip_to_front_outlined),
                label: const Text('Flip Back'),
                onPressed: _toggleCard,
              )
            ],
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != 0) {
            _toggleCard();
          }
        },
        child: FlipCard(
          key: widget.cardKey,
          front: cardFront,
          back: cardBack,
          flipOnTouch: false,
        ),
      ),
    );
  }
}
