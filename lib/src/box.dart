import 'package:flutter/widgets.dart';
import 'package:following_wind/src/styles/style.dart';

import 'following_wind.dart';
import 'spacings.dart';
import 'support_internal.dart';

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

  static int _compareStyles(Style a, Style b) {
    final aIndex = a is SizeClassStyle ? a.sizeClass.index + 1 : 0;
    final bIndex = b is SizeClassStyle ? b.sizeClass.index + 1 : 0;
    return aIndex.compareTo(bIndex);
  }

  @override
  Widget build(BuildContext context) {
    final FollowingWindData fw = FollowingWind.of(context);

    /// sort the styles by, base then smallest to largest
    final sortedStyles = <Style>[...styles]..sort(_compareStyles);

    // dpl('fw: $fw');

    //TODO:KB 1/12/2024 how do we handle this with size classes
    // if (classes.contains('hidden')) {
    //   return const SizedBox.shrink();
    // }

    // Configure the layout first by processing all layout classes together
    Widget child;

    // don't wrap in FwFlex if there is only one child
    if (children.length == 1) {
      child = children[0];
    } else {
      var flexStyle = FlexStyle(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      );
      for (final style in sortedStyles.unpack<FlexStyle>(fw)) {
        flexStyle = flexStyle.mergeWith(style, fw);
      }

      // dpl('flexStyle: $flexStyle');

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
    // child = FwDefaultTextAndIconStyle(
    //   spacingMultiplier: fw.spacingScale,
    //   classKey: 'text',
    //   findValueForClass: findValueForClass,
    //   colors: colors,
    //   child: child,
    // );

    PaddingStyle? ps;
    for (final next in sortedStyles.unpack<PaddingStyle>(fw)) {
      ps = ps?.mergeWith(next, fw) ?? next;
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

    if (onPressed != null) {
      child = GestureDetector(
        onTap: onPressed,
        child: child,
      );
    }

    FlexibleStyle? flexibleStyle;
    for (final fs in sortedStyles.unpack<FlexibleStyle>(fw)) {
      flexibleStyle = fs;
    }

    dpl("flexibleStyle: $flexibleStyle");

    if (flexibleStyle != null && flexibleStyle.fit != null) {
      child = Flexible(
        flex: flexibleStyle.flex,
        fit: flexibleStyle.fit!,
        child: child,
      );
    }

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
