@TestOn('vm')
import 'package:test/test.dart';

import 'package:coverage_clover/src/clover_report.dart';

void main() {
  group('$CloverReport', () {
    test('should transform a report to proper xml structure', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      expect(
          (CloverReport()
                ..projectReport.name = 'testproject'
                ..projectReport.coveredElements = 2
                ..projectReport.elements = 2)
              .build(now),
          '<?xml version="1.0"?>'
          '<coverage clover="dart_clover" generated="$now">'
          '<project name="testproject" timestamp="$now">'
          '<metrics complexity="0" conditionals="0" coveredconditionals="0" '
          'coveredelements="2" coveredmethods="0" coveredstatements="0" '
          'elements="2" methods="0" statements="0" testduration="0.0" '
          'testfailures="0" testpasses="0" testruns="0" classes="0" '
          'loc="0" ncloc="0" files="0" packages="0" />'
          '</project>'
          '</coverage>');
    });
  });
}
