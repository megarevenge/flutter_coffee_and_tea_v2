import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  // Pass the real cart data map straight into this page when navigating
  final Map<String, Map<String, dynamic>> cartMap;

  const CheckoutPage({super.key, required this.cartMap});

  @override
  Widget build(BuildContext context) {
    // 1. Calculate the final total bill from the passed cart data
    double totalBill = 0.0;
    cartMap.forEach((name, details) {
      final double price = details['price'] as double? ?? 0.0;
      final int quantity = details['quantity'] as int? ?? 0;
      totalBill += price * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff8A5F41),
        elevation: 0,
        // Custom Back arrow button layout
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xffEFE5D3), // Beige background color match
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. ADDRESS BLOCK
            _buildInfoCard(
              title: 'Address',
              subtitle: 'Address Information...',
            ),
            const SizedBox(height: 12),

            // 2. CARDS BLOCK
            _buildInfoCard(title: 'Cards', subtitle: 'Hamkor Bank **1008'),
            const SizedBox(height: 12),

            // 3. BILL BLOCK
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Name column width spacing
                      1: FlexColumnWidth(1), // Count column width spacing
                      2: FlexColumnWidth(1.5), // Total column width spacing
                    },
                    children: [
                      // Header Row
                      _buildBillTableRow(
                        'Item Name',
                        'Count',
                        'Price',
                        isHeader: true,
                      ),

                      // Loops over your actual cart map entries to populate the table UI
                      ...cartMap.entries.map((entry) {
                        final String name = entry.key;
                        final Map<String, dynamic> details = entry.value;

                        final int quantity = details['quantity'] as int? ?? 0;
                        final double price = details['price'] as double? ?? 0.0;
                        final double rowTotal = price * quantity;

                        return _buildBillTableRow(
                          name,
                          '$quantity',
                          rowTotal.toStringAsFixed(
                            2,
                          ), // Matches your layout formatting string
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Total Bill Summary Row Layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalBill.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle final checkout processing payment step
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8A5F41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Table row widget structural renderer
  TableRow _buildBillTableRow(
    String col1,
    String col2,
    String col3, {
    bool isHeader = false,
  }) {
    final TextStyle cellStyle = TextStyle(
      fontSize: 16,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: Colors.black,
    );

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(col1, style: cellStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            col2,
            style: cellStyle,
            textAlign: isHeader ? TextAlign.left : TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(col3, style: cellStyle, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
