
import '../../data/models/idea_model.dart';

abstract class IdeaEvent {}
class LoadIdeasEvent extends IdeaEvent {}
class AddIdeaEvent extends IdeaEvent {
  final String name;
  final String tagline;
  final String description;
  AddIdeaEvent(this.name, this.tagline, this.description);
}
class UpvoteIdeaEvent extends IdeaEvent {
  final Idea idea;
  UpvoteIdeaEvent(this.idea);
}
class DownvoteIdeaEvent extends IdeaEvent {
  final Idea idea;
  DownvoteIdeaEvent(this.idea);
}
