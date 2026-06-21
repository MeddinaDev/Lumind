import 'package:flutter_test/flutter_test.dart';
import 'package:lumind/main.dart';

void main() {
  testWidgets('Carga inicial de LumindApp', (WidgetTester tester) async {
    // Construye nuestra aplicación y dispara un frame.
    await tester.pumpWidget(const LumindApp());

    // Verifica que el texto inicial aparece en pantalla.
    expect(find.text('Lumind: Entorno inicializado ⚡️'), findsOneWidget);
  });
}