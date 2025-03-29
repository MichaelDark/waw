import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:cross_file/cross_file.dart' as cross_file;
import 'package:utf_ext/utf_ext.dart' as utf_ext;

/// [utf_ext.UtfFile], but on [cross_file.XFile]
extension UtfXFile on cross_file.XFile {
  bool get isPosixFileSystem => io.Platform.pathSeparator == '/';

  Stream<String> openUtfRead({
    utf_ext.UtfBomHandler? onBom,
    bool asLines = false,
  }) {
    final source = openRead();
    final stream = utf_ext.UtfDecoder(path, onBom: onBom).bind(source);

    return (asLines ? stream.transform(convert.LineSplitter()) : stream);
  }

  Future<int> _readUtfAsString({
    dynamic extra,
    utf_ext.UtfBomHandler? onBom,
    utf_ext.UtfIoHandler? onRead,
    utf_ext.UtfIoHandlerSync? onReadSync,
    StringBuffer? pileup,
    bool? withPosixLineBreaks = true,
  }) async {
    return await openUtfRead(onBom: onBom).readUtfAsString(
      extra: extra,
      onRead: onRead,
      onReadSync: onReadSync,
      pileup: pileup,
      withPosixLineBreaks: withPosixLineBreaks ?? isPosixFileSystem,
    );
  }

  Future<String> readUtfAsString() async {
    final buffer = StringBuffer();

    await _readUtfAsString(pileup: buffer);

    return buffer.toString();
  }
}
