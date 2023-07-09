import 'package:strings/strings.dart' as strings;

extension StringCapitalization on String {
  String capitalize() {
    return splitMapJoin(
      RegExp(r'[ -]'),
      onMatch: (m) => strings.capitalize(m.input.substring(m.start, m.end)),
      onNonMatch: (n) => strings.capitalize(n),
    );
  }
}
