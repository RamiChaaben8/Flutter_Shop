part of 'default.dart';

class GetFruitByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetFruitByIdVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetFruitByIdData> dataDeserializer = (dynamic json) => GetFruitByIdData.fromJson(jsonDecode(json));
  Serializer<GetFruitByIdVariables> varsSerializer = (GetFruitByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetFruitByIdData, GetFruitByIdVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetFruitByIdData, GetFruitByIdVariables> ref() {
    GetFruitByIdVariables vars = GetFruitByIdVariables(id: id);
    return _dataConnect.query("GetFruitById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetFruitByIdFruit {
  final String id;
  final String name;
  final double pricePerKg;
  GetFruitByIdFruit.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  pricePerKg = nativeFromJson<double>(json['pricePerKg']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFruitByIdFruit otherTyped = other as GetFruitByIdFruit;
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

  GetFruitByIdFruit({required this.id, required this.name, required this.pricePerKg});
}

@immutable
class GetFruitByIdData {
  final GetFruitByIdFruit? fruit;
  GetFruitByIdData.fromJson(dynamic json):
  fruit = json['fruit'] == null ? null : GetFruitByIdFruit.fromJson(json['fruit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFruitByIdData otherTyped = other as GetFruitByIdData;
    return fruit == otherTyped.fruit;
  }
  @override
  int get hashCode => fruit.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (fruit != null) {
      json['fruit'] = fruit!.toJson();
    }
    return json;
  }

  GetFruitByIdData({this.fruit});
}

@immutable
class GetFruitByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetFruitByIdVariables.fromJson(Map<String, dynamic> json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFruitByIdVariables otherTyped = other as GetFruitByIdVariables;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetFruitByIdVariables({required this.id});
}
