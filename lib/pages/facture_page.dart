import 'package:flutter/material.dart';
import 'package:project_shop/generated/default.dart';
import 'package:project_shop/pages/scanner_page.dart';
import 'package:project_shop/pages/fruit_scanner_page.dart';

class FacturePage extends StatefulWidget {
  const FacturePage({super.key});

  @override
  State<FacturePage> createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  final DefaultConnector _connector = DefaultConnector.instance;
  final TextEditingController _barcodeController = TextEditingController();
  
  // List of items in the current facture
  final List<Map<String, dynamic>> _factureItems = [];

  bool _isLoading = false;

  // Add an existing product by searching its Code Bar
  Future<void> _addProductToFacture({String? predefinedBarcode}) async {
    final barcode = predefinedBarcode ?? _barcodeController.text.trim();
    if (barcode.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Fetch product from DB using generated query GetProductById
      final response = await _connector.getProductById(id: barcode).execute();
      final product = response.data.product;

      if (product == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found! Please add it first.')),
        );
      } else {
        // Check if it's a fruit/veg (ID starts with FRUIT_)
        if (product.id.startsWith('FRUIT_')) {
          setState(() => _isLoading = false); // Stop loading to show dialog
          final double? weight = await _showWeightDialog(product.name, product.price);
          if (weight != null && weight > 0) {
            setState(() {
              _factureItems.add({
                'id': product.id,
                'name': product.name,
                'price': product.price,
                'quantity': 1,
                'weight': weight,
              });
            });
          }
        } else {
          // Regular barcode product
          final existingItemIndex = _factureItems.indexWhere((item) => item['id'] == product.id && !item.containsKey('weight'));
          
          setState(() {
            if (existingItemIndex >= 0) {
              _factureItems[existingItemIndex]['quantity'] += 1;
            } else {
              _factureItems.add({
                'id': product.id,
                'name': product.name,
                'price': product.price,
                'quantity': 1,
              });
            }
          });
        }
        _barcodeController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Open the scanner page and process result
  Future<void> _openScanner() async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _barcodeController.text = scannedCode;
      await _addProductToFacture(predefinedBarcode: scannedCode);
    }
  }

  // Open the fruit scanner and process result
  Future<void> _openFruitScanner() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const FruitScannerPage()),
    );

    if (result != null) {
      final double? weight = await _showWeightDialog(result['name'], result['price']);
      if (weight != null && weight > 0) {
        setState(() {
          _factureItems.add({
            'id': result['id'],
            'name': result['name'],
            'price': result['price'],
            'quantity': 1,
            'weight': weight,
          });
        });
      }
    }
  }

  Future<double?> _showWeightDialog(String name, double price) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter weight for $name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: \$${price.toStringAsFixed(2)}/kg'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              Navigator.pop(context, val);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Calculate total price
  double get _totalPrice {
    return _factureItems.fold(0.0, (sum, item) {
      if (item.containsKey('weight')) {
        return sum + (item['price'] * item['weight']);
      }
      return sum + (item['price'] * item['quantity']);
    });
  }

  // Save Facture to Database
  Future<void> _saveFacture() async {
    if (_factureItems.isEmpty) return;

    setState(() => _isLoading = true);
    debugPrint('Starting to save facture with ${_factureItems.length} items');
    
    try {
      // 1. Create Facture entry
      final double total = _totalPrice;
      debugPrint('Creating facture with total: \$${total.toStringAsFixed(2)}');
      
      final factureResponse = await _connector.createFacture(totalPrice: total).execute();
      final String factureId = factureResponse.data.facture_insert.id;
      debugPrint('Facture created with ID: $factureId');

      // 2. Loop through all items and save them linking to factureId
      for (var item in _factureItems) {
        final String productId = item['id'].toString();
        final String productName = item['name'].toString();
        final double productPrice = (item['price'] as num).toDouble();
        
        debugPrint('Processing item: $productName (ID: $productId)');

        try {
          // Ensure product exists
          final productCheck = await _connector.getProductById(id: productId).execute();
          
          if (productCheck.data.product == null) {
            debugPrint('Product $productId not found, adding it...');
            await _connector.addProduct(
              id: productId,
              name: productName,
              price: productPrice,
            ).execute();
            debugPrint('Product $productId added successfully');
          }

          final isWeightBased = item.containsKey('weight');
          var itemMutation = _connector.addFactureItem(
            factureId: factureId,
            productId: productId,
          );
          
          if (isWeightBased) {
            final double w = (item['weight'] as num).toDouble();
            debugPrint('Adding weight-based item: $w kg');
            itemMutation.weight(w);
          } else {
            final int q = (item['quantity'] as num).toInt();
            debugPrint('Adding quantity-based item: $q units');
            itemMutation.quantity(q);
          }
          
          await itemMutation.execute();
          debugPrint('Item $productId added to facture');
        } catch (itemError) {
          debugPrint('Error saving item $productId: $itemError');
          // If product add failed because it exists, we might want to continue
          if (itemError.toString().contains('already exists')) {
            debugPrint('Product already exists, continuing...');
            // Re-try adding the item link
            final isWeightBased = item.containsKey('weight');
            var retryMutation = _connector.addFactureItem(factureId: factureId, productId: productId);
            if (isWeightBased) {
              retryMutation.weight((item['weight'] as num).toDouble());
            } else {
              retryMutation.quantity((item['quantity'] as num).toInt());
            }
            await retryMutation.execute();
          } else {
            throw Exception('Failed to save item "$productName": $itemError');
          }
        }
      }

      debugPrint('Facture saved successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facture created successfully!')),
      );

      setState(() {
        _factureItems.clear();
      });
    } catch (e) {
      debugPrint('Global error saving facture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving facture: $e'),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(label: 'Details', onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Save Error'),
                content: SingleChildScrollView(child: Text(e.toString())),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
              ),
            );
          }),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Facture (Invoice)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input row with scanner buttons
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Scan or Type Code Bar',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                        onPressed: _openScanner,
                        tooltip: 'Scan Barcode',
                      ),
                    ),
                    onSubmitted: (value) => _addProductToFacture(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _addProductToFacture(),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _openFruitScanner,
                icon: const Icon(Icons.eco),
                label: const Text('Scan Fruit/Veg (by Weight)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // List of scanned items
            Expanded(
              child: ListView.builder(
                itemCount: _factureItems.length,
                itemBuilder: (context, index) {
                  final item = _factureItems[index];
                  final isWeightBased = item.containsKey('weight');
                  final double price = item['price'];
                  final double quantity = isWeightBased ? item['weight'] : item['quantity'].toDouble();
                  final double amount = price * quantity;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Code: ${item['id']}'),
                          Text(
                            isWeightBased 
                                ? 'Price: \$${price.toStringAsFixed(2)}/kg | Weight: ${item['weight']}kg'
                                : 'Price: \$${price.toStringAsFixed(2)} | Qty: ${item['quantity']}',
                          ),
                          Text(
                            'Amount: \$${amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isWeightBased) ...[
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                              onPressed: () {
                                setState(() {
                                  if (item['quantity'] > 1) {
                                    item['quantity'] -= 1;
                                  } else {
                                    _factureItems.removeAt(index);
                                  }
                                });
                              },
                            ),
                            Text('${item['quantity']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  item['quantity'] += 1;
                                });
                              },
                            ),
                          ] else 
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final newWeight = await _showWeightDialog(item['name'], item['price']);
                                if (newWeight != null && newWeight > 0) {
                                  setState(() {
                                    item['weight'] = newWeight;
                                  });
                                }
                              },
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _factureItems.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Total & Save Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: \$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: _isLoading || _factureItems.isEmpty ? null : _saveFacture,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: _isLoading ? const CircularProgressIndicator() : const Text('Save Facture'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
