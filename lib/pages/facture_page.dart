import 'package:flutter/material.dart';
import 'package:project_shop/generated/default.dart';
import 'package:project_shop/pages/scanner_page.dart';

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
        // 2. Add to local list or increment quantity if it exists
        final existingItemIndex = _factureItems.indexWhere((item) => item['id'] == product.id);
        
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

  // Calculate total price
  double get _totalPrice {
    return _factureItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Save Facture to Database
  Future<void> _saveFacture() async {
    if (_factureItems.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      // 1. Create Facture entry
      final factureResponse = await _connector.createFacture(totalPrice: _totalPrice).execute();
      final factureId = factureResponse.data.facture_insert.id;

      // 2. Loop through all items and save them linking to factureId
      for (var item in _factureItems) {
        await _connector.addFactureItem(
          factureId: factureId,
          productId: item['id'],
          quantity: item['quantity'],
        ).execute();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facture created successfully!')),
      );

      setState(() {
        _factureItems.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving facture: $e')),
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
            // Input row with scanner button
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
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _addProductToFacture(),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // List of scanned items
            Expanded(
              child: ListView.builder(
                itemCount: _factureItems.length,
                itemBuilder: (context, index) {
                  final item = _factureItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Code: ${item['id']} | Price: \$${item['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
