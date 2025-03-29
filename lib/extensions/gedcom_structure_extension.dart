import 'package:gedcom_codec/gedcom_codec.dart';
import 'package:gedcom_structures/gedcom_7.dart';

extension GedcomStructureExtension on GedcomStructure {
  DateTime? get valueDateTime {
    final segments = valueText?.split(' ') ?? [];
    if (segments.length != 3) return null;
    final day = int.tryParse(segments[0]);
    final month = switch (segments[1]) {
      'JAN' => DateTime.january,
      'FEB' => DateTime.february,
      'MAR' => DateTime.march,
      'APR' => DateTime.april,
      'MAY' => DateTime.may,
      'JUN' => DateTime.june,
      'JUL' => DateTime.july,
      'AUG' => DateTime.august,
      'SEP' => DateTime.september,
      'OCT' => DateTime.october,
      'NOV' => DateTime.november,
      'DEC' => DateTime.december,
      _ => null,
    };
    final year = int.tryParse(segments[2]);
    if (day != null && month != null && year != null) {
      return DateTime(year, month, day);
    }
    return null;
  }
}
