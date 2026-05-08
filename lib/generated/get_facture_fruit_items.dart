part of 'default.dart';

class GetFactureFruitItemsVariablesBuilder {
  String factureId;

  final FirebaseDataConnect _dataConnect;
  GetFactureFruitItemsVariablesBuilder(this._dataConnect, {required this.factureId});
  Deserializer<GetFactureFruitItemsData> dataDeserializer = (dynamic json) => GetFactureFruitItemsData.fromJson(jsonDecode(json));
  Serializer<GetFactureFruitItemsVariables> varsSerializer = (GetFactureFruitItemsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetFactureFruitItemsData, GetFactureFruitItemsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetFactureFruitItemsData, GetFactureFruitItemsVariables> ref() {
    GetFactureFruitItemsVariables vars = GetFactureFruitItemsVariables(factureId: factureId);
    return _dataConnect.query("GetFactureFruitItems", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetFactureFruitItemsFactureFruitItemsFruit {
  final String id;
  final String name;
  final double pricePerKg;
  GetFactureFruitItemsFactureFruitItemsFruit.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  pricePerKg = nativeFromJson<double>(json['pricePerKg']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFactureFruitItemsFactureFruitItemsFruit otherTyped = other as GetFactureFruitItemsFactureFruitItemsFruit;
    return id == otherTyped.id && name == otherTyped.name && pricePerKg == otherTyped.pricePerKg;
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

  GetFactureFruitItemsFactureFruitItemsFruit({required this.id, required this.name, required this.pricePerKg});
}

@immutable
class GetFactureFruitItemsFactureFruitItems {
  final String id;
  final double weight;
  final GetFactureFruitItemsFactureFruitItemsFruit fruit;
  GetFactureFruitItemsFactureFruitItems.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']),
  weight = nativeFromJson<double>(json['weight']),
  fruit = GetFactureFruitItemsFactureFruitItemsFruit.fromJson(json['fruit']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFactureFruitItemsFactureFruitItems otherTyped = other as GetFactureFruitItemsFactureFruitItems;
    return id == otherTyped.id && weight == otherTyped.weight && fruit == otherTyped.fruit;
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, weight.hashCode, fruit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['weight'] = nativeToJson<double>(weight);
    json['fruit'] = fruit.toJson();
    return json;
  }

  GetFactureFruitItemsFactureFruitItems({required this.id, required this.weight, required this.fruit});
}

@immutable
class GetFactureFruitItemsData {
  final List<GetFactureFruitItemsFactureFruitItems> factureFruitItems;
  GetFactureFruitItemsData.fromJson(dynamic json):
  factureFruitItems = (json['factureFruitItems'] as List<dynamic>)
      .map((e) => GetFactureFruitItemsFactureFruitItems.fromJson(e))
      .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFactureFruitItemsData otherTyped = other as GetFactureFruitItemsData;
    return factureFruitItems == otherTyped.factureFruitItems;
  }
  @override
  int get hashCode => factureFruitItems.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureFruitItems'] = factureFruitItems.map((e) => e.toJson()).toList();
    return json;
  }

  GetFactureFruitItemsData({required this.factureFruitItems});
}

@immutable
class GetFactureFruitItemsVariables {
  final String factureId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetFactureFruitItemsVariables.fromJson(Map<String, dynamic> json):
  factureId = nativeFromJson<String>(json['factureId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetFactureFruitItemsVariables otherTyped = other as GetFactureFruitItemsVariables;
    return factureId == otherTyped.factureId;
  }
  @override
  int get hashCode => factureId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureId'] = nativeToJson<String>(factureId);
    return json;
  }

  GetFactureFruitItemsVariables({required this.factureId});
}
