// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library sdk.src.bin;

import 'dart:async';
import 'dart:io';

part 'bin/dart.dart';

List<String> _buildArgs({
  Iterable<String> varArgs: const [],
  Map<String, Object> flags: const {},
}) {
  final args = <String>[];
  flags.forEach((key, value) {
    if (value == true) {
      args.add('--$key');
    } else if (value == false) {
      args.add('--no-$key');
    } else if (value != null) {
      args.add('--$key=$value');
    }
  });
  return args..addAll(varArgs);
}
