// Full implementation of checkout with multiple payment methods, invoice preview, and share/save option.

import 'package:flutter/material.dart';
import 'package:ministore/dio/models/sale/sale_resp_model.dart';
import 'package:ministore/provider/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'cash';
  double? _tax;
  double? _discount;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();

  void _submitCheckout(CartProvider cart) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final sale = await cart.checkoutCart(
        paymentMethod: _paymentMethod,
        tax: _tax,
        discount: _discount,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InvoicePage(sale: sale),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Total: \$${cart.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['cash', 'card', 'qr', 'bank']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tax'),
                keyboardType: TextInputType.number,
                onChanged: (val) => _tax = double.tryParse(val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
                onChanged: (val) => _discount = double.tryParse(val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitCheckout(cart),
                child: const Text('Confirm and Pay'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InvoicePage extends StatelessWidget {
  final Sale sale;

  const InvoicePage({super.key, required this.sale});

  void _shareInvoice(BuildContext context) {
    final invoiceText = StringBuffer()
      ..writeln('Invoice #${sale.invoiceNumber}')
      ..writeln('Date: ${sale.saleDate}')
      ..writeln('Total: \$${sale.total}')
      ..writeln('Payment: ${sale.paymentMethod}')
      ..writeln('--- Items ---');

    for (final item in sale.items) {
      invoiceText.writeln(
          '${item.product.name} x${item.quantity} = \$${item.totalPrice}');
    }

    Share.share(invoiceText.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInvoice(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invoice #: ${sale.invoiceNumber}',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Date: ${sale.saleDate}'),
            Text('Payment: ${sale.paymentMethod}'),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: sale.items.length,
                itemBuilder: (context, index) {
                  final item = sale.items[index];
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('${item.quantity} x \$${item.unitPrice}'),
                    trailing: Text('\$${item.totalPrice}'),
                  );
                },
              ),
            ),
            const Divider(),
            Text('Subtotal: \$${sale.subtotal}'),
            Text('Tax: \$${sale.tax}'),
            Text('Discount: \$${sale.discount}'),
            Text('Total: \$${sale.total}',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
