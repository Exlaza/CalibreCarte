import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Calibre Carte', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final SerializableFinder homePageWithSP = find.byValueKey('homePageWithSP');
    final homePageWithoutSP = find.byValueKey('homePageWithoutSP');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    isPresent(SerializableFinder byValueKey, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey,timeout: timeout);
        return true;
      } catch(exception) {
        return false;
      }
    }

    test('check if text widget is present', () async {
      final isExists = await isPresent(find.byValueKey('homePageWithoutSP'), driver);
      if (isExists) {
        print('widget is present');
      } else {
        print('widget is not present');
      }
    });



//    test('increments the counter', () async {
//      // First, tap the button.
//      await driver.tap(buttonFinder);
//
//      // Then, verify the counter text is incremented by 1.
//      expect(await driver.getText(counterTextFinder), "1");
//    });
  });
}
