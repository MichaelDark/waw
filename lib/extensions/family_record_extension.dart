import 'package:collection/collection.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/individual_extension.dart';

extension FamilyRecordStructureExtension on FamilyRecordStructure {
  String getDisplayName(Gedcom7Document document) {
    IndividualStructure? husbandIndi;
    IndividualStructure? wifeIndi;

    if (husb?.valueXref case var husbXref) {
      husbandIndi = document
          .getAll<IndividualStructure>()
          .firstWhereOrNull((indi) => indi.xref == husbXref);
    }

    if (wife?.valueXref case var wifeXref) {
      wifeIndi = document
          .getAll<IndividualStructure>()
          .firstWhereOrNull((indi) => indi.xref == wifeXref);
    }

    final parents = [husbandIndi, wifeIndi].nonNulls;
    if (parents.isNotEmpty) {
      final parentNames = parents.map((indi) => indi.getDisplayName(document));
      return 'Family of ${parentNames.join(' and ')}';
    } else if (xref case var xref?) {
      return 'Family $xref';
    } else {
      return 'Unidentified Family';
    }
  }
}
