import 'package:flutter/material.dart';

class WidgetHelper {
  static Widget buildChips(BuildContext context, List<String> items) {
    List<Widget> chips = new List<Widget>();

    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      ChoiceChip choiceChip = ChoiceChip(
        selected: false,
        label: Text(item, style: Theme.of(context).textTheme.body2),
        shadowColor: Colors.transparent,
      );

      chips.add(choiceChip);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            spacing: 5,
            runSpacing: -10,
            children: chips,
          )
        ]);
  }
}
