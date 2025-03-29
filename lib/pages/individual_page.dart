import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/individual_extension.dart';
import 'package:who_are_we/pages/family_page.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';
import 'package:who_are_we/widgets/list_tiles/family_list_tile.dart';
import 'package:who_are_we/widgets/list_tiles/individual_list_tile.dart';

class IndividualPage extends StatelessWidget {
  static Route getRoute(IndividualStructure individual) => MaterialPageRoute(
        builder: (_) => IndividualPage._(individual: individual),
      );

  final IndividualStructure individual;

  const IndividualPage._({
    required this.individual,
  });

  @override
  Widget build(BuildContext context) {
    final document = context.document;

    final aliasedIndividuals = document
        .getAll<IndividualStructure>()
        .where((i) => i.aliaList.any((a) => a.valueXref == individual.xref))
        .toList();
    final associatedIndividuals = document
        .getAll<IndividualStructure>()
        .where((i) => i.assoList.any((a) => a.valueXref == individual.xref))
        .toList();
    final associatedFamilies = document
        .getAll<FamilyRecordStructure>()
        .where((f) => f.assoList.any((a) => a.valueXref == individual.xref))
        .toList();
    final husbandFamilies = document
        .getAll<FamilyRecordStructure>()
        .where((f) => f.husb?.valueXref == individual.xref)
        .toList();
    final wifeFamilies = document
        .getAll<FamilyRecordStructure>()
        .where((f) => f.wife?.valueXref == individual.xref)
        .toList();
    final childFamilies = document
        .getAll<FamilyRecordStructure>()
        .where((f) => f.chilList.any((a) => a.valueXref == individual.xref))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(individual.getDisplayName(document)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          if (aliasedIndividuals.isNotEmpty)
            _buildIndiSliverList(aliasedIndividuals, 'Aliased as'),
          if (associatedIndividuals.isNotEmpty)
            _buildIndiSliverList(associatedIndividuals, 'Associated with'),
          if (husbandFamilies.isNotEmpty)
            _buildFamSliverList(husbandFamilies, 'Husband in'),
          if (wifeFamilies.isNotEmpty)
            _buildFamSliverList(wifeFamilies, 'Wife in'),
          if (childFamilies.isNotEmpty)
            _buildFamSliverList(childFamilies, 'Child in'),
          if (associatedFamilies.isNotEmpty)
            _buildFamSliverList(associatedFamilies, 'Associated with'),
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

  SliverList _buildFamSliverList(
    List<FamilyRecordStructure> families,
    String prefix,
  ) {
    return SliverList.builder(
      itemCount: families.length,
      itemBuilder: (context, index) => FamilyListTile(
        families[index],
        prefix: prefix,
        onTap: () => Navigator.of(context).push(
          FamilyPage.getRoute(families[index]),
        ),
      ),
    );
  }
}
