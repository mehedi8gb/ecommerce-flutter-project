import 'package:flutter/material.dart';

class ThemeOverride extends StatelessWidget {
  const ThemeOverride({Key? key, required this.child, required this.theme}) : super(key: key);
  final Widget child;
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(data: theme.copyWith(
        scaffoldBackgroundColor: Theme.of(context).colorScheme.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: theme.colorScheme.secondary,
          onPrimary: theme.colorScheme.onSecondary,
        )
      ),
    ), child: child);
  }
}