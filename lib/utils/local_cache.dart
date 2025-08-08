import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/idea_model.dart';

class LocalCache {
  static const _key = 'cached_ideas';
  static Future<void> saveIdeas(List<Idea> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(ideas.map((e) => e.toMap()).toList());
    await prefs.setString(_key, jsonStr);
  }
  static Future<List<Idea>> readIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return [];
    final List data = json.decode(str);
    return data.map((e) => Idea.fromMap(e)).toList();
  }
}
