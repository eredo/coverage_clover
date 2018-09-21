import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';

import 'clover_report.dart';
import 'parse_configuration.dart';
import 'report_parser.dart';

class CodeStatisticsParser implements ReportParser {
  @override
  Future<void> parse(ParseConfiguration config, CloverReport report) {
    final files = Glob('**.dart');
    final completer = Completer<void>();

    files
        .list()
        .asyncMap((fs) => File(fs.path).readAsString())
        .map((fc) => _count(fc, report))
        .listen(null, onDone: () => completer.complete());

    return completer.future;
  }
}

void _count(String content, CloverReport report) {
  final lines =
      content.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty);

  report.projectReport.files += 1;
  report.projectReport.loc += lines.length;
  report.projectReport.ncloc += lines.where((l) => !l.startsWith('//')).length;
}
