import 'dart:convert';

/// Type aliases
typedef Json = Map<String, dynamic>;
typedef JsonList = List<Json>;

/// Decode JSON string ke Map<String, dynamic>
/// Return null jika parsing gagal atau bukan object
Json? posJsonDecode(String source) {
  try {
    final result = jsonDecode(source);
    if (result is Json) return result;
    return null;
  } catch (_) {
    return null;
  }
}

/// Decode JSON string yang berupa array
/// Return List<Map<String, dynamic>>, kosong jika invalid
JsonList posJsonDecodeArray(String source) {
  try {
    final result = jsonDecode(source);
    if (result is List) {
      return result.whereType<Json>().toList();
    }
    return [];
  } catch (_) {
    return [];
  }
}

/// Decode list of JSON strings (each string = object)
JsonList posJsonDecodeList(List<String> sources) {
  return sources.map((s) => posJsonDecode(s)).where((e) => e != null).cast<Json>().toList();
}

/// Encode Map<String, dynamic> ke JSON string
String posJsonEncode(Json json) => jsonEncode(json);

/// Encode list of Map<String, dynamic> ke JSON string list
List<String> posJsonEncodeList(JsonList list) => list.map(posJsonEncode).toList();

/// Nested safe decode
/// Bisa dipakai untuk key tertentu di object JSON
T? posJsonSafeGet<T>(Json json, String key) {
  if (json.containsKey(key) && json[key] is T) return json[key] as T;
  return null;
}
