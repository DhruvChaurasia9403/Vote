import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/idea_model.dart';
import '../constants.dart';

class ApiProvider {
  final http.Client client;
  ApiProvider({http.Client? client}) : client = client ?? http.Client();

  Future<List<Idea>> fetchIdeas() async {
    final res = await client.get(Uri.parse(IDEAS_ENDPOINT));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Idea.fromMap(e)).toList();
    } else {
      throw Exception('Failed to fetch ideas');
    }
  }

  Future<Idea> addIdea(Map<String, dynamic> payload) async {
    final res = await client.post(Uri.parse(IDEAS_ENDPOINT),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload));
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Idea.fromMap(json.decode(res.body));
    } else {
      throw Exception('Failed to add idea');
    }
  }

  Future<Idea> updateIdea(String id, Map<String, dynamic> payload) async {
    final url = '$IDEAS_ENDPOINT/$id';
    final res = await client.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload));
    if (res.statusCode == 200) {
      return Idea.fromMap(json.decode(res.body));
    } else {
      throw Exception('Failed to update idea');
    }
  }
}
