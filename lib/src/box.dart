import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:following_wind/src/styles/style.dart';
import 'package:following_wind/src/support_internal.dart';

import 'following_wind.dart';
import 'spacings.dart';

// ignore: camel_case_types
class Box extends StatefulWidget {
  const Box({
    super.key,
    this.styles = const [],
    this.onPressed,
    this.children = const [],
  });

  final List<Style> styles;
  final List<Widget> children;
  final VoidCallback? onPressed;

  @override
  State<Box> createState() => _BoxState();
}

int _compareStyles(Style a, Style b) {
  final aIndex =
      a is ModifierStyle && a.sizeClass != null ? a.sizeClass!.index + 1 : 0;
  final bIndex =
      b is ModifierStyle && b.sizeClass != null ? b.sizeClass!.index + 1 : 0;
  return aIndex.compareTo(bIndex);
}

void _doNothing() {}

class _BoxState extends State<Box> {
  bool _isHovered = false;

  void invalidate() {
    setState(_doNothing);
  }

  void _onMouseEnter(PointerEnterEvent event) {
    dpl('mouse enter');
    _isHovered = true;
    invalidate();
  }

  void _onMouseExit(PointerExitEvent event) {
    dpl('mouse exit');
    _isHovered = false;
    invalidate();
  }

  @override
  Widget build(BuildContext context) {
    final FollowingWindData fw = FollowingWind.of(context);

    /// sort the styles by, base then smallest to largest
    final sortedStyles = <Style>[...widget.styles]..sort(_compareStyles);

    // dpl('fw: $fw');

    //TODO:KB 1/12/2024 how do we handle this with size classes
    // if (classes.contains('hidden')) {
    //   return const SizedBox.shrink();
    // }

    // Configure the layout first by processing all layout classes together
    Widget child;

    // don't wrap in FwFlex if there is only one child
    if (widget.children.length == 1) {
      child = widget.children[0];
    } else {
      var flexStyle = FlexStyle(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      );
      for (final style in sortedStyles.unpack<FlexStyle>(fw, _isHovered)) {
        flexStyle = flexStyle.mergeWith(style, fw);
      }

      // dpl('flexStyle: $flexStyle');

      child = Flex(
        direction: flexStyle.direction!,
        crossAxisAlignment: flexStyle.crossAxisAlignment!,
        mainAxisAlignment: flexStyle.mainAxisAlignment!,
        mainAxisSize: flexStyle.mainAxisSize!,
        spacing:
            flexStyle.spacing?.unpack(
              axisMax: fw.screenSize.width,
              scale: fw.spacingScale,
            ) ??
            0,
        children: widget.children,
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
    for (final next in sortedStyles.unpack<PaddingStyle>(fw, _isHovered)) {
      ps = ps?.mergeWith(next, fw) ?? next;
    }

    if (ps != null) {
      child = Padding(
        padding: EdgeInsets.only(
          left:
              ps.left?.unpack(
                axisMax: fw.screenSize.width,
                scale: fw.spacingScale,
              ) ??
              0,
          top:
              ps.top?.unpack(
                axisMax: fw.screenSize.height,
                scale: fw.spacingScale,
              ) ??
              0,
          right:
              ps.right?.unpack(
                axisMax: fw.screenSize.width,
                scale: fw.spacingScale,
              ) ??
              0,
          bottom:
              ps.bottom?.unpack(
                axisMax: fw.screenSize.height,
                scale: fw.spacingScale,
              ) ??
              0,
        ),
        child: child,
      );
    }

    // -- Decorations -
    //
    // Applied after padding but before margin
    DecoratedBoxStyle? dbs;
    for (final next in sortedStyles.unpack<DecoratedBoxStyle>(fw, _isHovered)) {
      dbs = dbs?.mergeWith(next) ?? next;
    }

    if (dbs != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: dbs.color,
          image: dbs.image,
          border: dbs.border,
          borderRadius: dbs.borderRadius,
          boxShadow: dbs.boxShadow,
          gradient: dbs.gradient,
          backgroundBlendMode: dbs.backgroundBlendMode,
          shape: dbs.shape ?? BoxShape.rectangle,
        ),
        child: child,
      );
    }

    // -- Gesture -
    //
    // Applied after decorations but before margin / external spacing since
    // you wouldn't expect a gesture to work outside of the the decorated
    // part of the widget.
    if (widget.onPressed != null) {
      child = GestureDetector(onTap: widget.onPressed, child: child);
    }

    // -- Hover -

    // are there any hover styles?
    final hasHover = sortedStyles.any(
      (it) => it is ModifierStyle && it.hover == true,
    );
    if (hasHover) {
      child = MouseRegion(
        onEnter: _onMouseEnter,
        onExit: _onMouseExit,
        child: child,
      );
    }

    // -- Margin -
    //
    // External spacing applied outside of any decorations

    MarginStyle? ms;
    for (final next in sortedStyles.unpack<MarginStyle>(fw, _isHovered)) {
      ms = ms?.mergeWith(next, fw) ?? next;
    }

    if (ms != null) {
      child = Padding(
        padding: EdgeInsets.only(
          left:
              ms.left?.unpack(
                axisMax: fw.screenSize.width,
                scale: fw.spacingScale,
              ) ??
              0,
          top:
              ms.top?.unpack(
                axisMax: fw.screenSize.height,
                scale: fw.spacingScale,
              ) ??
              0,
          right:
              ms.right?.unpack(
                axisMax: fw.screenSize.width,
                scale: fw.spacingScale,
              ) ??
              0,
          bottom:
              ms.bottom?.unpack(
                axisMax: fw.screenSize.height,
                scale: fw.spacingScale,
              ) ??
              0,
        ),
        child: child,
      );
    }

    // -- Flexible -
    //
    // Must be the last style since it needs to be closes to the top
    // so it is closest to the parent Flex widget

    FlexibleStyle? flexibleStyle;
    for (final fs in sortedStyles.unpack<FlexibleStyle>(fw, _isHovered)) {
      flexibleStyle = fs;
    }

    // dpl("flexibleStyle: $flexibleStyle");

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
