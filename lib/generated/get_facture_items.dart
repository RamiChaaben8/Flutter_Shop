part of 'default.dart';

class GetFactureItemsVariablesBuilder {
  String factureId;

  final FirebaseDataConnect _dataConnect;
  GetFactureItemsVariablesBuilder(this._dataConnect, {required  this.factureId,});
  Deserializer<GetFactureItemsData> dataDeserializer = (dynamic json)  => GetFactureItemsData.fromJson(jsonDecode(json));
  Serializer<GetFactureItemsVariables> varsSerializer = (GetFactureItemsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetFactureItemsData, GetFactureItemsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetFactureItemsData, GetFactureItemsVariables> ref() {
    GetFactureItemsVariables vars= GetFactureItemsVariables(factureId: factureId,);
    return _dataConnect.query("GetFactureItems", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetFactureItemsFactureItems {
  final String id;
  final double? quantity;
  final double? weight;
  final GetFactureItemsFactureItemsProduct product;
  GetFactureItemsFactureItems.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  quantity = json['quantity'] == null ? null : nativeFromJson<double>(json['quantity']),
  weight = json['weight'] == null ? null : nativeFromJson<double>(json['weight']),
  product = GetFactureItemsFactureItemsProduct.fromJson(json['product']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFactureItemsFactureItems otherTyped = other as GetFactureItemsFactureItems;
    return id == otherTyped.id && 
    quantity == otherTyped.quantity && 
    weight == otherTyped.weight && 
    product == otherTyped.product;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, quantity.hashCode, weight.hashCode, product.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (quantity != null) {
      json['quantity'] = nativeToJson<double?>(quantity);
    }
    if (weight != null) {
      json['weight'] = nativeToJson<double?>(weight);
    }
    json['product'] = product.toJson();
    return json;
  }

  GetFactureItemsFactureItems({
    required this.id,
    this.quantity,
    this.weight,
    required this.product,
  });
}

@immutable
class GetFactureItemsFactureItemsProduct {
  final String id;
  final String name;
  final double price;
  GetFactureItemsFactureItemsProduct.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  price = nativeFromJson<double>(json['price']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFactureItemsFactureItemsProduct otherTyped = other as GetFactureItemsFactureItemsProduct;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    price == otherTyped.price;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, price.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['price'] = nativeToJson<double>(price);
    return json;
  }

  GetFactureItemsFactureItemsProduct({
    required this.id,
    required this.name,
    required this.price,
  });
}

@immutable
class GetFactureItemsData {
  final List<GetFactureItemsFactureItems> factureItems;
  GetFactureItemsData.fromJson(dynamic json):
  
  factureItems = (json['factureItems'] as List<dynamic>)
        .map((e) => GetFactureItemsFactureItems.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFactureItemsData otherTyped = other as GetFactureItemsData;
    return factureItems == otherTyped.factureItems;
    
  }
  @override
  int get hashCode => factureItems.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureItems'] = factureItems.map((e) => e.toJson()).toList();
    return json;
  }

  GetFactureItemsData({
    required this.factureItems,
  });
}

@immutable
class GetFactureItemsVariables {
  final String factureId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetFactureItemsVariables.fromJson(Map<String, dynamic> json):
  
  factureId = nativeFromJson<String>(json['factureId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFactureItemsVariables otherTyped = other as GetFactureItemsVariables;
    return factureId == otherTyped.factureId;
    
  }
  @override
  int get hashCode => factureId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['factureId'] = nativeToJson<String>(factureId);
    return json;
  }

  GetFactureItemsVariables({
    required this.factureId,
  });
}

