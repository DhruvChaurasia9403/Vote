import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../data/models/idea_model.dart';
import '../../logic/idea_bloc/idea_bloc.dart';
import '../../logic/idea_bloc/idea_state.dart';
import '../widgets/animated_background.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final goldColor = isDarkMode ? const Color(0xFFF9A825) : Colors.amber.shade400;
    final silverColor = isDarkMode ? const Color(0xFFB0BEC5) : Colors.grey.shade400;
    final bronzeColor = isDarkMode ? const Color(0xFFBCAAA4) : Colors.brown.shade300;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Leaderboard 🏆'),
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: BlocBuilder<IdeaBloc, IdeaState>(
              builder: (context, state) {
                if (state is IdeaLoaded) {
                  List<Idea> list = [...state.ideas];
                  list.sort((a, b) => b.votes.compareTo(a.votes));
                  final top = list.take(10).toList();

                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: top.length,
                      itemBuilder: (context, index) {
                        final idea = top[index];
                        final medalColor = index == 0
                            ? goldColor
                            : index == 1
                            ? silverColor
                            : index == 2
                            ? bronzeColor
                            : theme.primaryColor.withOpacity(0.5);

                        final medalIcon = index == 0
                            ? '🥇'
                            : index == 1
                            ? '🥈'
                            : index == 2
                            ? '🥉'
                            : '${index + 1}';

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 75.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.cardColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color: medalColor,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      medalIcon,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            idea.name,
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            idea.tagline,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '${idea.votes} votes',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}