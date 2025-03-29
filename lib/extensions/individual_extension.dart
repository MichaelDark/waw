import 'package:collection/collection.dart';
import 'package:gedcom_structures/gedcom_7.dart';

extension IndividualStructureExtension on IndividualStructure {
  String getDisplayName(Gedcom7Document document) {
    final name = nameList
        .map((nameStructure) => nameStructure.valueText)
        .firstWhereOrNull((name) => name?.isNotEmpty ?? false)
        ?.replaceAll('/', ' ')
        .replaceAll(RegExp(' +'), ' ');
    final displayName = name ?? 'Unknown Individual ($xref)';
    final birthDate = birtList.firstOrNull?.date?.valueText;
    return birthDate == null ? displayName : '$displayName ($birthDate)';
  }
}
