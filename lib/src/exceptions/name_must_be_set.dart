class NameMustBeSetException implements Exception {
  const NameMustBeSetException();

  @override
  String toString() {
    return 'Name must be set';
  }
}
