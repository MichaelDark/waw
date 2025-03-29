import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';

class GedcomDocumentScopeData {
  final XFile file;
  final Gedcom7Document document;

  const GedcomDocumentScopeData({
    required this.file,
    required this.document,
  });

  @override
  bool operator ==(covariant GedcomDocumentScopeData other) {
    if (identical(this, other)) return true;

    return other.file == file && other.document == document;
  }

  @override
  int get hashCode => file.hashCode ^ document.hashCode;
}

class GedcomDocumentScope extends InheritedWidget {
  final GedcomDocumentScopeData? scope;
  final ValueChanged<GedcomDocumentScopeData?> updateScope;

  const GedcomDocumentScope({
    super.key,
    required this.scope,
    required this.updateScope,
    required super.child,
  });

  XFile get file => scope!.file;
  Gedcom7Document get document => scope!.document;

  static GedcomDocumentScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GedcomDocumentScope>();
  }

  static GedcomDocumentScope of(BuildContext context) {
    final GedcomDocumentScope? result = maybeOf(context);
    assert(result != null, 'No GedcomDocumentScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GedcomDocumentScope oldWidget) =>
      scope != oldWidget.scope;
}

extension GedcomDocumentScopeExtension on BuildContext {
  XFile get file => GedcomDocumentScope.of(this).file;
  Gedcom7Document get document => GedcomDocumentScope.of(this).document;
}
