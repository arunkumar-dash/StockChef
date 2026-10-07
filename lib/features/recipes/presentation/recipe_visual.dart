import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';

/// A deterministic visual identity for a recipe: a gradient and a food emoji.
///
/// We don't bundle photographs (licensing + offline size), so each recipe gets
/// a stable, attractive gradient (seeded from its id) and an emoji chosen from
/// keywords in its name, falling back to its meal type. Deterministic, so the
/// same recipe always looks the same.
class RecipeVisual {
  const RecipeVisual({required this.colors, required this.emoji});
  final List<Color> colors;
  final String emoji;

  Gradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static const List<List<Color>> _palettes = [
    [Color(0xFF2E7D5B), Color(0xFF66BB6A)],
    [Color(0xFFEF6C00), Color(0xFFFFB74D)],
    [Color(0xFFAD1457), Color(0xFFF06292)],
    [Color(0xFF00838F), Color(0xFF4DD0E1)],
    [Color(0xFF5E35B1), Color(0xFF9575CD)],
    [Color(0xFFC62828), Color(0xFFEF5350)],
    [Color(0xFF6D4C41), Color(0xFFA1887F)],
    [Color(0xFF00695C), Color(0xFF4DB6AC)],
  ];

  /// Ordered so more specific keywords win (checked with `contains`).
  static const List<(String, String)> _keywordEmoji = [
    ('dosa', '🫓'), ('adai', '🫓'), ('uttapam', '🫓'), ('cheela', '🫓'),
    ('idli', '🍥'), ('idly', '🍥'),
    ('vada', '🍩'), ('bonda', '🍩'), ('bajji', '🧅'), ('pakod', '🧅'),
    ('rice', '🍚'), ('pulao', '🍚'), ('biryani', '🍚'), ('pongal', '🍚'),
    ('pakhala', '🍚'), ('kanika', '🍚'), ('sadam', '🍚'),
    ('dal', '🍲'), ('dalma', '🍲'), ('sambar', '🍲'), ('rasam', '🍲'),
    ('kuzhambu', '🍲'), ('curry', '🍛'), ('kootu', '🍲'), ('besara', '🍲'),
    ('santula', '🥘'), ('poriyal', '🥗'), ('thoran', '🥗'), ('bhaja', '🍳'),
    ('roti', '🫓'), ('paratha', '🫓'), ('thepla', '🫓'), ('luchi', '🫓'),
    ('paneer', '🧀'), ('egg', '🥚'), ('chicken', '🍗'), ('mutton', '🍖'),
    ('fish', '🐟'), ('macha', '🐟'), ('prawn', '🦐'), ('chingudi', '🦐'),
    ('chutney', '🥣'), ('pachadi', '🥣'), ('khata', '🥣'),
    ('ladoo', '🍬'), ('laddu', '🍬'), ('burfi', '🍬'), ('mysore pak', '🍬'),
    ('payasam', '🍮'), ('kheer', '🍮'), ('poda', '🍮'), ('pitha', '🍮'),
    ('halwa', '🍮'), ('kesari', '🍮'), ('rasabali', '🍮'),
    ('upma', '🥣'), ('poha', '🥣'), ('ghuguni', '🫘'), ('chana', '🫘'),
    ('sundal', '🫘'), ('rajma', '🫘'), ('dhokla', '🟡'), ('khaman', '🟡'),
    ('coffee', '☕'), ('tea', '🍵'), ('milk', '🥛'), ('lassi', '🥛'),
    ('kadhi', '🍜'), ('misal', '🍜'), ('pithla', '🍲'),
  ];

  static String _emojiForMeal(MealType meal) => switch (meal) {
        MealType.breakfast => '🍳',
        MealType.lunch => '🍛',
        MealType.dinner => '🍲',
        MealType.snack => '🍿',
        MealType.dessert => '🍮',
        MealType.beverage => '🥤',
      };

  factory RecipeVisual.of(Recipe recipe) {
    // Stable palette from the id.
    var hash = 0;
    for (final code in recipe.id.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    final colors = _palettes[hash % _palettes.length];

    final name = recipe.name.toLowerCase();
    var emoji = _emojiForMeal(recipe.mealType);
    for (final (keyword, e) in _keywordEmoji) {
      if (name.contains(keyword)) {
        emoji = e;
        break;
      }
    }
    return RecipeVisual(colors: colors, emoji: emoji);
  }
}
