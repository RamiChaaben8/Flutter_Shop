part of 'default.dart';

class AddFruitVariablesBuilder {
  String id;
  String name;
  double pricePerKg;

  final FirebaseDataConnect _dataConnect;
  AddFruitVariablesBuilder(this._dataConnect, {required this.id, required this.name, required this.pricePerKg});
  Deserializer<AddFruitData> dataDeserializer = (dynamic json) => AddFruitData.fromJson(jsonDecode(json));
  Serializer<AddFruitVariables> varsSerializer = (AddFruitVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddFruitData, AddFruitVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddFruitData, AddFruitVariables> ref() {
    AddFruitVariables vars = AddFruitVariables(id: id, name: name, pricePerKg: pricePerKg);
    return _dataConnect.mutation("AddFruit", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddFruitFruitInsert {
  final String id;
  AddFruitFruitInsert.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFruitFruitInsert otherTyped = other as AddFruitFruitInsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddFruitFruitInsert({required this.id});
}

@immutable
class AddFruitData {
  final AddFruitFruitInsert fruit_insert;
  AddFruitData.fromJson(dynamic json):
  fruit_insert = AddFruitFruitInsert.fromJson(json['fruit_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFruitData otherTyped = other as AddFruitData;
    return fruit_insert == otherTyped.fruit_insert;
  }
  @override
  int get hashCode => fruit_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['fruit_insert'] = fruit_insert.toJson();
    return json;
  }

  AddFruitData({required this.fruit_insert});
}

@immutable
class AddFruitVariables {
  final String id;
  final String name;
  final double pricePerKg;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddFruitVariables.fromJson(Map<String, dynamic> json):
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  pricePerKg = nativeFromJson<double>(json['pricePerKg']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFruitVariables otherTyped = other as AddFruitVariables;
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

  AddFruitVariables({required this.id, required this.name, required this.pricePerKg});
}
