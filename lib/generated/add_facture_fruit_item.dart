part of 'default.dart';

class AddFactureFruitItemVariablesBuilder {
  String factureId;
  String fruitId;
  double weight;

  final FirebaseDataConnect _dataConnect;
  AddFactureFruitItemVariablesBuilder(this._dataConnect, {required this.factureId, required this.fruitId, required this.weight});
  Deserializer<AddFactureFruitItemData> dataDeserializer = (dynamic json) => AddFactureFruitItemData.fromJson(jsonDecode(json));
  Serializer<AddFactureFruitItemVariables> varsSerializer = (AddFactureFruitItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddFactureFruitItemData, AddFactureFruitItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddFactureFruitItemData, AddFactureFruitItemVariables> ref() {
    AddFactureFruitItemVariables vars = AddFactureFruitItemVariables(factureId: factureId, fruitId: fruitId, weight: weight);
    return _dataConnect.mutation("AddFactureFruitItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddFactureFruitItemFactureFruitItemInsert {
  final String id;
  AddFactureFruitItemFactureFruitItemInsert.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureFruitItemFactureFruitItemInsert otherTyped = other as AddFactureFruitItemFactureFruitItemInsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddFactureFruitItemFactureFruitItemInsert({required this.id});
}

@immutable
class AddFactureFruitItemData {
  final AddFactureFruitItemFactureFruitItemInsert factureFruitItem_insert;
  AddFactureFruitItemData.fromJson(dynamic json):
  factureFruitItem_insert = AddFactureFruitItemFactureFruitItemInsert.fromJson(json['factureFruitItem_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureFruitItemData otherTyped = other as AddFactureFruitItemData;
    return factureFruitItem_insert == otherTyped.factureFruitItem_insert;
  }
  @override
  int get hashCode => factureFruitItem_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureFruitItem_insert'] = factureFruitItem_insert.toJson();
    return json;
  }

  AddFactureFruitItemData({required this.factureFruitItem_insert});
}

@immutable
class AddFactureFruitItemVariables {
  final String factureId;
  final String fruitId;
  final double weight;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddFactureFruitItemVariables.fromJson(Map<String, dynamic> json):
  factureId = nativeFromJson<String>(json['factureId']),
  fruitId = nativeFromJson<String>(json['fruitId']),
  weight = nativeFromJson<double>(json['weight']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureFruitItemVariables otherTyped = other as AddFactureFruitItemVariables;
    return factureId == otherTyped.factureId &&
    fruitId == otherTyped.fruitId &&
    weight == otherTyped.weight;
  }
  @override
  int get hashCode => Object.hashAll([factureId.hashCode, fruitId.hashCode, weight.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureId'] = nativeToJson<String>(factureId);
    json['fruitId'] = nativeToJson<String>(fruitId);
    json['weight'] = nativeToJson<double>(weight);
    return json;
  }

  AddFactureFruitItemVariables({required this.factureId, required this.fruitId, required this.weight});
}
