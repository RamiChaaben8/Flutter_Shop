library project_shop;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';
part 'add_fruit.dart';
part 'upsert_fruit.dart';
part 'create_facture.dart';
part 'add_facture_item.dart';
part 'add_facture_fruit_item.dart';
part 'list_products.dart';
part 'list_fruits.dart';
part 'get_product_by_id.dart';
part 'get_fruit_by_id.dart';
part 'list_factures.dart';
part 'get_facture_items.dart';
part 'get_facture_fruit_items.dart';


class DefaultConnector {

  AddProductVariablesBuilder addProduct({required String id, required String name, required double price}) {
    return AddProductVariablesBuilder(dataConnect, id: id, name: name, price: price);
  }

  AddFruitVariablesBuilder addFruit({required String id, required String name, required double pricePerKg}) {
    return AddFruitVariablesBuilder(dataConnect, id: id, name: name, pricePerKg: pricePerKg);
  }

  UpsertFruitVariablesBuilder upsertFruit({required String id, required String name, required double pricePerKg}) {
    return UpsertFruitVariablesBuilder(dataConnect, id: id, name: name, pricePerKg: pricePerKg);
  }

  CreateFactureVariablesBuilder createFacture({required double totalPrice, required String userId}) {
    return CreateFactureVariablesBuilder(dataConnect, totalPrice: totalPrice, userId: userId);
  }

  AddFactureItemVariablesBuilder addFactureItem({required String factureId, required String productId, required double quantity}) {
    return AddFactureItemVariablesBuilder(dataConnect, factureId: factureId, productId: productId, quantity: quantity);
  }

  AddFactureFruitItemVariablesBuilder addFactureFruitItem({required String factureId, required String fruitId, required double weight}) {
    return AddFactureFruitItemVariablesBuilder(dataConnect, factureId: factureId, fruitId: fruitId, weight: weight);
  }

  ListProductsVariablesBuilder listProducts() {
    return ListProductsVariablesBuilder(dataConnect);
  }

  ListFruitsVariablesBuilder listFruits() {
    return ListFruitsVariablesBuilder(dataConnect);
  }

  GetProductByIdVariablesBuilder getProductById({required String id}) {
    return GetProductByIdVariablesBuilder(dataConnect, id: id);
  }

  GetFruitByIdVariablesBuilder getFruitById({required String id}) {
    return GetFruitByIdVariablesBuilder(dataConnect, id: id);
  }

  ListFacturesVariablesBuilder listFactures({required String userId}) {
    return ListFacturesVariablesBuilder(dataConnect, userId: userId);
  }

  GetFactureItemsVariablesBuilder getFactureItems({required String factureId}) {
    return GetFactureItemsVariablesBuilder(dataConnect, factureId: factureId);
  }

  GetFactureFruitItemsVariablesBuilder getFactureFruitItems({required String factureId}) {
    return GetFactureFruitItemsVariablesBuilder(dataConnect, factureId: factureId);
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
