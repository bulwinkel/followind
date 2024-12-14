import 'package:flutter/widgets.dart';
import 'package:following_wind/src/widgets/fw_default_text_and_icon_style.dart';

import 'colors.dart';
import 'following_wind.dart';
import 'parsers/size_parser.dart';
import 'spacings.dart';
import 'support_internal.dart';
import 'widgets/fw_decorated_box.dart';
import 'widgets/fw_flex.dart';
import 'widgets/fw_padding.dart';

// ignore: camel_case_types
class Box extends StatelessWidget {
  const Box({
    super.key,
    this.className = '',
    this.classNames = const [],
    this.onPressed,
    this.children = const [],
  });

  final String className;
  final List<String> classNames;
  final List<Widget> children;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final FollowingWindData fw = FollowingWind.of(context);
    final classes = collectClasses(className, classNames);

    // dpl('fw: $fw');

    //TODO:KB 1/12/2024 how do we handle this with size classes
    if (classes.contains('hidden')) {
      return const SizedBox.shrink();
    }

    T findValueForClass<T>(
      Map<String, T> lookup,
      T defaultValue,
    ) {
      T? result;

      for (final className in lookup.keys) {
        if (classes.contains(className)) {
          result = lookup[className];
          break;
        }
      }

      return result ?? defaultValue;
    }

    // Configure the layout first by processing all layout classes together
    Widget child = FwFlex(
      classes: classes,
      spacingMultiplier: fw.spacingScale,
      spacings: spacings.keys.toList(),
      children: children,
    );

    // Apply text styles
    child = FwDefaultTextAndIconStyle(
      spacingMultiplier: fw.spacingScale,
      classKey: 'text',
      findValueForClass: findValueForClass,
      colors: colors,
      child: child,
    );

    // internal spacing
    child = FwPadding(
      classTypes: FwPadding.classTypesPadding,
      edgeInsets: fw.paddings,
      classes: classes,
      child: child,
    );

    child = FwDecoratedBox(
      classes: classes,
      bgColors: fw.bgColors,
      borderColor: fw.borderColor,
      borderColors: fw.borderColors,
      borderWidths: fw.borderWidths,
      borderRadiuses: fw.borderRadiuses,
      child: child,
    );

    final sizeParser = SizeParser(fw);
    for (final className in classes) {
      sizeParser.parse(className);
    }

    final size = sizeParser.result;
    if (size != null) {
      child = SizedBox(
        height: size.height,
        width: size.width,
        child: child,
      );
    }

    if (onPressed != null) {
      child = GestureDetector(
        onTap: onPressed,
        child: child,
      );
    }

    // external spacing
    child = FwPadding(
      classTypes: FwPadding.classTypesMargin,
      edgeInsets: fw.margins,
      classes: classes,
      child: child,
    );

    return child;
  }
}

Widget box(
  String className,
  List<Widget> children, {
  Key? key,
}) {
  return Box(
    key: key,
    className: className,
    children: children,
  );
}
