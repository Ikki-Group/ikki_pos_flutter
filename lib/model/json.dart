import 'dart:convert';

typedef Json = Map<String, dynamic>;
typedef JsonList = List<Json>;
typedef JsonListDynamic = List<dynamic>;

Json posJsonDecode(String source) => jsonDecode(source) as Json;
List<Json> posJsonDecodeList(List<String> sources) => sources.map(posJsonDecode).toList();
