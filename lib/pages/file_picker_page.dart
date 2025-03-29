import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:gedcom_codec/gedcom_codec.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/utf_xfile_extension.dart';
import 'package:who_are_we/pages/individual_list_page.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';

class FilePickerPage extends StatelessWidget {
  const FilePickerPage({super.key});

  void _onPickFilePressed(BuildContext context) async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'GEDCOM files',
          extensions: <String>['ged'],
        ),
      ],
    );

    if (file case var file?) {
      final gedcomText = await file.readUtfAsString();

      if (!context.mounted) return;

      final document = GedcomCodec().decode(gedcomText);
      final gedcom7Document = document.toGedcom7Document();

      GedcomDocumentScope.of(context).updateScope(
        GedcomDocumentScopeData(file: file, document: gedcom7Document),
      );

      Navigator.of(context).push(IndividualListPage.getRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who Are We'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _onPickFilePressed(context),
          child: Text('Pick GEDCOM file'),
        ),
      ),
    );
  }
}
