import 'package:flutter/material.dart';

class HoriztontalAlignment extends StatelessWidget {
  HoriztontalAlignment(this.child, this.alignment);
  final Widget child;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: alignment, children: [child]);
}
