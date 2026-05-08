# project_shop SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
DefaultConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListProducts
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.listProducts().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListProductsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listProducts();
ListProductsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.listProducts().ref();
ref.execute();

ref.subscribe(...);
```


### GetProductById
#### Required Arguments
```dart
String id = ...;
DefaultConnector.instance.getProductById(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductByIdData, GetProductByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getProductById(
  id: id,
);
GetProductByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = DefaultConnector.instance.getProductById(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListFactures
#### Required Arguments
```dart
// No required arguments
DefaultConnector.instance.listFactures().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListFacturesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.listFactures();
ListFacturesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = DefaultConnector.instance.listFactures().ref();
ref.execute();

ref.subscribe(...);
```


### GetFactureItems
#### Required Arguments
```dart
String factureId = ...;
DefaultConnector.instance.getFactureItems(
  factureId: factureId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetFactureItemsData, GetFactureItemsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await DefaultConnector.instance.getFactureItems(
  factureId: factureId,
);
GetFactureItemsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String factureId = ...;

final ref = DefaultConnector.instance.getFactureItems(
  factureId: factureId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### AddProduct
#### Required Arguments
```dart
String id = ...;
String name = ...;
double price = ...;
DefaultConnector.instance.addProduct(
  id: id,
  name: name,
  price: price,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddProductData, AddProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.addProduct(
  id: id,
  name: name,
  price: price,
);
AddProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
double price = ...;

final ref = DefaultConnector.instance.addProduct(
  id: id,
  name: name,
  price: price,
).ref();
ref.execute();
```


### CreateFacture
#### Required Arguments
```dart
double totalPrice = ...;
DefaultConnector.instance.createFacture(
  totalPrice: totalPrice,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateFactureData, CreateFactureVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.createFacture(
  totalPrice: totalPrice,
);
CreateFactureData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
double totalPrice = ...;

final ref = DefaultConnector.instance.createFacture(
  totalPrice: totalPrice,
).ref();
ref.execute();
```


### AddFactureItem
#### Required Arguments
```dart
String factureId = ...;
String productId = ...;
DefaultConnector.instance.addFactureItem(
  factureId: factureId,
  productId: productId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddFactureItem, we created `AddFactureItemBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddFactureItemVariablesBuilder {
  ...
   AddFactureItemVariablesBuilder quantity(int? t) {
   _quantity.value = t;
   return this;
  }
  AddFactureItemVariablesBuilder weight(double? t) {
   _weight.value = t;
   return this;
  }

  ...
}
DefaultConnector.instance.addFactureItem(
  factureId: factureId,
  productId: productId,
)
.quantity(quantity)
.weight(weight)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddFactureItemData, AddFactureItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await DefaultConnector.instance.addFactureItem(
  factureId: factureId,
  productId: productId,
);
AddFactureItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String factureId = ...;
String productId = ...;

final ref = DefaultConnector.instance.addFactureItem(
  factureId: factureId,
  productId: productId,
).ref();
ref.execute();
```

