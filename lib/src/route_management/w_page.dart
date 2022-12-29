import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

/// Model class for named route.
class WPage {
  /// Route path.
  final String path;

  /// Title for [CupertinoPageRoute]
  final String? title;

  /// Register service.
  final List<SingleChildWidget> Function(
    BuildContext context,
    dynamic arguments,
  )? providerBuilder;

  /// Builds the primary contents of the route.
  final Widget Function(BuildContext context, dynamic arguments) builder;

  WPage({
    required this.path,
    this.title,
    this.providerBuilder,
    required this.builder,
  });
}
