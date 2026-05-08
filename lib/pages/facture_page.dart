import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  /// Each item is either:
  ///   type = 'product' → {type, id, name, price, quantity}
  ///   type = 'fruit'   → {type, id, name, pricePerKg, weight}
  final List<Map<String, dynamic>> _factureItems = [];

  bool _isLoading = false;

  // ─── Add regular product by barcode ───────────────────────────────────────

  Future<void> _addProductToFacture({String? predefinedBarcode}) async {
    final barcode = predefinedBarcode ?? _barcodeController.text.trim();
    if (barcode.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _connector.getProductById(id: barcode).execute();
      final product = response.data.product;

      if (product == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product not found! Please add it first.')),
          );
        }
      } else {
        final existingIndex = _factureItems.indexWhere(
          (item) => item['type'] == 'product' && item['id'] == product.id,
        );

        setState(() {
          if (existingIndex >= 0) {
            _factureItems[existingIndex]['quantity'] += 1;
          } else {
            _factureItems.add({
              'type': 'product',
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── Open barcode scanner ─────────────────────────────────────────────────

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

  // ─── Open fruit scanner (facture mode) ────────────────────────────────────

  Future<void> _openFruitScanner() async {
    // Step 1: Scan fruit with camera → returns {id, name, pricePerKg} from DB
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const FruitScannerPage(mode: FruitScannerMode.addToFacture),
      ),
    );

    if (result == null) return;

    // Step 2: Ask for weight
    final double? weight = await _showWeightDialog(
      result['name'] as String,
      result['pricePerKg'] as double,
    );

    if (weight != null && weight > 0) {
      setState(() {
        _factureItems.add({
          'type': 'fruit',
          'id': result['id'],
          'name': result['name'],
          'pricePerKg': result['pricePerKg'],
          'weight': weight,
        });
      });
    }
  }

  // ─── Weight dialog ────────────────────────────────────────────────────────

  Future<double?> _showWeightDialog(String name, double pricePerKg) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter weight for $name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: ${pricePerKg.toStringAsFixed(2)} TND/kg'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              Navigator.pop(ctx, val);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ─── Total price ──────────────────────────────────────────────────────────

  double get _totalPrice {
    return _factureItems.fold(0.0, (sum, item) {
      if (item['type'] == 'fruit') {
        return sum + (item['pricePerKg'] as double) * (item['weight'] as double);
      }
      return sum + (item['price'] as double) * (item['quantity'] as int);
    });
  }

  // ─── Save facture ─────────────────────────────────────────────────────────

  Future<void> _saveFacture() async {
    if (_factureItems.isEmpty) return;

    setState(() => _isLoading = true);
    debugPrint('Saving facture with ${_factureItems.length} items');

    try {
      // 1. Create facture
      final factureResponse = await _connector.createFacture(
        totalPrice: _totalPrice,
        userId: _userId ?? '',
      ).execute();
      final String factureId = factureResponse.data.facture_insert.id;
      debugPrint('Facture created: $factureId');

      // 2. Save each item
      for (final item in _factureItems) {
        if (item['type'] == 'fruit') {
          // ── Fruit item: use dedicated fruit mutation ──
          final String fruitId = item['id'] as String;
          final double weight = item['weight'] as double;
          debugPrint('Saving fruit item: $fruitId @ ${weight}kg');
          await _connector.addFactureFruitItem(
            factureId: factureId,
            fruitId: fruitId,
            weight: weight,
          ).execute();
        } else {
          // ── Regular product item ──
          final String productId = item['id'] as String;
          final String productName = item['name'] as String;
          final double productPrice = (item['price'] as num).toDouble();
          final double quantity = (item['quantity'] as int).toDouble();
          debugPrint('Saving product item: $productId x$quantity');

          // Ensure product exists
          final check = await _connector.getProductById(id: productId).execute();
          if (check.data.product == null) {
            await _connector.addProduct(
              id: productId,
              name: productName,
              price: productPrice,
            ).execute();
          }

          await _connector.addFactureItem(
            factureId: factureId,
            productId: productId,
            quantity: quantity,
          ).execute();
        }
      }

      debugPrint('Facture saved successfully!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facture saved successfully! ✅')),
        );
        setState(() => _factureItems.clear());
      }
    } catch (e) {
      debugPrint('Error saving facture: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Save Error'),
            content: SingleChildScrollView(child: Text(e.toString())),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Facture (Invoice)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Barcode row ──
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
                    onSubmitted: (_) => _addProductToFacture(),
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

            // ── Fruit scanner button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _openFruitScanner,
                icon: const Icon(Icons.eco),
                label: const Text('Scan Fruit / Veg '),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Items list ──
            Expanded(
              child: _factureItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No items yet.\nScan a barcode or fruit to add items.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _factureItems.length,
                      itemBuilder: (context, index) {
                        final item = _factureItems[index];
                        final isFruit = item['type'] == 'fruit';

                        final double unitPrice = isFruit
                            ? item['pricePerKg'] as double
                            : item['price'] as double;
                        final double qty = isFruit
                            ? item['weight'] as double
                            : (item['quantity'] as int).toDouble();
                        final double amount = unitPrice * qty;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              isFruit ? Icons.eco : Icons.barcode_reader,
                              color: isFruit ? Colors.green : Colors.blue,
                            ),
                            title: Text(
                              item['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Code: ${item['id']}'),
                                Text(
                                  isFruit
                                      ? 'Price: ${unitPrice.toStringAsFixed(2)} TND/kg | Weight: ${qty.toStringAsFixed(3)} kg'
                                      : 'Price: ${unitPrice.toStringAsFixed(2)} TND | Qty: ${qty.toInt()}',
                                ),
                                Text(
                                  'Amount: ${amount.toStringAsFixed(2)} TND',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isFruit) ...[
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                                    onPressed: () {
                                      setState(() {
                                        if ((item['quantity'] as int) > 1) {
                                          item['quantity'] -= 1;
                                        } else {
                                          _factureItems.removeAt(index);
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () {
                                      setState(() => item['quantity'] += 1);
                                    },
                                  ),
                                ] else
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      final newWeight = await _showWeightDialog(
                                        item['name'] as String,
                                        item['pricePerKg'] as double,
                                      );
                                      if (newWeight != null && newWeight > 0) {
                                        setState(() => item['weight'] = newWeight);
                                      }
                                    },
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() => _factureItems.removeAt(index));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // ── Total & Save ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${_totalPrice.toStringAsFixed(2)} TND',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading || _factureItems.isEmpty ? null : _saveFacture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Save Facture'),
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
