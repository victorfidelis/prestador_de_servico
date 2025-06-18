import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';


class AnimatedHorizontalList<T> extends StatefulWidget {
  final List<T> initialItems;
  final Widget Function(BuildContext context, T item, int index, Animation<double> animation) itemBuilder;
  final Widget Function(T item, BuildContext context, Animation<double> animation) removedItemBuilder;
  final ScrollController scrollController;
  final double listHeight;
  final double firstItemPadding;
  final double lastItemPadding;

  /// Um callback que é chamado quando o [AnimatedListHelper] está pronto,
  /// fornecendo a instância do helper ao widget pai.
  final ValueChanged<AnimatedListHelper<T>> onListHelperReady;

  const AnimatedHorizontalList({
    super.key,
    required this.initialItems,
    required this.itemBuilder,
    required this.removedItemBuilder,
    required this.scrollController,
    this.listHeight = 190, 
    this.firstItemPadding = 16, 
    this.lastItemPadding = 190, 
    required this.onListHelperReady,
  });

  @override
  State<AnimatedHorizontalList<T>> createState() => _AnimatedHorizontalListState<T>();
}

class _AnimatedHorizontalListState<T> extends State<AnimatedHorizontalList<T>> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late AnimatedListHelper<T> _listHelper;

  @override
  void initState() {
    super.initState();
    _listHelper = AnimatedListHelper<T>(
      listKey: _animatedListKey,
      removedItemBuilder: widget.removedItemBuilder,
      initialItems: widget.initialItems,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onListHelperReady(_listHelper);
    });
  }

  Widget _internalItemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (index == 0) {
      return SizedBox(
        key: const ValueKey('generic_first_space'),
        width: widget.firstItemPadding,
      );
    }
    if (index == _listHelper.length + 1) {
      return SizedBox(
        key: const ValueKey('generic_last_space'),
        width: widget.lastItemPadding,
      );
    }
    return widget.itemBuilder(
      context,
      _listHelper[index - 1], 
      index - 1, 
      animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.listHeight,
      child: AnimatedList(
        key: _animatedListKey,
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        initialItemCount: _listHelper.length + 2,
        itemBuilder: _internalItemBuilder,
      ),
    );
  }
}
