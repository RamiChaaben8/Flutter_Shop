import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_shop/auth.dart';
import 'package:project_shop/generated/default.dart';
import 'package:project_shop/pages/facture_page.dart';

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

      // Initialize the generated Data Connect connector
      final DefaultConnector connector = DefaultConnector.instance;

      // Call the GraphQL mutation we defined
      await connector.addProduct(
        id: barcode,
        name: name,
        price: price,
      ).execute();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully to SQL!')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Create Facture',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FacturePage()),
              );
            },
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
            Text('Logged in as: ${user?.email ?? 'Unknown'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Navigate to Facture Page Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacturePage()),
                );
              },
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Create New Facture'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            
            const Divider(height: 60),
            
            const Text('Add New Product (To SQL DB)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(labelText: 'Code Bar (ID)'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}