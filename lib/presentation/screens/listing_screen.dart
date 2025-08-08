import 'package:flip_card/flip_card.dart';

import '../../data/models/idea_model.dart';
import '../../logic/idea_bloc/idea_bloc.dart';
import '../../logic/idea_bloc/idea_event.dart';
import '../../logic/idea_bloc/idea_state.dart';
import '../widgets/animated_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/idea_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  // Notifier to track the key of the currently flipped card
  final ValueNotifier<GlobalKey<FlipCardState>?> _currentlyFlippedCard =
  ValueNotifier(null);

  @override
  void dispose() {
    _currentlyFlippedCard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Startup Ideas'),
                  floating: true,
                  snap: true,
                  elevation: 0,
                  backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                ),
                SliverToBoxAdapter(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<IdeaBloc>().add(LoadIdeasEvent());
                    },
                    child: BlocBuilder<IdeaBloc, IdeaState>(
                      builder: (context, state) {
                        if (state is IdeaLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is IdeaLoaded) {
                          final ideas = state.ideas;
                          if (ideas.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('No ideas yet. Be the first! 🚀',
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text('Submit an Idea'),
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/submit'),
                                    )
                                  ],
                                ).animate().fadeIn(duration: 500.ms).scale(),
                              ),
                            );
                          }
                          return AnimationLimiter(
                            child: ListView.builder(
                              padding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: ideas.length,
                              itemBuilder: (context, index) {
                                final Idea idea = ideas[index];
                                final cardKey = GlobalKey<FlipCardState>();
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 100.0,
                                    child: FadeInAnimation(
                                      child: IdeaCard(
                                        // Pass the key and notifier to each card
                                        key: ValueKey(idea.id),
                                        cardKey: cardKey,
                                        currentlyFlippedCard:
                                        _currentlyFlippedCard,
                                        idea: idea,
                                        onUpvote: () {
                                          context
                                              .read<IdeaBloc>()
                                              .add(UpvoteIdeaEvent(idea));
                                        },
                                        onDownvote: () {
                                          context
                                              .read<IdeaBloc>()
                                              .add(DownvoteIdeaEvent(idea));
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is IdeaError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Idea'),
        onPressed: () => Navigator.pushNamed(context, '/submit'),
      ).animate().slideX(begin: 2, duration: 500.ms, curve: Curves.easeOutBack),
    );
  }
}