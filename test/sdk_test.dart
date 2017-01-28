// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk/sdk.dart';
import 'package:test/test.dart';

main() {
  final dartSdk = new DartSdk.fromExecutable();
  final dartVM = dartSdk.dartVM;

  test('should throw when the SDK is an invalid location', () {
    expect(
      () => new DartSdk.fromPath(Directory.systemTemp.path),
      throwsArgumentError,
    );
  });

  test('should return the version of the SDK', () {
    expect(dartSdk.version, greaterThan(new Version(1, 0, 0)));
  });

  test('should run a dart file and read the stdout', () async {
    final process = await dartVM.start(p.join(
      'test',
      '_files',
      'stdout.dart',
    ));
    expect(await UTF8.decodeStream(process.stdout), 'Hello World\n');
  });

  test('should take a snapshot and then use it instead', () async {
    final out = p.join(
      Directory.systemTemp.createTempSync().path,
      'stdout.snapshot',
    );
    await dartVM.snapshot(
      p.join(
        'test',
        '_files',
        'stdout.dart',
      ),
      output: out,
    );
    final process = await dartVM.start(out);
    expect(await UTF8.decodeStream(process.stdout), 'Hello World\n');
  });
}
