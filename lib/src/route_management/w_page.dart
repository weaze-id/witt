import 'package:flutter/widgets.dart';

/// Model class for named route.
class WPage {
  /// Route path.
  final String path;

  /// Title for [CupertinoPageRoute]
  final String? title;

  /// Register service.
  final void Function(BuildContext context)? serviceBuilder;

  /// Builds the primary contents of the route.
  final Widget Function(BuildContext context, dynamic arguments) builder;

  WPage({
    required this.path,
    this.title,
    this.serviceBuilder,
    required this.builder,
  });
}
