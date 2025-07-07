import 'package:flutter/material.dart';
import 'package:ministore/dio/models/cart_item_model.dart';
import 'package:ministore/provider/auth_provider.dart';
import 'package:ministore/provider/cart_provider.dart';
import 'package:ministore/route_page.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final String userRole; // 'customer', 'cashier', or 'owner'

  const CartPage({this.userRole = 'customer', super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cart.items.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, index) {
                final item = cart.items[index];
                return ListTile(
  title: Text(item.product.name),
  subtitle: Text('Qty: ${item.quantity}'),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 5,
    children: [
      
      Text(
        '\$${(double.tryParse(item.product.price as String) ?? 0) * item.quantity}',
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          context.read<CartProvider>().removeFromCart(item.product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.product.name} removed from cart')),
          );
        },
      ),
    ],
  ),
  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Consumer<CartProvider>(
                          builder: (context, cart, _) =>
                              EditQuantitySheet(item: item),
                        );
                      },
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user?.role == 'shop_owner' || user?.role == 'cashier' ?
         ElevatedButton(
          onPressed: () {
            if (user?.role == 'shop_owner' || user?.role == 'cashier') {
              Navigator.pushNamed(context, pageCheckout, arguments: userRole);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Only Owner or cashiers can checkout.')),
              );
            }
          },
          child: Text('Checkout (\$${cart.total})'),
        ) : SizedBox(),
      ),
    );
  }
}

class EditQuantitySheet extends StatefulWidget {
  final CartItem item;

  const EditQuantitySheet({required this.item, super.key});

  @override
  State<EditQuantitySheet> createState() => _EditQuantitySheetState();
}

class _EditQuantitySheetState extends State<EditQuantitySheet> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Update Quantity',
              style: Theme.of(context).textTheme.titleLarge),
          Row(
            children: [
              Expanded(
                child: Text(widget.item.product.name),
              ),
              IconButton(
                  onPressed: () => setState(() => qty--),
                  icon: Icon(Icons.remove)),
              Text('$qty'),
              IconButton(
                  onPressed: () => setState(() => qty++),
                  icon: Icon(Icons.add)),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CartProvider>().updateQty(widget.item.product, qty);
              Navigator.pop(context);
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }
}
