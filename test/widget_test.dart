import 'package:flutter_test/flutter_test.dart';
import 'package:foldable_motion_lab/main.dart';

void main() {
  testWidgets('renders foldable actions and simulator', (tester) async {
    await tester.pumpWidget(const FoldableMotionLabApp());
    await tester.pumpAndSettle();

    expect(find.text('FOLDABLE MOTION LAB'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Fold settings'), findsOneWidget);
    expect(find.text('Fold simulator'), findsOneWidget);
  });

  testWidgets('tapping Notes opens functional notes workspace', (tester) async {
    await tester.pumpWidget(const FoldableMotionLabApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    expect(find.text('Notes stay exactly where you left them.'), findsOneWidget);
    expect(find.text('New note'), findsOneWidget);
  });
}
