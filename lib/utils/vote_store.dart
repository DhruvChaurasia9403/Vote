import 'package:shared_preferences/shared_preferences.dart';

class VoteStore {
  static const _key = 'voted_idea_ids';
  static Future<Set<String>> getVotedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);
    return (list ?? []).toSet();
  }
  static Future<bool> hasVoted(String ideaId) async {
    final ids = await getVotedIds();
    return ids.contains(ideaId);
  }
  static Future<void> addVoted(String ideaId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (!list.contains(ideaId)) {
      list.add(ideaId);
      await prefs.setStringList(_key, list);
    }
  }
  static Future<void> removeVote(String ideaId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.remove(ideaId);
    await prefs.setStringList(_key, list);
  }
}
