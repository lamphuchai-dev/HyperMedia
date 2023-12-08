import 'package:flutter/material.dart';

import 'platform_widget.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch(
      {super.key,
      required this.value,
      required this.label,
      required this.onChange});
  final bool value;
  final String label;
  final ValueChanged<bool> onChange;

  @override
  Widget build(BuildContext context) {
    return ThemeBuildWidget(
        builder: (context, themeData, textTheme, colorScheme) {
      return GestureDetector(
        onTap: () {
          onChange.call(!value);
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              width: 45,
              height: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: value
                              ? colorScheme.primary
                              : colorScheme.onSurface),
                    ),
                  ),
                  AnimatedAlign(
                    alignment:
                        value ? Alignment.centerRight : Alignment.centerLeft,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.circle,
                      color:
                          value ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
