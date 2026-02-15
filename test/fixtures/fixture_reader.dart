import 'dart:io';

/// Reads a fixture file from the test/fixtures directory.
///
/// This helper function simplifies loading JSON fixtures in tests.
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
