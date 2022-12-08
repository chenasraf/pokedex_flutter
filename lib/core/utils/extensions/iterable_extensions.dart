extension IterableFirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    return _firstWhereOrNull<T>(this, test);
  }
}

extension ListFirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    return _firstWhereOrNull<T>(this, test);
  }
}

T? _firstWhereOrNull<T>(Iterable<T> self, bool Function(T element) test) {
  for (final element in self) {
    if (test(element)) {
      return element;
    }
  }
  return null;
}
