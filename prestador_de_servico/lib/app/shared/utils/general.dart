int hashList(List<dynamic> list) {
  return list.fold(0, (hash, element) => hash ^ element.hashCode);
}