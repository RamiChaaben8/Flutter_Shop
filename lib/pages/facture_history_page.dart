import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_shop/generated/default.dart';

class FactureHistoryPage extends StatefulWidget {
  const FactureHistoryPage({super.key});

  @override
  State<FactureHistoryPage> createState() => _FactureHistoryPageState();
}

class _FactureHistoryPageState extends State<FactureHistoryPage> {
  final DefaultConnector _connector = DefaultConnector.instance;
  String _filter = 'All'; // 'All', 'Today', 'Month', 'Year'

  @override
  Widget build(BuildContext context) {
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
        future: _connector.listFactures().execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading history: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.factures.isEmpty) {
            return const Center(child: Text('No factures found.'));
          }

          var factures = snapshot.data!.data.factures;

          // Apply Filter
          final now = DateTime.now();
          if (_filter == 'Today') {
            factures = factures.where((f) {
              final date = f.createdAt.toDateTime();
              return date.year == now.year && date.month == now.month && date.day == now.day;
            }).toList();
          } else if (_filter == 'Month') {
            factures = factures.where((f) {
              final date = f.createdAt.toDateTime();
              return date.year == now.year && date.month == now.month;
            }).toList();
          } else if (_filter == 'Year') {
            factures = factures.where((f) {
              final date = f.createdAt.toDateTime();
              return date.year == now.year;
            }).toList();
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
                  title: Text('Total: \$${facture.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Date: $formattedDate\nID: ${facture.id}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showFactureDetails(context, facture.id, facture.totalPrice, formattedDate);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _filter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _filter = label;
            });
          }
        },
      ),
    );
  }

  void _showFactureDetails(BuildContext context, String factureId, double total, String date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
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
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _connector.getFactureItems(factureId: factureId).execute(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading items: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.data.factureItems.isEmpty) {
                      return const Center(child: Text('No items found in this facture.'));
                    }

                    final items = snapshot.data!.data.factureItems;

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final product = item.product;
                        final isWeightBased = item.weight != null;
                        
                        return ListTile(
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Code: ${product.id} | Price: \$${product.price}${isWeightBased ? "/kg" : ""}'),
                          trailing: Text(
                            isWeightBased ? '${item.weight} kg' : 'x${item.quantity}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
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
