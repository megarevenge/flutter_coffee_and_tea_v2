import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/cart_item_card.dart';
import 'package:flutter_coffee_and_tea/pages/checkout_page.dart';

class OrdersPage extends StatelessWidget {
  final ValueNotifier<Map<String, Map<String, dynamic>>> cartNotifier;

  const OrdersPage({super.key, required this.cartNotifier});

  void _updateCartQuantity(String name, double price, int delta) {
    // 1. Create a copy of the current cart map
    final updatedCart = Map<String, Map<String, dynamic>>.from(
      cartNotifier.value,
    );

    if (updatedCart.containsKey(name)) {
      int currentQty = updatedCart[name]!['quantity'] as int;
      int newQty = currentQty + delta;

      if (newQty <= 0) {
        updatedCart.remove(name); // Remove item if count hits zero
      } else {
        updatedCart[name] = {'price': price, 'quantity': newQty};
      }
    } else if (delta > 0) {
      updatedCart[name] = {'price': price, 'quantity': 1};
    }

    // 2. Push the new map data reference to trigger UI update
    cartNotifier.value = updatedCart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(
            color: Color(0xffF3E4C9),
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff8A5F41),
        elevation: 0,
      ),
      backgroundColor: Color(0xffF3E4C9),
      body: ValueListenableBuilder<Map<String, Map<String, dynamic>>>(
        valueListenable: cartNotifier,
        builder: (context, cartMap, child) {
          if (cartMap.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty!',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate the total price of all items added to the cart
          double totalBill = 0.0;
          cartMap.forEach((name, details) {
            final double price = details['price'] as double? ?? 0.0;
            final int quantity = details['quantity'] as int? ?? 0;
            totalBill += price * quantity;
          });

          final itemNames = cartMap.keys.toList();

          return Column(
            children: [
              // 1. KEEP LISTVIEW.BUILDER HERE INSIDE ORDERS PAGE
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: itemNames.length,
                  itemBuilder: (context, index) {
                    final String name = itemNames[index];
                    final Map<String, dynamic> details = cartMap[name]!;
                    final double price = details['price'] as double? ?? 0.0;
                    final int quantity = details['quantity'] as int? ?? 0;

                    return CartItemCard(
                      name: name,
                      description: 'Item Description\nItem Description...',
                      quantity: quantity,
                      price: price,
                      onIncrement: () => _updateCartQuantity(name, price, 1),
                      onDecrement: () => _updateCartQuantity(name, price, -1),
                      onGoToItem: () {
                        // Handle navigation or bottom sheet inspection here
                      },
                    );
                  },
                ),
              ),

              // Bottom Total Price Summary Sticky Board
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalBill.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff8A5F41),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  cartMap: cartMap,
                                ), // Opens CheckoutPage
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8A5F41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
