import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockchef/app.dart';

void main() {
  testWidgets('App boots into the Cook tab with a bottom nav', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StockChefApp()));
    await tester.pumpAndSettle();

    // Bottom navigation is present with all five destinations.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Cook'), findsWidgets);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Restock'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
