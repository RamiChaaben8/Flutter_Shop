part of 'default.dart';

class AddProductVariablesBuilder {
  String id;
  String name;
  double price;

  final FirebaseDataConnect _dataConnect;
  AddProductVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.price,});
  Deserializer<AddProductData> dataDeserializer = (dynamic json)  => AddProductData.fromJson(jsonDecode(json));
  Serializer<AddProductVariables> varsSerializer = (AddProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductData, AddProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductData, AddProductVariables> ref() {
    AddProductVariables vars= AddProductVariables(id: id,name: name,price: price,);
    return _dataConnect.mutation("AddProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductProductInsert {
  final String id;
  AddProductProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductProductInsert otherTyped = other as AddProductProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductProductInsert({
    required this.id,
  });
}

@immutable
class AddProductData {
  final AddProductProductInsert product_insert;
  AddProductData.fromJson(dynamic json):
  
  product_insert = AddProductProductInsert.fromJson(json['product_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductData otherTyped = other as AddProductData;
    return product_insert == otherTyped.product_insert;
    
  }
  @override
  int get hashCode => product_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    return json;
  }

  AddProductData({
    required this.product_insert,
  });
}

@immutable
class AddProductVariables {
  final String id;
  final String name;
  final double price;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductVariables.fromJson(Map<String, dynamic> json):
  
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

    final AddProductVariables otherTyped = other as AddProductVariables;
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

  AddProductVariables({
    required this.id,
    required this.name,
    required this.price,
  });
}

