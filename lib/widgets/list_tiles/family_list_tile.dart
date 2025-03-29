import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/family_record_extension.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';

class FamilyListTile extends StatelessWidget {
  final FamilyRecordStructure family;
  final String? prefix;
  final VoidCallback? onTap;

  const FamilyListTile(
    this.family, {
    super.key,
    this.prefix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final document = context.document;

    return ListTile(
      leading: Icon(Icons.family_restroom),
      title: prefix == null
          ? Text(family.getDisplayName(document))
          : Text('$prefix ${family.getDisplayName(document)}'),
      onTap: onTap,
    );
  }
}
