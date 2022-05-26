import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:flutter/material.dart';

class ColoredIcon extends StatelessWidget {

  const ColoredIcon({Key? key, required this.item}) : super(key: key);

  final Child item;

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color iconColor = isDark ? Theme.of(context).iconTheme.color! : AppStateModel().blocks.settings.menuTheme.light.hintColor;

    return item.iconStyle != null ? Card(
      margin: EdgeInsets.all(0),
      color: item.iconStyle!.backgroundColor,
      elevation: item.iconStyle!.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(item.iconStyle!.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(baoIconList.firstWhere((element) => element.label == item.leading).icon, color: item.iconStyle!.color),
      ),
    ) : Icon(baoIconList.firstWhere((element) => element.label == item.leading).icon, color: iconColor);
  }
}