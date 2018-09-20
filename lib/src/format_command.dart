import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';

import 'clover_report.dart';
import 'parse_configuration.dart';
import 'report_parser.dart';
import 'coverage_parser.dart';

class FormatCommand extends Command<ExitCode> {
  @override
  final String description =
      'Formats the coverage and test report json files into a clover report.';

  @override
  final String name = 'format';

  final List<ReportParser> _parser = [
    CoverageParser(),
  ];

  FormatCommand() {
    argParser
      ..addOption('coverage',
          abbr: 'c', valueHelp: 'The coverage report json file.')
      ..addOption('test',
          abbr: 't', valueHelp: 'Path to the test report json file.')
      ..addOption('output',
          abbr: 'o', valueHelp: 'The output clover xml file.');
  }

  @override
  FutureOr<ExitCode> run() async {
    final config = ParseConfiguration(
      await _fetchReportOn(),
      argResults['coverage'],
      argResults['test'],
      Directory.current.path,
    );

    final report = CloverReport()..projectReport.name = config.reportOn;

    await Future.wait(_parser.map((r) => r.parse(config, report)));

    final output = report.build(DateTime.now().millisecondsSinceEpoch);
    if ((argResults['output'] as String)?.isNotEmpty ?? false) {
      await File(argResults['output'] as String).writeAsString(output);
    } else {
      stdout.write(output);
    }

    return ExitCode.success;
  }
}

Future<String> _fetchReportOn() async {
  final pubspec = File(p.join(Directory.current.path, 'pubspec.yaml'));
  if (!await pubspec.exists()) {
    // TODO: Proper exception.
    throw 'Unable to detect pubspec.yaml. Make sure to run format within a package';
  }

  final pb = Pubspec.parse(await pubspec.readAsString());
  return pb.name;
}
