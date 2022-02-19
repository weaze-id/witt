import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'w_infinite_list_state.dart';

/// Create a list view builder for lazy loading list from API.
class WInfiniteListBuilderSliver extends StatefulWidget {
  const WInfiniteListBuilderSliver({
    Key? key,
    required this.state,
    required this.onLoad,
    required this.itemBuilder,
    required this.itemCount,
    this.loadingBuilder,
    this.noInternetMessageBuilder,
    this.emptyMessageBuilder,
  }) : super(key: key);

  /// Define current state.
  final WInfiniteListState state;

  /// Callback when user scroll to the end of list and the state
  /// is [WInfiniteListState.idle].
  final Future<void> Function() onLoad;

  /// The [itemBuilder] callback will be called only with indices greater than
  /// or equal to zero and less than [itemCount].
  final Widget Function(BuildContext, int) itemBuilder;

  /// Providing a non-null itemCount improves the ability of the [ListView]
  /// to estimate the maximum scroll extent.
  final int itemCount;

  /// A widget to show if the state is [WInfiniteListState.initialLoading].
  final Widget? loadingBuilder;

  /// A widget to show if the state is [WInfiniteListState.noInternet].
  final Widget? noInternetMessageBuilder;

  /// A widget to show if the state is [WInfiniteListState.empty].
  final Widget? emptyMessageBuilder;

  @override
  State<WInfiniteListBuilderSliver> createState() =>
      _WInfiniteListBuilderSliverState();
}

class _WInfiniteListBuilderSliverState
    extends State<WInfiniteListBuilderSliver> {
  bool _isLoading = false;

  /// Item builder for [ListView.builder].
  Widget _itemBuilder(context, index) {
    // If [widget.state] is idle and current index is greater than [itemCount],
    // show [CupertinoActivityIndicator].
    if (widget.state == WInfiniteListState.idle &&
        index > widget.itemCount - 1) {
      // Call onLoad when _isLoading is false.
      if (!_isLoading) {
        _isLoading = true;
        widget.onLoad().then((value) => _isLoading = false);
      }

      return const ListTile(title: CupertinoActivityIndicator());
    }

    return widget.itemBuilder(context, index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == WInfiniteListState.initialLoading) {
      return SliverToBoxAdapter(
          child: widget.loadingBuilder ??
              const Center(child: CupertinoActivityIndicator()));
    }

    if (widget.state == WInfiniteListState.noInternet) {
      return SliverToBoxAdapter(
          child: widget.noInternetMessageBuilder ?? const SizedBox());
    }

    if (widget.state == WInfiniteListState.empty) {
      return SliverToBoxAdapter(
          child: widget.emptyMessageBuilder ?? const SizedBox());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        _itemBuilder,
        childCount: widget.itemCount +
            (widget.state == WInfiniteListState.idle ? 1 : 0),
      ),
    );
  }
}
