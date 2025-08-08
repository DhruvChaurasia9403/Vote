import 'package:equatable/equatable.dart';


class Idea extends Equatable {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int votes;
  final String rating;

  const Idea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.votes,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, name, tagline, description, votes, rating];

  Idea copyWith({
    String? id,
    String? name,
    String? tagline,
    String? description,
    int? votes,
    String? rating,
  }) {
    return Idea(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      votes: votes ?? this.votes,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'votes': votes,
      'rating': rating,
    };
  }

  factory Idea.fromMap(Map<String, dynamic> map) {
    final ratingValue = map['rating'] ?? '0.0';
    final ratingString = ratingValue.toString();

    return Idea(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      tagline: map['tagline'] ?? '',
      description: map['description'] ?? '',
      votes: map['votes']?.toInt() ?? 0,
      rating: ratingString,
    );
  }
}
