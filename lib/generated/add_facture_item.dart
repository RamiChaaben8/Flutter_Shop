part of 'default.dart';

class AddFactureItemVariablesBuilder {
  String factureId;
  String productId;
  double quantity;

  final FirebaseDataConnect _dataConnect;
  AddFactureItemVariablesBuilder(this._dataConnect, {required this.factureId, required this.productId, required this.quantity});
  Deserializer<AddFactureItemData> dataDeserializer = (dynamic json) => AddFactureItemData.fromJson(jsonDecode(json));
  Serializer<AddFactureItemVariables> varsSerializer = (AddFactureItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddFactureItemData, AddFactureItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddFactureItemData, AddFactureItemVariables> ref() {
    AddFactureItemVariables vars = AddFactureItemVariables(factureId: factureId, productId: productId, quantity: quantity);
    return _dataConnect.mutation("AddFactureItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddFactureItemFactureItemInsert {
  final String id;
  AddFactureItemFactureItemInsert.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureItemFactureItemInsert otherTyped = other as AddFactureItemFactureItemInsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddFactureItemFactureItemInsert({required this.id});
}

@immutable
class AddFactureItemData {
  final AddFactureItemFactureItemInsert factureItem_insert;
  AddFactureItemData.fromJson(dynamic json):
  factureItem_insert = AddFactureItemFactureItemInsert.fromJson(json['factureItem_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureItemData otherTyped = other as AddFactureItemData;
    return factureItem_insert == otherTyped.factureItem_insert;
  }
  @override
  int get hashCode => factureItem_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureItem_insert'] = factureItem_insert.toJson();
    return json;
  }

  AddFactureItemData({required this.factureItem_insert});
}

@immutable
class AddFactureItemVariables {
  final String factureId;
  final String productId;
  final double quantity;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddFactureItemVariables.fromJson(Map<String, dynamic> json):
  factureId = nativeFromJson<String>(json['factureId']),
  productId = nativeFromJson<String>(json['productId']),
  quantity = nativeFromJson<double>(json['quantity']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final AddFactureItemVariables otherTyped = other as AddFactureItemVariables;
    return factureId == otherTyped.factureId &&
    productId == otherTyped.productId &&
    quantity == otherTyped.quantity;
  }
  @override
  int get hashCode => Object.hashAll([factureId.hashCode, productId.hashCode, quantity.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureId'] = nativeToJson<String>(factureId);
    json['productId'] = nativeToJson<String>(productId);
    json['quantity'] = nativeToJson<double>(quantity);
    return json;
  }

  AddFactureItemVariables({required this.factureId, required this.productId, required this.quantity});
}
