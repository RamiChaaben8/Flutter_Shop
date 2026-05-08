part of 'default.dart';

class ListFacturesVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  ListFacturesVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<ListFacturesData> dataDeserializer = (dynamic json) => ListFacturesData.fromJson(jsonDecode(json));
  Serializer<ListFacturesVariables> varsSerializer = (ListFacturesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListFacturesData, ListFacturesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListFacturesData, ListFacturesVariables> ref() {
    ListFacturesVariables vars = ListFacturesVariables(userId: userId);
    return _dataConnect.query("ListFactures", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListFacturesFactures {
  final String id;
  final double totalPrice;
  final Timestamp createdAt;
  ListFacturesFactures.fromJson(dynamic json):
  id = nativeFromJson<String>(json['id']),
  totalPrice = nativeFromJson<double>(json['totalPrice']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ListFacturesFactures otherTyped = other as ListFacturesFactures;
    return id == otherTyped.id &&
    totalPrice == otherTyped.totalPrice &&
    createdAt == otherTyped.createdAt;
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, totalPrice.hashCode, createdAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['totalPrice'] = nativeToJson<double>(totalPrice);
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  ListFacturesFactures({required this.id, required this.totalPrice, required this.createdAt});
}

@immutable
class ListFacturesData {
  final List<ListFacturesFactures> factures;
  ListFacturesData.fromJson(dynamic json):
  factures = (json['factures'] as List<dynamic>)
      .map((e) => ListFacturesFactures.fromJson(e))
      .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ListFacturesData otherTyped = other as ListFacturesData;
    return factures == otherTyped.factures;
  }
  @override
  int get hashCode => factures.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factures'] = factures.map((e) => e.toJson()).toList();
    return json;
  }

  ListFacturesData({required this.factures});
}

@immutable
class ListFacturesVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListFacturesVariables.fromJson(Map<String, dynamic> json):
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ListFacturesVariables otherTyped = other as ListFacturesVariables;
    return userId == otherTyped.userId;
  }
  @override
  int get hashCode => userId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  ListFacturesVariables({required this.userId});
}
