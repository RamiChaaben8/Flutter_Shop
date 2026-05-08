import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:project_shop/generated/default.dart';

class FactureHistoryPage extends StatefulWidget {
  const FactureHistoryPage({super.key});

  @override
  State<FactureHistoryPage> createState() => _FactureHistoryPageState();
}

class _FactureHistoryPageState extends State<FactureHistoryPage> {
  final DefaultConnector _connector = DefaultConnector.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  String _filter = 'All';

  Future<Map<String, dynamic>> _fetchAllItems(String factureId) async {
    final productResult = await _connector.getFactureItems(factureId: factureId).execute();
    final fruitResult = await _connector.getFactureFruitItems(factureId: factureId).execute();
    return {
      'products': productResult.data.factureItems,
      'fruits': fruitResult.data.factureFruitItems,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(body: Center(child: Text('Not logged in.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facture History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Today'),
                _buildFilterButton('Month'),
                _buildFilterButton('Year'),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _connector.listFactures(userId: _userId!).execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.factures.isEmpty) {
            return const Center(child: Text('No factures found.'));
          }

          var factures = snapshot.data!.data.factures;
          final now = DateTime.now();

          if (_filter == 'Today') {
            factures = factures.where((f) {
              final d = f.createdAt.toDateTime();
              return d.year == now.year && d.month == now.month && d.day == now.day;
            }).toList();
          } else if (_filter == 'Month') {
            factures = factures.where((f) {
              final d = f.createdAt.toDateTime();
              return d.year == now.year && d.month == now.month;
            }).toList();
          } else if (_filter == 'Year') {
            factures = factures.where((f) => f.createdAt.toDateTime().year == now.year).toList();
          }

          if (factures.isEmpty) {
            return const Center(child: Text('No factures for this period.'));
          }

          return ListView.builder(
            itemCount: factures.length,
            itemBuilder: (context, index) {
              final facture = factures[index];
              final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(facture.createdAt.toDateTime());

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.blue),
                  title: Text(
                    'Total: ${facture.totalPrice.toStringAsFixed(3)} TND',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Date: $formattedDate\nID: ${facture.id}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showFactureDetails(context, facture.id, facture.totalPrice, formattedDate),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == label,
        onSelected: (selected) { if (selected) setState(() => _filter = label); },
      ),
    );
  }

  void _showFactureDetails(BuildContext context, String factureId, double total, String date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Facture Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(date, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Text(
                      '${total.toStringAsFixed(3)} TND',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _fetchAllItems(factureId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final productItems = snapshot.data!['products'] as List<GetFactureItemsFactureItems>;
                    final fruitItems = snapshot.data!['fruits'] as List<GetFactureFruitItemsFactureFruitItems>;

                    if (productItems.isEmpty && fruitItems.isEmpty) {
                      return const Center(child: Text('No items in this facture.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: productItems.length + fruitItems.length,
                      itemBuilder: (context, index) {
                        if (index < productItems.length) {
                          final item = productItems[index];
                          final amount = item.product.price * item.quantity;
                          return ListTile(
                            leading: const Icon(Icons.barcode_reader, color: Colors.blue),
                            title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.product.price.toStringAsFixed(3)} TND × ${item.quantity.toInt()}'),
                            trailing: Text('${amount.toStringAsFixed(3)} TND',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                          );
                        } else {
                          final item = fruitItems[index - productItems.length];
                          final amount = item.fruit.pricePerKg * item.weight;
                          return ListTile(
                            leading: const Icon(Icons.eco, color: Colors.green),
                            title: Text(item.fruit.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.fruit.pricePerKg.toStringAsFixed(3)} TND/kg × ${item.weight.toStringAsFixed(3)} kg'),
                            trailing: Text('${amount.toStringAsFixed(3)} TND',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
