import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_shop/auth.dart';
import 'package:project_shop/generated/default.dart';
import 'package:project_shop/pages/facture_page.dart';
import 'package:project_shop/pages/facture_history_page.dart';
import 'package:project_shop/pages/scanner_page.dart';
import 'package:project_shop/pages/fruit_scanner_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> _openScanner() async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _barcodeController.text = scannedCode;
      await _addProduct();
    }
  }

  Future<void> _addProduct() async {
    try {
      final String barcode = _barcodeController.text.trim();
      final String name = _nameController.text.trim();
      final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      if (barcode.isEmpty || name.isEmpty || price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields correctly.')),
        );
        return;
      }

      final DefaultConnector connector = DefaultConnector.instance;
      await connector.addProduct(id: barcode, name: name, price: price).execute();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      _barcodeController.clear();
      _nameController.clear();
      _priceController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Opens the fruit scanner in "add to database" mode
  Future<void> _openFruitScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FruitScannerPage(mode: FruitScannerMode.addToDatabase),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Facture History',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FactureHistoryPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Create Facture',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FacturePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Logged in as: ${user?.email ?? 'Unknown'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Create Facture
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacturePage()),
                ),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Create New Facture'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Facture History
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FactureHistoryPage()),
                ),
                icon: const Icon(Icons.history),
                label: const Text('View Facture History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const Divider(height: 60),

            // ── Fruit / Veg Section ──
            const Text(
              'Fruits & Vegetables',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use the camera to scan a fruit/veg and set its price per kg.\n'
              'This saves it to the database so it can be used in invoices.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openFruitScanner,
                icon: const Icon(Icons.eco),
                label: const Text('Add / Update Fruit & Veg (by Camera)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const Divider(height: 60),

            // ── Regular Product Section ──
            const Text(
              'Add New Product (Barcode)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: 'Code Bar (ID)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                  onPressed: _openScanner,
                  tooltip: 'Scan Barcode',
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addProduct,
              icon: const Icon(Icons.save),
              label: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}