import 'package:followind/followind.dart';

List<Style> $children(List<Style> styles) {
  final children = <Style>[];
  for (var style in styles) {
    style = ModifierStyle.mergeWith(style: style, children: true);
    children.add(style);
  }
  return children;
}
