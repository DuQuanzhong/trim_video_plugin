import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trim_video_plugin/src/trim_video_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('trim_video_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await TrimVideoPlugin.platformVersion, '42');
  });
}
