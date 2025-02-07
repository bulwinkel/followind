import 'package:flutter/widgets.dart';
import 'package:following_wind/src/styles/style.dart';
import 'package:following_wind/src/widgets/fw_default_text_and_icon_style.dart';

import 'colors.dart';
import 'following_wind.dart';
import 'parser.dart';
import 'parsers/decorated_box_parser.dart';
import 'parsers/size_parser.dart';
import 'spacings.dart';
import 'support_internal.dart';
import 'widgets/fw_flex.dart';
import 'widgets/fw_padding.dart';

// ignore: camel_case_types
class Box extends StatelessWidget {
  const Box({
    super.key,
    this.className = '',
    this.classNames = const [],
    this.styles = const [],
    this.onPressed,
    this.children = const [],
  });

  final String className;
  final List<String> classNames;
  final List<Style> styles;
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
    Widget child;

    // don't wrap in FwFlex if there is only one child
    if (children.length == 1) {
      child = children[0];
    } else {
      final defaultFlex = FlexStyle(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      );
      var flexStyle = defaultFlex;
      for (final style in styles) {
        if (style is FlexStyle) {
          flexStyle = flexStyle.mergeWith(style, fw.screenSize.width);
        }
      }

      dpl('flexStyle: $flexStyle');

      child = Flex(
        direction: flexStyle.direction!,
        crossAxisAlignment: flexStyle.crossAxisAlignment!,
        mainAxisAlignment: flexStyle.mainAxisAlignment!,
        mainAxisSize: flexStyle.mainAxisSize!,
        spacing: flexStyle.spacing?.unpack(
              axisMax: fw.screenSize.width,
              scale: fw.spacingScale,
            ) ??
            0,
        children: children,
      );
    }

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

    PaddingStyle? ps;
    for (final style in styles) {
      if (style is PaddingStyle) {
        ps = ps?.mergeWith(style, fw.screenSize.width) ?? style;
      }
    }
    if (ps != null) {
      child = Padding(
        padding: EdgeInsets.only(
          left: ps.left?.unpack(
                  axisMax: fw.screenSize.width, scale: fw.spacingScale) ??
              0,
          top: ps.top?.unpack(
                  axisMax: fw.screenSize.height, scale: fw.spacingScale) ??
              0,
          right: ps.right?.unpack(
                  axisMax: fw.screenSize.width, scale: fw.spacingScale) ??
              0,
          bottom: ps.bottom?.unpack(
                  axisMax: fw.screenSize.height, scale: fw.spacingScale) ??
              0,
        ),
        child: child,
      );
    }

    final decoratedBoxParser = DecoratedBoxParser(fw: fw);
    final sizeParser = SizeParser(fw: fw);
    final List<Parser> parsers = [decoratedBoxParser, sizeParser];

    for (final className in classes) {
      for (final parser in parsers) {
        final consumed = parser.parse(className);
        if (consumed) break;
      }
    }

    child = decoratedBoxParser.apply(child);

    child = sizeParser.apply(child);

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
