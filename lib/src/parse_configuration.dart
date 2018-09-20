class ParseConfiguration {
  /// Package to look for when parsing the results.
  final String reportOn;

  /// Path of the coverage json report file.
  final String coverageReportPath;

  /// Path of the test runner json report file.
  final String testReportPath;

  /// Path to the package which coverage/test results is being formatted.
  final String packagePath;

  ParseConfiguration(
    this.reportOn,
    this.coverageReportPath,
    this.testReportPath,
    this.packagePath,
  );
}
