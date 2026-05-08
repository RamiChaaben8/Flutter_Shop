library project_shop;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'create_facture.dart';

part 'add_facture_item.dart';

part 'list_products.dart';

part 'get_product_by_id.dart';

part 'list_factures.dart';

part 'get_facture_items.dart';







class DefaultConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String id, required String name, required double price, }) {
    return AddProductVariablesBuilder(dataConnect, id: id,name: name,price: price,);
  }
  
  
  CreateFactureVariablesBuilder createFacture ({required double totalPrice, }) {
    return CreateFactureVariablesBuilder(dataConnect, totalPrice: totalPrice,);
  }
  
  
  AddFactureItemVariablesBuilder addFactureItem ({required String factureId, required String productId, }) {
    return AddFactureItemVariablesBuilder(dataConnect, factureId: factureId,productId: productId,);
  }
  
  
  ListProductsVariablesBuilder listProducts () {
    return ListProductsVariablesBuilder(dataConnect, );
  }
  
  
  GetProductByIdVariablesBuilder getProductById ({required String id, }) {
    return GetProductByIdVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListFacturesVariablesBuilder listFactures () {
    return ListFacturesVariablesBuilder(dataConnect, );
  }
  
  
  GetFactureItemsVariablesBuilder getFactureItems ({required String factureId, }) {
    return GetFactureItemsVariablesBuilder(dataConnect, factureId: factureId,);
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
