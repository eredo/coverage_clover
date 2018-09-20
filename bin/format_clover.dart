import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:coverage_clover/commands.dart';

FutureOr<ExitCode> main(List<String> args) => (CommandRunner<ExitCode>(
        'format_clover', 'Tool to convert dart coverage reports into clover.')
      ..addCommand(FormatCommand()))
    .run(args);
