import 'package:flutter/cupertino.dart';

class TaggedScreen extends StatelessWidget {
  const TaggedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Tagged Ideas')),
        child: Center(child: Text('Tagged Screen')));
  }
}