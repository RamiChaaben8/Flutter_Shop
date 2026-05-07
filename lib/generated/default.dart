library project_shop;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'create_facture.dart';

part 'add_facture_item.dart';

part 'list_products.dart';

part 'get_product_by_id.dart';







class DefaultConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String id, required String name, required double price, }) {
    return AddProductVariablesBuilder(dataConnect, id: id,name: name,price: price,);
  }
  
  
  CreateFactureVariablesBuilder createFacture ({required double totalPrice, }) {
    return CreateFactureVariablesBuilder(dataConnect, totalPrice: totalPrice,);
  }
  
  
  AddFactureItemVariablesBuilder addFactureItem ({required String factureId, required String productId, required int quantity, }) {
    return AddFactureItemVariablesBuilder(dataConnect, factureId: factureId,productId: productId,quantity: quantity,);
  }
  
  
  ListProductsVariablesBuilder listProducts () {
    return ListProductsVariablesBuilder(dataConnect, );
  }
  
  
  GetProductByIdVariablesBuilder getProductById ({required String id, }) {
    return GetProductByIdVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'default',
    'fir-auth-6394d-service',
  );

  DefaultConnector({required this.dataConnect});
  static DefaultConnector get instance {
    
    return DefaultConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
