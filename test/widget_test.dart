import 'package:flutter_test/flutter_test.dart';
import 'package:foldable_motion_lab/main.dart';

void main() {
  testWidgets('shows foldable motion lab', (tester) async {
    await tester.pumpWidget(const FoldableMotionLabApp());

    expect(find.text('FOLDABLE MOTION LAB'), findsOneWidget);
    expect(find.text('Fold simulator'), findsOneWidget);
  });
}
