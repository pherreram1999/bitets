import 'package:flutter/material.dart';

List<Color> chartPalette(ColorScheme colorScheme) {
  return <Color>[
    colorScheme.primary,
    colorScheme.tertiary,
    colorScheme.secondary,
    colorScheme.primaryContainer,
    colorScheme.tertiaryContainer,
    colorScheme.secondaryContainer,
  ];
}

Color colorAt(List<Color> palette, int index) {
  return palette[index % palette.length];
}
