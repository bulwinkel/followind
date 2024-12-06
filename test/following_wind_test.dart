import 'package:flutter_test/flutter_test.dart';
import 'package:following_wind/src/support_internal.dart';
import 'package:following_wind/src/widgets/fw_padding.dart';

void main() {
  group('findResponsiveModifiers', () {
    final responsiveModifiers = {
      'sm': 640.0,
      'md': 768.0,
      'lg': 1024.0,
      'xl': 1280.0,
      '2xl': 1536.0,
    };

    test('< 640', () {
      final screenSize = 600.0;
      final result = findResponsiveModifiers(screenSize, responsiveModifiers);
      expect(result, []);
    });
    test('640', () {
      final screenSize = 640.0;
      final result = findResponsiveModifiers(screenSize, responsiveModifiers);
      expect(result, ['sm']);
    });
    test('> 640 && < 768', () {
      final screenSize = 700.0;
      final result = findResponsiveModifiers(screenSize, responsiveModifiers);
      expect(result, ['sm']);
    });
    test('768', () {
      final screenSize = 768.0;
      final result = findResponsiveModifiers(screenSize, responsiveModifiers);
      expect(result, ['sm', 'md']);
    });
  });

  group("padding", () {
    const sizeClasses = {
      'sm': 640.0,
      'md': 768.0,
      'lg': 1024.0,
      'xl': 1280.0,
      '2xl': 1536.0,
    };

    test("should parse single unprefixed value", () {
      final classes = collectClasses("", [
        "p-4 bg-blue-500 rounded-xl",
      ]);

      final parsedClasses = parseClasses(
        classes: classes,
        classTypes: FwPadding.classTypesPadding,
        sizeClasses: sizeClasses,
      );

      // apply the padding
      expect(
        parsedClasses,
        equals(
          [
            (
              applyAtWidth: 0.0,
              value: '4',
              sortOrder: 0.0,
              type: 'p',
            ),
          ],
        ),
      );
    });

    test("should parse single prefixed value", () {
      final classes = collectClasses("", [
        "md:p-4 bg-blue-500 rounded-xl",
      ]);

      final parsedClasses = parseClasses(
        classes: classes,
        classTypes: FwPadding.classTypesPadding,
        sizeClasses: sizeClasses,
      );

      // apply the padding
      expect(
        parsedClasses,
        equals(
          [
            (
              applyAtWidth: 768.0,
              value: '4',
              sortOrder: 768.0,
              type: 'p',
            ),
          ],
        ),
      );
    });

    test("should parse multiple prefixed values", () {
      final classes = collectClasses("", [
        "md:p-4 lg:pl-8 bg-blue-500 rounded-xl",
      ]);

      final parsedClasses = parseClasses(
        classes: classes,
        classTypes: FwPadding.classTypesPadding,
        sizeClasses: sizeClasses,
      );

      // apply the padding
      expect(
        parsedClasses,
        equals(
          [
            (
              applyAtWidth: 768.0,
              value: '4',
              sortOrder: 768.0,
              type: 'p',
            ),
            (
              applyAtWidth: 1024.0,
              value: '8',
              sortOrder: 1030.0,
              type: 'pl',
            ),
          ],
        ),
      );
    });
  });
}
