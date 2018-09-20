import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import 'clover_report.dart';
import 'exceptions.dart';
import 'parse_configuration.dart';
import 'report_parser.dart';

/// Parses the coverage json result and returns the values required for the
/// clover report.
class CoverageParser implements ReportParser {
  /// Parses the [file] and adds the proper values to the [report].
  Future<void> parse(ParseConfiguration config, CloverReport report) async {
    final fs = await File(config.coverageReportPath).readAsString();
    final hitmap = json.decode(fs);
    parseHitmap(hitmap, config.reportOn, report);
  }

  @visibleForTesting
  void parseHitmap(Map hitmap, String reportOn, CloverReport report) {
    int elementsCount = 0;
    int elementsCoveredCount = 0;

    if (hitmap['coverage'] is! List || hitmap['type'] != 'CodeCoverage') {
      throw InvalidHitmapException();
    }

    for (var cov in hitmap['coverage']) {
      if (cov['source'] is! String || cov['source'].isEmpty) {
        throw InvalidHitmapException();
      }

      if (_parsePackageName(cov['source']) != reportOn) {
        continue;
      }

      for (var i = 1; i < cov['hits'].length; i += 2) {
        elementsCount++;
        if (cov['hits'][i] > 0) {
          elementsCoveredCount++;
        }
      }
    }

    report.projectReport.elements = elementsCount;
    report.projectReport.coveredElements = elementsCoveredCount;
  }
}

String _parsePackageName(String filePath) {
  Uri uri = Uri.parse(filePath);
  // Skip dart: core libraries and file references (used for tests).
  if (uri.scheme != 'package') {
    return null;
  }

  final firstSlash = uri.path.indexOf('/');
  if (firstSlash == -1) {
    throw new ArgumentError.value(filePath, 'packageUri',
        'Package URIs must start with the package name followed by a "/"');
  }

  return uri.path.substring(0, firstSlash);
}
