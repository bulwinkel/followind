import 'package:flutter/material.dart';

import 'class_parser.dart';

// ignore: camel_case_types
class Box extends StatelessWidget {
  Box({
    super.key,
    this.className = '',
    this.children = const [],
  });

  final String className;
  final List<Widget> children;
  final ClassParser classParser = ClassParser();

  @override
  Widget build(BuildContext context) {
    return classParser.parse(
      className,
      children,
    );
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
