import 'dart:async';

import 'clover_report.dart';
import 'parse_configuration.dart';

/// Used by implementations which append statistics to a [CloverReport].
abstract class ReportParser {
  /// Parses information provided by the [config] and modifies the [report].
  Future<void> parse(ParseConfiguration config, CloverReport report);
}
