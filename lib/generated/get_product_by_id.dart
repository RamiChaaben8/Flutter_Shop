part of 'default.dart';

class GetProductByIdVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetProductByIdVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetProductByIdData> dataDeserializer = (dynamic json)  => GetProductByIdData.fromJson(jsonDecode(json));
  Serializer<GetProductByIdVariables> varsSerializer = (GetProductByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductByIdData, GetProductByIdVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProductByIdData, GetProductByIdVariables> ref() {
    GetProductByIdVariables vars= GetProductByIdVariables(id: id,);
    return _dataConnect.query("GetProductById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductByIdProduct {
  final String id;
  final String name;
  final double price;
  GetProductByIdProduct.fromJson(dynamic json):
  
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

    final GetProductByIdProduct otherTyped = other as GetProductByIdProduct;
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

  GetProductByIdProduct({
    required this.id,
    required this.name,
    required this.price,
  });
}

@immutable
class GetProductByIdData {
  final GetProductByIdProduct? product;
  GetProductByIdData.fromJson(dynamic json):
  
  product = json['product'] == null ? null : GetProductByIdProduct.fromJson(json['product']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductByIdData otherTyped = other as GetProductByIdData;
    return product == otherTyped.product;
    
  }
  @override
  int get hashCode => product.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (product != null) {
      json['product'] = product!.toJson();
    }
    return json;
  }

  GetProductByIdData({
    this.product,
  });
}

@immutable
class GetProductByIdVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductByIdVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductByIdVariables otherTyped = other as GetProductByIdVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetProductByIdVariables({
    required this.id,
  });
}

