// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of sdk.src.bin;

/// The Dart VM within the SDK.
///
///
class DartVM {
  final String _path;

  /// Creates a reference to the Dart VM using the executable path provided.
  const DartVM(this._path);

  /// Runs a Dart source or snapshot [file].
  ///
  /// Returns a future completing with the result of the running Dart app.
  ///
  /// Options:
  /// * [checked]: Enable running with types and assertions.
  /// * [packages]: Location of a `.packages` file to lookup `package:` imports.
  Future<ProcessResult> run(
    String file, {
    bool checked,
    String packages,
  }) =>
      Process.run(
          _path,
          _buildArgs(
            flags: {'checked': checked, 'packages': packages},
            varArgs: [
              file,
            ],
          ));

  /// Runs a Dart source or snapshot [file] synchronously/blocking.
  ///
  /// Returns the result of the running Dart app.
  ///
  /// Options:
  /// * [checked]: Enable running with types and assertions.
  /// * [packages]: Location of a `.packages` file to lookup `package:` imports.
  ProcessResult runSync(
    String file, {
    bool checked,
    String packages,
  }) =>
      Process.runSync(
          _path,
          _buildArgs(
            flags: {'checked': checked, 'packages': packages},
            varArgs: [
              file,
            ],
          ));

  /// Runs an interactive Dart source or snapshot [file].
  ///
  /// Returns a future completing with a [Process] of the running Dart app.
  ///
  /// Options:
  /// * [checked]: Enable running with types and assertions.
  /// * [packages]: Location of a `.packages` file to lookup `package:` imports.
  Future<Process> start(
    String file, {
    bool checked,
    String packages,
  }) =>
      Process.start(
        _path,
        _buildArgs(
          flags: {
            'checked': checked,
            'packages': packages,
          },
          varArgs: [
            file,
          ],
        ),
      );

  /// Generate a snapshot from a Dart source [file].
  ///
  /// Returns a [File] representing the newly generated snapshot.
  ///
  /// Options:
  /// * [output]: What file to output the snapshot as.
  /// * [precompile]: Whether to build some machine code ahead-of-time to allow
  /// for better startup performance. Still requires the Dart VM in order to run
  /// the output. Significantly increase output size due to generated code.
  /// * [packages]: Location of a `.packages` file to lookup `package:` imports.
  Future<File> snapshot(
    String file, {
    bool precompile: false,
    String output,
    String packages,
  }) async =>
      Process
          .run(
            _path,
            _buildArgs(
              flags: {
                'packages': packages,
                'snapshot': output,
                'snapshot-kind': precompile ? 'app-jit' : 'script',
              },
              varArgs: [
                file,
              ],
            ),
          )
          .then((_) => new File(file));
}
