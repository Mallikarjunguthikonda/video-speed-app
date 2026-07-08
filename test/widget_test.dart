import 'package:flutter_test/flutter_test.dart';
import 'package:video_speed_app/main.dart';

void main() {
  testWidgets('App shows home screen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const VideoSpeedApp());
    await tester.pumpAndSettle();

    expect(find.text('Video Speed Changer'), findsOneWidget);
    expect(find.text('Pick a Video'), findsOneWidget);
    expect(find.text('Change video playback speed'), findsOneWidget);
  });
}
