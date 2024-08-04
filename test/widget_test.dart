import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:freetogame/lib/main.dart';

void main() {
  testWidgets('test initial MyApp render', (WidgetTester tester) async {
    // Constrói o MyApp e aciona um frame
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => GameListProvider()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Lista de Games'), findsOneWidget);
  });
}
