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
  final durationInsertAnimation = 500;
  final durationRemoveAnimation = 500;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(E item) {
    final index = _items.length;
    _items.insert(index, item);
    _animatedList.insertItem(
      index,
      duration: Duration(milliseconds: durationInsertAnimation),
    );
  }

  void insertAt(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(
      index,
      duration: Duration(milliseconds: durationInsertAnimation),
    );
  }

  E removeAt(int index, [int? durationMiliseconds]) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation),
        duration: Duration(milliseconds: durationMiliseconds ?? durationRemoveAnimation),
      );
    }

    return removedItem;
  }

  void removeAndInsertAll(List<E> items) {
    _items = [];
    _items = List.from(items);
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
