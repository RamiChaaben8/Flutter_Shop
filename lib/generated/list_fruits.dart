part of 'default.dart';

class ListFruitsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListFruitsVariablesBuilder(this._dataConnect);
  Deserializer<ListFruitsData> dataDeserializer = (dynamic json) => ListFruitsData.fromJson(jsonDecode(json));
  Serializer<ListFruitsVariables> varsSerializer = (ListFruitsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListFruitsData, ListFruitsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListFruitsData, ListFruitsVariables> ref() {
    ListFruitsVariables vars = ListFruitsVariables();
    return _dataConnect.query("ListFruits", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListFruitsFruits {
  final String id;
  final String name;
  final double pricePerKg;
  ListFruitsFruits.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  pricePerKg = nativeFromJson<double>(json['pricePerKg']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ListFruitsFruits otherTyped = other as ListFruitsFruits;
    return id == otherTyped.id &&
    name == otherTyped.name &&
    pricePerKg == otherTyped.pricePerKg;
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, pricePerKg.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['pricePerKg'] = nativeToJson<double>(pricePerKg);
    return json;
  }

  ListFruitsFruits({required this.id, required this.name, required this.pricePerKg});
}

@immutable
class ListFruitsData {
  final List<ListFruitsFruits> fruits;
  ListFruitsData.fromJson(dynamic json):
  fruits = (json['fruits'] as List<dynamic>)
      .map((e) => ListFruitsFruits.fromJson(e))
      .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ListFruitsData otherTyped = other as ListFruitsData;
    return fruits == otherTyped.fruits;
  }
  @override
  int get hashCode => fruits.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['fruits'] = fruits.map((e) => e.toJson()).toList();
    return json;
  }

  ListFruitsData({required this.fruits});
}

@immutable
class ListFruitsVariables {
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListFruitsVariables.fromJson(Map<String, dynamic> json);
  @override
  bool operator ==(Object other) => identical(this, other) || other.runtimeType == runtimeType;
  @override
  int get hashCode => runtimeType.hashCode;

  Map<String, dynamic> toJson() => {};

  ListFruitsVariables();
}
