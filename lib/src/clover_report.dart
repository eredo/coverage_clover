import 'package:xml/xml.dart';

class CloverReport {
  ProjectReport projectReport = ProjectReport();

  String build(int timestamp) {
    final builder = XmlBuilder()..processing('xml', 'version="1.0"');

    builder.element('coverage', attributes: {
      'clover': 'dart_clover',
    }, nest: () {
      builder.attribute('generated', timestamp);
      projectReport.build(builder, timestamp);
    });

    return builder.build().toString();
  }
}

class ProjectReport extends ProjectMetrics {
  String name;

  void build(XmlBuilder builder, int timestamp) {
    builder.element('project', nest: () {
      builder.attribute('name', name);
      builder.attribute('timestamp', timestamp);

      builder.element('metrics', nest: () {
        super.build(builder, timestamp);
      });
    });
  }
}

abstract class ProjectMetrics extends PackageMetrics {
  int packages = 0;

  void build(XmlBuilder builder, int timestamp) {
    super.build(builder, timestamp);
    builder.attribute('packages', packages);
  }
}

abstract class PackageMetrics extends FileMetrics {
  int files = 0;

  void build(XmlBuilder builder, int timestamp) {
    super.build(builder, timestamp);
    builder.attribute('files', files);
  }
}

abstract class FileMetrics extends ClassMetrics {
  int classes = 0;

  /// Lines of code including comments.
  int loc = 0;

  /// The total number of non-comment lines of code.
  int ncloc = 0;

  void build(XmlBuilder builder, int timestamp) {
    super.build(builder, timestamp);
    builder.attribute('classes', classes);
    builder.attribute('loc', loc);
    builder.attribute('ncloc', ncloc);
  }
}

abstract class ClassMetrics {
  int complexity = 0;
  int elements = 0;
  int coveredElements = 0;
  int conditionals = 0;
  int coveredConditionals = 0;
  int statements = 0;
  int coveredStatements = 0;
  int coveredMethods = 0;
  int methods = 0;

  double testDuration = 0.0;
  int testFailures = 0;
  int testPasses = 0;
  int testRuns = 0;

  void build(XmlBuilder builder, int timestamp) {
    builder.attribute('complexity', complexity);
    builder.attribute('conditionals', conditionals);
    builder.attribute('coveredconditionals', coveredConditionals);
    builder.attribute('coveredelements', coveredElements);
    builder.attribute('coveredmethods', coveredMethods);
    builder.attribute('coveredstatements', coveredStatements);
    builder.attribute('elements', elements);
    builder.attribute('methods', methods);
    builder.attribute('statements', statements);
    builder.attribute('testduration', testDuration);
    builder.attribute('testfailures', testFailures);
    builder.attribute('testpasses', testPasses);
    builder.attribute('testruns', testRuns);
  }
}
