import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:followind/src/styles/style.dart';
import 'package:followind/src/support_internal.dart';

import 'followind.dart';
import 'followind_config.dart';
import 'spacings.dart';

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
    dp('mouse enter');
    _isHovered = true;
    invalidate();
  }

  void _onMouseExit(PointerExitEvent event) {
    dp('mouse exit');
    _isHovered = false;
    invalidate();
  }

  // -- region: style unpacking
  // doesn't invalidate, just caches objects
  // to prevent unnecessary allocations and loops

  bool _isHoverRequired = false;
  final List<Style> _childStyles = [];
  final List<Style> _sortedStyles = [];

  final List<FlexStyle> _flexStyles = [];
  FlexStyle _flexStyle = FlexStyle.defaultStyle;

  final List<FWTextStyle> _textStyles = [];
  FWTextStyle? _textStyle;

  final List<PaddingStyle> _paddingStyles = [];
  PaddingStyle? _paddingStyle;

  final List<DecoratedBoxStyle> _decoratedBoxStyles = [];
  DecoratedBoxStyle? _decoratedBoxStyle;

  final List<SizeStyle> _sizeStyles = [];
  SizeStyle? _sizeStyle;

  final List<MarginStyle> _marginStyles = [];
  MarginStyle? _marginStyle;

  final List<AlignStyle> _alignStyles = [];
  AlignStyle? _alignStyle;

  final List<FlexibleStyle> _flexibleStyles = [];
  FlexibleStyle? _flexibleStyle;

  void _unpackStyles(FollowindConfig f, Size screenSize) {
    // -- reset
    _isHoverRequired = false;

    _childStyles.clear();
    _sortedStyles.clear();

    _flexStyles.clear();
    _flexStyle = FlexStyle.defaultStyle;

    _textStyles.clear();
    _textStyle = null;

    _paddingStyles.clear();
    _paddingStyle = null;

    _decoratedBoxStyles.clear();
    _decoratedBoxStyle = null;

    _sizeStyles.clear();
    _sizeStyle = null;

    _marginStyles.clear();
    _marginStyle = null;

    _alignStyles.clear();
    _alignStyle = null;

    _flexibleStyles.clear();
    _flexibleStyle = null;

    // -- split styles
    for (var style in widget.styles) {
      if (style is ModifierStyle && style.children == true) {
        _childStyles.add(
          ModifierStyle.mergeWith(style: style, children: false),
        );
      } else {
        _sortedStyles.add(style);
      }
    }

    // -- sort
    _sortedStyles.sort(_compareStyles);

    // -- unpack into style types
    for (var style in _sortedStyles) {
      // unpack modifier and check if applicable
      if (style is ModifierStyle) {
        if (style.hover == true) {
          _isHoverRequired = true;
        }

        final isApplicable =
            screenSize.width >= f.breakpointForSizeClass(style.sizeClass) &&
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
        _flexStyle = _flexStyle.mergeWith(style, f);
        continue;
      }

      if (style is FWTextStyle) {
        _textStyles.add(style);
        _textStyle = _textStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is PaddingStyle) {
        _paddingStyles.add(style);
        _paddingStyle = _paddingStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is DecoratedBoxStyle) {
        _decoratedBoxStyles.add(style);
        _decoratedBoxStyle = _decoratedBoxStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is SizeStyle) {
        _sizeStyles.add(style);
        _sizeStyle = _sizeStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is MarginStyle) {
        _marginStyles.add(style);
        _marginStyle = _marginStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is AlignStyle) {
        _alignStyles.add(style);
        _alignStyle = _alignStyle?.mergeWith(style) ?? style;
        continue;
      }

      if (style is FlexibleStyle) {
        _flexibleStyles.add(style);
        _flexibleStyle = style;
        continue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO:KB 14/2/2025 could performance by only unpacking the styles
    // when the widget is invalidated
    final fw = Followind.of(context);
    final screenSize = MediaQuery.of(context).size;

    _unpackStyles(fw, screenSize);

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
      if (_childStyles.isNotEmpty) {
        child = Box(styles: _childStyles, children: [child]);
      }
    } else {
      var children = widget.children;
      if (_childStyles.isNotEmpty) {
        children = [
          for (var child in widget.children)
            Box(styles: _childStyles, children: [child]),
        ];
      }

      // dpl('flexStyle: $_flexStyle');
      child = Flex(
        direction: _flexStyle.direction!,
        crossAxisAlignment: _flexStyle.crossAxisAlignment!,
        mainAxisAlignment: _flexStyle.mainAxisAlignment!,
        mainAxisSize: _flexStyle.mainAxisSize!,
        spacing: _flexStyle.spacing?.unpack(fw) ?? 0,
        children: children,
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
          left: ps.left?.unpack(fw) ?? 0,
          top: ps.top?.unpack(fw) ?? 0,
          right: ps.right?.unpack(fw) ?? 0,
          bottom: ps.bottom?.unpack(fw) ?? 0,
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

    final constraints = _sizeStyle?.unpack(fw);
    if (constraints != null) {
      child = ConstrainedBox(constraints: constraints, child: child);
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
          left: ms.left?.unpack(fw) ?? 0,
          top: ms.top?.unpack(fw) ?? 0,
          right: ms.right?.unpack(fw) ?? 0,
          bottom: ms.bottom?.unpack(fw) ?? 0,
        ),
        child: child,
      );
    }

    // -- Align
    //
    // By applying before flexible it will align within the space
    // created by the flexible widget below.

    final alignment = _alignStyle?.unpack();
    if (alignment != null) {
      child = Align(alignment: alignment, child: child);
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
