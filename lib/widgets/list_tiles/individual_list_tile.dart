import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/individual_extension.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';

class IndividualListTile extends StatelessWidget {
  final IndividualStructure individual;
  final String? prefix;
  final VoidCallback? onTap;

  const IndividualListTile(
    this.individual, {
    super.key,
    this.prefix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final document = context.document;

    return ListTile(
      leading: Icon(Icons.person),
      title: prefix == null
          ? Text(individual.getDisplayName(document))
          : Text('$prefix ${individual.getDisplayName(document)}'),
      onTap: onTap,
    );
  }
}
