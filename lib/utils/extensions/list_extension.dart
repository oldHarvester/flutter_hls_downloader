extension ListDynamicX<T> on List<T> {
  bool hasItem(int index) {
    return index <= length - 1;
  }

  bool canIterateNext(int currentIndex) {
    return hasItem(currentIndex + 1);
  }

  bool canIteratePrevious(int currentIndex) {
    return hasItem(currentIndex - 1);
  }
}
