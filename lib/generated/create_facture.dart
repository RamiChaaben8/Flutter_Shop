part of 'default.dart';

class CreateFactureVariablesBuilder {
  double totalPrice;
  String userId;

  final FirebaseDataConnect _dataConnect;
  CreateFactureVariablesBuilder(this._dataConnect, {required this.totalPrice, required this.userId});
  Deserializer<CreateFactureData> dataDeserializer = (dynamic json) => CreateFactureData.fromJson(jsonDecode(json));
  Serializer<CreateFactureVariables> varsSerializer = (CreateFactureVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateFactureData, CreateFactureVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateFactureData, CreateFactureVariables> ref() {
    CreateFactureVariables vars = CreateFactureVariables(totalPrice: totalPrice, userId: userId);
    return _dataConnect.mutation("CreateFacture", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateFactureFactureInsert {
  final String id;
  CreateFactureFactureInsert.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CreateFactureFactureInsert otherTyped = other as CreateFactureFactureInsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFactureFactureInsert({required this.id});
}

@immutable
class CreateFactureData {
  final CreateFactureFactureInsert facture_insert;
  CreateFactureData.fromJson(dynamic json):
  facture_insert = CreateFactureFactureInsert.fromJson(json['facture_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CreateFactureData otherTyped = other as CreateFactureData;
    return facture_insert == otherTyped.facture_insert;
  }
  @override
  int get hashCode => facture_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['facture_insert'] = facture_insert.toJson();
    return json;
  }

  CreateFactureData({required this.facture_insert});
}

@immutable
class CreateFactureVariables {
  final double totalPrice;
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateFactureVariables.fromJson(Map<String, dynamic> json):
  totalPrice = nativeFromJson<double>(json['totalPrice']),
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CreateFactureVariables otherTyped = other as CreateFactureVariables;
    return totalPrice == otherTyped.totalPrice && userId == otherTyped.userId;
  }
  @override
  int get hashCode => Object.hashAll([totalPrice.hashCode, userId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['totalPrice'] = nativeToJson<double>(totalPrice);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  CreateFactureVariables({required this.totalPrice, required this.userId});
}
