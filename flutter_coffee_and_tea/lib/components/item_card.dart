import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String name;
  final double price;
  final ValueNotifier<Map<String, Map<String, dynamic>>> cartNotifier;

  const ItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.cartNotifier,
  });

  // Helper method to safely update the shared ValueNotifier map state
  void _updateQuantityInNotifier(int delta) {
    // Create a shallow copy of the map to properly trigger ValueNotifier listeners
    final updatedCart = Map<String, Map<String, dynamic>>.from(
      cartNotifier.value,
    );

    if (updatedCart.containsKey(name)) {
      int currentQty = updatedCart[name]!['quantity'];
      int newQty = currentQty + delta;

      if (newQty <= 0) {
        updatedCart.remove(name); // Remove item completely if count hits zero
      } else {
        // Create a copy of the inner map to ensure clean reactive value changes
        updatedCart[name] = {'price': price, 'quantity': newQty};
      }
    } else if (delta > 0) {
      // First time adding this specific drink to the cart
      updatedCart[name] = {'price': price, 'quantity': 1};
    }

    // Assigning a brand new map reference triggers the ValueListenableBuilder badge UI rebuild
    cartNotifier.value = updatedCart;
  }

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _syncLocalQuantityWithNotifier();
  }

  @override
  void didUpdateWidget(covariant ItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keeps quantities accurate if items get added or dropped via other views
    _syncLocalQuantityWithNotifier();
  }

  // Helper to extract state values cleanly out of your notifier structure
  void _syncLocalQuantityWithNotifier() {
    final currentCart = widget.cartNotifier.value;
    if (currentCart.containsKey(widget.name)) {
      _quantity = currentCart[widget.name]?['quantity'] ?? 0;
    } else {
      _quantity = 0;
    }
  }

  // Handles updating both local display and the global notifier state together
  void _changeQuantity(int delta) {
    setState(() {
      _quantity += delta;
      if (_quantity < 0) _quantity = 0;
    });
    widget._updateQuantityInNotifier(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip
                    .none, // Allows counter to overflow the image boundary smoothly
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.coffee,
                        size: 40,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    left: _quantity > 0 ? 10 : null,
                    right: 10,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: const Color(0xffA77F60),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      // AnimatedCrossFade smoothly fades between the single button and the full row
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _quantity == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        // FIRST STATE: Single "+" Button
                        firstChild: GestureDetector(
                          onTap: () => _changeQuantity(1),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        // SECOND STATE: Full Counter Row
                        secondChild: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _changeQuantity(-1),
                              child: const Icon(
                                Icons.remove,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _changeQuantity(1),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$ ${widget.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
