import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';

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

    final report = CloverReport();

    await Future.wait(_parser.map((r) => r.parse(config, report)));

    return ExitCode.success;
  }
}

Future<String> _fetchReportOn() async {
  return '';
}
