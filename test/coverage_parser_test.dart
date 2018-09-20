@TestOn('vm')
import 'package:test/test.dart';

import 'package:coverage_clover/src/coverage_parser.dart';
import 'package:coverage_clover/src/clover_report.dart';
import 'package:coverage_clover/src/exceptions.dart';

void main() {
  final parser = CoverageParser();
  final baseHitmap = {'type': 'CodeCoverage', 'coverage': []};

  group('$CoverageParser', () {
    CloverReport report;
    final reportOn = 'testpkg';

    setUp(() {
      report = CloverReport();
    });

    test('should ignore empty hitmaps', () {
      parser.parseHitmap(baseHitmap, reportOn, report);
      expect(report.projectReport.elements, 0);
      expect(report.projectReport.coveredElements, 0);
    });

    test('should count on hits', () {
      parser.parseHitmap(
          {}
            ..addAll(baseHitmap)
            ..addAll({
              'coverage': [
                {
                  'source': 'package:$reportOn/test.dart',
                  'hits': [
                    10,
                    0,
                    12,
                    1,
                  ]
                }
              ]
            }),
          reportOn,
          report);

      expect(report.projectReport.elements, 2);
      expect(report.projectReport.coveredElements, 1);
    });

    test('should throw an exception if it\'s not a valid hitmap', () {
      expect(() => parser.parseHitmap({}, reportOn, report),
          throwsA(TypeMatcher<InvalidHitmapException>()));
    });

    test('should only include sources of reportOn', () {
      parser.parseHitmap(
          {}
            ..addAll(baseHitmap)
            ..addAll({
              'coverage': [
                {
                  'source': 'package:$reportOn/src/test_file.dart',
                  'script': {},
                  'hits': [
                    10,
                    0,
                    12,
                    1,
                  ]
                },
                {
                  'source': 'package:otherpkg/src/test_file.dart',
                  'script': {},
                  'hits': [
                    10,
                    0,
                    12,
                    1,
                  ]
                },
                {
                  'source': 'dart:core/math.dart',
                  'script': {},
                  'hits': [
                    10,
                    0,
                    12,
                    1,
                  ]
                }
              ]
            }),
          reportOn,
          report);

      expect(report.projectReport.elements, 2);
      expect(report.projectReport.coveredElements, 1);
    });
  });
}
