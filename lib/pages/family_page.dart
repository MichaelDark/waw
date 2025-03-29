import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/family_record_extension.dart';
import 'package:who_are_we/pages/individual_page.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';
import 'package:who_are_we/widgets/list_tiles/individual_list_tile.dart';

class FamilyPage extends StatelessWidget {
  static Route getRoute(FamilyRecordStructure family) => MaterialPageRoute(
        builder: (_) => FamilyPage._(family: family),
      );

  final FamilyRecordStructure family;

  const FamilyPage._({
    required this.family,
  });

  @override
  Widget build(BuildContext context) {
    final document = context.document;

    final husbands = document
        .getAll<IndividualStructure>()
        .where((i) => i.xref == family.husb?.valueXref)
        .toList();
    final wifes = document
        .getAll<IndividualStructure>()
        .where((i) => i.xref == family.wife?.valueXref)
        .toList();
    final childrenXrefs = family.chilList.map((chil) => chil.valueXref);
    final children = document
        .getAll<IndividualStructure>()
        .where((i) => childrenXrefs.contains(i.xref))
        .toList();
    final associatedXrefs = family.assoList.map((asso) => asso.valueXref);
    final associatedIndividuals = document
        .getAll<IndividualStructure>()
        .where((i) => associatedXrefs.contains(i.xref))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(family.getDisplayName(document)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          if (husbands.isNotEmpty) _buildIndiSliverList(husbands, 'Husband'),
          if (wifes.isNotEmpty) _buildIndiSliverList(wifes, 'Wife'),
          if (children.isNotEmpty) _buildIndiSliverList(children, 'Child'),
          if (associatedIndividuals.isNotEmpty)
            _buildIndiSliverList(associatedIndividuals, 'Associated with'),
        ],
      ),
    );
  }

  SliverList _buildIndiSliverList(
    List<IndividualStructure> individuals,
    String prefix,
  ) {
    return SliverList.builder(
      itemCount: individuals.length,
      itemBuilder: (context, index) => IndividualListTile(
        individuals[index],
        prefix: prefix,
        onTap: () => Navigator.of(context).push(
          IndividualPage.getRoute(individuals[index]),
        ),
      ),
    );
  }
}
