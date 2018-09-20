/// Thrown by the [CoverageParser] if the coverage report json file doesn't
/// contain a proper hitmap schema.
class InvalidHitmapException implements Exception {
  @override
  String toString() =>
      'InvalidHitmapException: The provided hitmap is not following '
      'the dart coverage hitmap structure.';
}
