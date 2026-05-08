part of 'default.dart';

class UpsertFruitVariablesBuilder {
  String id;
  String name;
  double pricePerKg;

  final FirebaseDataConnect _dataConnect;
  UpsertFruitVariablesBuilder(this._dataConnect, {required this.id, required this.name, required this.pricePerKg});
  Deserializer<UpsertFruitData> dataDeserializer = (dynamic json) => UpsertFruitData.fromJson(jsonDecode(json));
  Serializer<UpsertFruitVariables> varsSerializer = (UpsertFruitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertFruitData, UpsertFruitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertFruitData, UpsertFruitVariables> ref() {
    UpsertFruitVariables vars = UpsertFruitVariables(id: id, name: name, pricePerKg: pricePerKg);
    return _dataConnect.mutation("UpsertFruit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertFruitFruitUpsert {
  final String id;
  UpsertFruitFruitUpsert.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertFruitFruitUpsert otherTyped = other as UpsertFruitFruitUpsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertFruitFruitUpsert({required this.id});
}

@immutable
class UpsertFruitData {
  final UpsertFruitFruitUpsert fruit_upsert;
  UpsertFruitData.fromJson(dynamic json):
  fruit_upsert = UpsertFruitFruitUpsert.fromJson(json['fruit_upsert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertFruitData otherTyped = other as UpsertFruitData;
    return fruit_upsert == otherTyped.fruit_upsert;
  }
  @override
  int get hashCode => fruit_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['fruit_upsert'] = fruit_upsert.toJson();
    return json;
  }

  UpsertFruitData({required this.fruit_upsert});
}

@immutable
class UpsertFruitVariables {
  final String id;
  final String name;
  final double pricePerKg;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertFruitVariables.fromJson(Map<String, dynamic> json):
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  pricePerKg = nativeFromJson<double>(json['pricePerKg']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertFruitVariables otherTyped = other as UpsertFruitVariables;
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

  UpsertFruitVariables({required this.id, required this.name, required this.pricePerKg});
}
