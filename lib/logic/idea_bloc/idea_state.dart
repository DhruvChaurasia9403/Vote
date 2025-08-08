import 'package:equatable/equatable.dart';
import '../../data/models/idea_model.dart';

abstract class IdeaState extends Equatable {
  const IdeaState();
  @override
  List<Object?> get props => [];
}
class IdeaInitial extends IdeaState {}
class IdeaLoading extends IdeaState {}
class IdeaLoaded extends IdeaState {
  final List<Idea> ideas;
  const IdeaLoaded({this.ideas = const <Idea>[]});
  @override
  List<Object?> get props => [ideas];
}
class IdeaError extends IdeaState {
  final String message;
  const IdeaError({required this.message});
  @override
  List<Object?> get props => [message];
}
