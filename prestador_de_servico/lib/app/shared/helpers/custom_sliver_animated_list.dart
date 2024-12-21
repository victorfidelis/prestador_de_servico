import 'package:flutter/material.dart';

class CustomSliverAnimatedList<E> {
  CustomSliverAnimatedList({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final Function(E item, BuildContext context, Animation<double> animation) removedItemBuilder;
  List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(E item) {
    final index = _items.length;
    _items.insert(index, item);
    _animatedList.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  void insertAt(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation),
        duration: const Duration(milliseconds: 500),
      );
    }

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _items.removeAt(index); 
    // });

    return removedItem;
  }

  void removeAndInsertAll(List<E> items) {
    _items = [];
    _items = items;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
