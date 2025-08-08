import 'dart:math';
import 'package:uuid/uuid.dart';
import 'api_provider.dart';
import 'models/idea_model.dart';

class IdeaRepository {
  final ApiProvider api;
  IdeaRepository(this.api);

  Future<List<Idea>> fetchIdeas() => api.fetchIdeas();

  /// We generate a fake AI rating on client side (or you could do it server-side).
  Future<Idea> addIdea(String name, String tagline, String description) async {
    final String id = Uuid().v4();
    final int rating = Random().nextInt(101);
    final Map<String, dynamic> payload = {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'rating': rating,
      'votes': 0,
    };
    return api.addIdea(payload);
  }

  Future<Idea> upvoteIdea(Idea idea) async {
    final updated = idea.copyWith(votes: idea.votes + 1);
    final Map<String, dynamic> payload = updated.toMap();
    return api.updateIdea(idea.id, payload);
  }
}
