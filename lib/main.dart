import 'package:flutter/material.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';

import 'pages/file_picker_page.dart';

void main() {
  runApp(const WhoAreWeApp());
}

class WhoAreWeApp extends StatefulWidget {
  const WhoAreWeApp({super.key});

  @override
  State<WhoAreWeApp> createState() => _WhoAreWeAppState();
}

class _WhoAreWeAppState extends State<WhoAreWeApp> {
  GedcomDocumentScopeData? _data;

  void _onUpdateScope(GedcomDocumentScopeData? data) {
    setState(() => _data = data);
  }

  @override
  Widget build(BuildContext context) {
    return GedcomDocumentScope(
      scope: _data,
      updateScope: _onUpdateScope,
      child: MaterialApp(
        title: 'Who Are We',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FilePickerPage(),
      ),
    );
  }
}
