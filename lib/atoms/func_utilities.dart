import 'package:lapis_satu/atoms/enum_var.dart';
import 'package:lapis_satu/atoms/const_var.dart';

String? getNameSC({required int subCatIdx, required Category category}) {
  try {
    List<String> subCatFiltered = AppVar.subCategory[category]!;
    String nameSC = subCatFiltered[subCatIdx];

    return nameSC;
  } catch (e) {
    print(e);
    return null;
  }
}

Category id2Cat({required int catIdx}) {
  Category cat = Category.values.elementAt(catIdx);
  return cat;
}

void sortListMaps({
  required List<Map<String, dynamic>> data,
  required String colName,
  required bool ascending,
}) {
  data.sort((a, b) {
    final valA = a[colName];
    final valB = b[colName];

    final int comparison = _compareDynamic(valA, valB);
    return ascending ? comparison : -comparison;
  });
}

int _compareDynamic(dynamic valA, dynamic valB) {
  if (valA == null && valB == null) return 0;
  if (valA == null) return 1;
  if (valB == null) return -1;

  if (valA is Comparable) {
    try {
      return valA.compareTo(valB);
    } catch (e) {
      print(e);
    }
  }
  return valA.toString().compareTo(valB.toString());
}
