# coverage_clover
[![Pub Version](https://img.shields.io/pub/v/coverage_clover.svg)](https://pub.dartlang.org/packages/coverage_clover)
[![Build Status](https://travis-ci.org/eredo/coverage_clover.svg?branch=master)](https://travis-ci.org/eredo/coverage_clover)
[![Coverage Status](https://coveralls.io/repos/github/eredo/coverage_clover/badge.svg)](https://coveralls.io/github/eredo/coverage_clover)

A tool to convert dart coverage and test report output into [clover](https://openclover.org/) format.
This currently only contains the overall elements and covered elements (statements, conditionals and methods) based
on the coverage hitmap, so it's only providing a coverage percentage.

Further statistics are planned.

## Usage

In order to run the formatter, the coverage hitmap json and the test runner json report is required. For details
on how to receive these reports see: [coverage](https://github.com/dart-lang/coverage) and [test](https://github.com/dart-lang/test)
documentation.

```
pub run coverage_clover format -c coverage.json -t test.json -o clover.xml
```
