import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import '../../data/models/idea_model.dart';
import '../../utils/local_cache.dart';
import '../../utils/vote_store.dart';
import 'idea_event.dart';
import 'idea_state.dart';


class IdeaBloc extends Bloc<IdeaEvent, IdeaState> {
  IdeaBloc() : super(IdeaInitial()) {
    on<LoadIdeasEvent>(_onLoadIdeas);
    on<AddIdeaEvent>(_onAddIdea);
    on<UpvoteIdeaEvent>(_onUpvoteIdea);
    on<DownvoteIdeaEvent>(_onDownvoteIdea);
  }

  Future<void> _onLoadIdeas(LoadIdeasEvent event, Emitter<IdeaState> emit) async {
    emit(IdeaLoading());
    try {
      final ideas = await LocalCache.readIdeas();
      emit(IdeaLoaded(ideas: ideas));
    } catch (e) {
      emit(IdeaError(message: 'Failed to load ideas: $e'));
    }
  }

  Future<void> _onAddIdea(AddIdeaEvent event, Emitter<IdeaState> emit) async {
    if (state is IdeaLoaded) {
      final currentState = state as IdeaLoaded;
      final newIdea = Idea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        tagline: event.tagline,
        description: event.description,
        votes: 0,
        rating: (Random().nextDouble() * 4 + 1).toStringAsFixed(1),
      );
      final updatedIdeas = List<Idea>.from(currentState.ideas)..add(newIdea);
      await LocalCache.saveIdeas(updatedIdeas);
      emit(IdeaLoaded(ideas: updatedIdeas));
    }
  }

  Future<void> _onUpvoteIdea(UpvoteIdeaEvent event, Emitter<IdeaState> emit) async {
    if (state is IdeaLoaded) {
      final currentState = state as IdeaLoaded;
      final hasVoted = await VoteStore.hasVoted(event.idea.id);

      if (!hasVoted) {
        final updatedIdeas = currentState.ideas.map((idea) {
          if (idea.id == event.idea.id) {
            return idea.copyWith(votes: idea.votes + 1);
          }
          return idea;
        }).toList();

        await VoteStore.addVoted(event.idea.id);
        await LocalCache.saveIdeas(updatedIdeas);
        emit(IdeaLoaded(ideas: updatedIdeas));
      }
    }
  }

  Future<void> _onDownvoteIdea(DownvoteIdeaEvent event, Emitter<IdeaState> emit) async {
    if (state is IdeaLoaded) {
      final currentState = state as IdeaLoaded;

      final updatedIdeas = currentState.ideas.map((idea) {
        if (idea.id == event.idea.id) {
          final newVotes = idea.votes > 0 ? idea.votes - 1 : 0;
          return idea.copyWith(votes: newVotes);
        }
        return idea;
      }).toList();

      await VoteStore.removeVote(event.idea.id);
      await LocalCache.saveIdeas(updatedIdeas);
      emit(IdeaLoaded(ideas: updatedIdeas));
    }
  }
}
