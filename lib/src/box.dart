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

  // -- region: style unpacking
  // doesn't invalidate, just caches objects
  // to prevent unnecessary allocations and loops

  bool _isHoverRequired = false;
  final List<Style> _sortedStyles = [];

  final List<FlexStyle> _flexStyles = [];
  FlexStyle _flexStyle = FlexStyle.defaultStyle;

  final List<FWTextStyle> _textStyles = [];
  FWTextStyle? _textStyle;

  final List<PaddingStyle> _paddingStyles = [];
  PaddingStyle? _paddingStyle;

  final List<DecoratedBoxStyle> _decoratedBoxStyles = [];
  DecoratedBoxStyle? _decoratedBoxStyle;

  final List<MarginStyle> _marginStyles = [];
  MarginStyle? _marginStyle;

  final List<FlexibleStyle> _flexibleStyles = [];
  FlexibleStyle? _flexibleStyle;

  void _unpackStyles(FollowingWindData fw) {
    // -- reset
    _isHoverRequired = false;

    _sortedStyles.clear();

    _flexStyles.clear();
    _flexStyle = FlexStyle.defaultStyle;

    _textStyles.clear();
    _textStyle = null;

    _paddingStyles.clear();
    _paddingStyle = null;

    _decoratedBoxStyles.clear();
    _decoratedBoxStyle = null;

    _marginStyles.clear();
    _marginStyle = null;

    _flexibleStyles.clear();
    _flexibleStyle = null;

    // -- sort
    _sortedStyles.addAll(widget.styles);
    _sortedStyles.sort(_compareStyles);

    // -- unpack into style types
    for (var style in _sortedStyles) {
      // unpack modifier and check if applicable
      if (style is ModifierStyle) {
        if (style.hover == true) {
          _isHoverRequired = true;
        }

        final isApplicable =
            fw.screenSize.width >= fw.sizeForClass(style.sizeClass) &&
            // if style.hover == null then ignore isHovered
            // if style.hover == true then only yield if isHovered
            (style.hover == null || style.hover == _isHovered);

        // GUARD
        if (!isApplicable) {
          continue;
        }

        style = style.style;
      }

      if (style is FlexStyle) {
        _flexStyles.add(style);
        _flexStyle = _flexStyle.mergeWith(style, fw);
      }

      if (style is FWTextStyle) {
        _textStyles.add(style);
        _textStyle = _textStyle?.mergeWith(style) ?? style;
      }

      if (style is PaddingStyle) {
        _paddingStyles.add(style);
        _paddingStyle = _paddingStyle?.mergeWith(style) ?? style;
      }

      if (style is DecoratedBoxStyle) {
        _decoratedBoxStyles.add(style);
        _decoratedBoxStyle = _decoratedBoxStyle?.mergeWith(style) ?? style;
      }

      if (style is MarginStyle) {
        _marginStyles.add(style);
        _marginStyle = _marginStyle?.mergeWith(style) ?? style;
      }

      if (style is FlexibleStyle) {
        _flexibleStyles.add(style);
        _flexibleStyle = style;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO:KB 14/2/2025 could performance by only unpacking the styles
    // when the widget is invalidated
    final FollowingWindData fw = FollowingWind.of(context);
    _unpackStyles(fw);

    // dpl('fw: $fw');

    //TODO:KB 1/12/2024 how do we handle this with size classes
    // if (classes.contains('hidden')) {
    //   return const SizedBox.shrink();
    // }

    // Configure the layout first by processing all layout classes together
    Widget child;

    // -- Layout -

    // don't wrap in FwFlex if there is only one child
    if (widget.children.length == 1) {
      child = widget.children[0];
    } else {
      // dpl('flexStyle: $_flexStyle');
      child = Flex(
        direction: _flexStyle.direction!,
        crossAxisAlignment: _flexStyle.crossAxisAlignment!,
        mainAxisAlignment: _flexStyle.mainAxisAlignment!,
        mainAxisSize: _flexStyle.mainAxisSize!,
        spacing:
            _flexStyle.spacing?.unpack(
              axisMax: fw.screenSize.width,
              scale: fw.spacingScale,
            ) ??
            0,
        children: widget.children,
      );
    }

    // -- Text -
    final ts = _textStyle?.unpack();
    final textAlign = _textStyle?.textAlign;
    if (ts != null || textAlign != null) {
      child = DefaultTextStyle(
        style: ts ?? const TextStyle(),
        textAlign: _textStyle?.textAlign,
        child: child,
      );
    }

    final iconColor = _textStyle?.color;
    if (iconColor != null) {
      child = IconTheme(data: IconThemeData(color: iconColor), child: child);
    }

    final ps = _paddingStyle;
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
    final dbs = _decoratedBoxStyle;
    if (dbs != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: dbs.color,
          image: dbs.image,
          border: dbs.border?.unpack(),
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
    if (_isHoverRequired) {
      child = MouseRegion(
        onEnter: _onMouseEnter,
        onExit: _onMouseExit,
        child: child,
      );
    }

    // -- Margin -
    //
    // External spacing applied outside of any decorations

    final ms = _marginStyle;
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

    final flexibleStyle = _flexibleStyle;
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
