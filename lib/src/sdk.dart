// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk/src/bin.dart';

/// Represents a build of the Dart SDK.
class DartSdk {
  final String _path;

  /// Create a new [DartSdk] from the currently executing Dart VM.
  factory DartSdk.fromExecutable() {
    return new DartSdk.fromPath(
      p.normalize(p.join(Platform.resolvedExecutable, '..', '..')),
    );
  }

  /// Create a new [DartSdk] at the passed in path.
  ///
  /// Throws an [ArgumentError] if this is not a valid SDK location.
  DartSdk.fromPath(this._path) {
    try {
      version;
    } on IOException catch (_) {
      throw new ArgumentError('No SDK found at $_path.');
    }
  }

  /// Dart virtual machine executable.
  DartVM get dartVM => new DartVM(p.join(_path, 'bin', 'dart'));

  /// Specific commit/revision of the SDK.
  String get revision {
    return new File(p.join(_path, 'revision')).readAsLinesSync().first;
  }

  /// Version of the SDK.
  Version get version {
    final result = new File(p.join(_path, 'version')).readAsLinesSync().first;
    return new Version.parse(result);
  }

  @override
  String toString() => '$DartSdk {$version}';
}
