import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The app promises no internet, no ads and no tracking (CONTRIBUTING §6).
/// These checks keep that promise from slipping in through a dependency or a permission.
void main() {
  test(
    'no networking, ads, analytics or crash-reporting package is resolved',
    () {
      final lock = File('pubspec.lock').readAsStringSync();
      final packages = RegExp(
        r'^  ([a-z0-9_]+):$',
        multiLine: true,
      ).allMatches(lock).map((m) => m[1]!);
      final banned = RegExp(
        r'^(http|dio|web_socket|grpc|firebase|google_mobile_ads|.*_ads|.*analytics|sentry|.*crashlytics|url_launcher|webview)',
      );
      expect(packages.where(banned.hasMatch), isEmpty);
    },
  );

  test('the release Android manifest asks for no permissions', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifest, isNot(contains('uses-permission')));
  });
}
