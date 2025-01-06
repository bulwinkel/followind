import 'package:flutter/widgets.dart';
import 'package:following_wind/src/support_internal.dart';

import '../following_wind.dart';

abstract interface class Parser {
  /// return true if the class was processed / consumed
  bool parse(String className);

  List<ParsedClass> get values;

  Widget apply(Widget child);

  void reset();
}

abstract class BaseParser implements Parser {
  BaseParser({
    required this.fw,
    required this.classPrefixes,
  });

  final FollowingWindData fw;
  final List<String> classPrefixes;

  final List<ParsedClass> _parsedClasses = [];

  @override
  List<ParsedClass> get values => _parsedClasses;

  @protected
  void add(ParsedClass className) {
    _parsedClasses.add(className);
  }

  @protected
  void sort() {
    _parsedClasses.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  bool parse(String className) {
    final (consumed, parsed) = parseClass(
      className,
      classPrefixes,
      fw.sizeClasses,
    );
    if (parsed != null) add(parsed);
    return consumed;
  }

  @override
  void reset() {
    _parsedClasses.clear();
  }
}
