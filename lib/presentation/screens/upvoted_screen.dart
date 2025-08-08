import 'package:flutter/cupertino.dart';

class UpvotedScreen extends StatelessWidget {
  const UpvotedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Upvoted Ideas')),
        child: Center(child: Text('Upvoted Screen')));
  }
}
