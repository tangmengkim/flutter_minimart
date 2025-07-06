import 'package:flutter/material.dart';
import 'package:ministore/dio/models/invoice_model.dart';
import 'package:ministore/main.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class InvoicePage extends StatelessWidget {
  final Invoice invoice;

  const InvoicePage({super.key, required this.invoice});

  void _shareInvoice(BuildContext context) {
    final invoiceText = StringBuffer()
      ..writeln('MINI STORE INVOICE')
      ..writeln('================')
      ..writeln('Invoice #: ${invoice.displayInvoiceNumber}')
      ..writeln('Date: ${_formatDate(invoice.saleDate)}')
      ..writeln('Payment Method: ${invoice.paymentMethod.toUpperCase()}')
      ..writeln('Cashier: ${invoice.cashier?.name ?? 'N/A'}')
      ..writeln('')
      ..writeln('ITEMS:')
      ..writeln('------');

    for (final item in invoice.items) {
      final productName = item.product?.name ?? 'Unknown Product';

      invoiceText.writeln(
          '${productName} x${item.quantity} @ \$${item.unitPrice.toStringAsFixed(2)} = \$${item.totalPrice.toStringAsFixed(2)}');
    }

    invoiceText
      ..writeln('')
      ..writeln('SUMMARY:')
      ..writeln('--------')
      ..writeln('Subtotal: \$${invoice.subtotal.toStringAsFixed(2)}');

    if (invoice.tax > 0) {
      invoiceText.writeln('Tax: \$${invoice.tax.toStringAsFixed(2)}');
    }

    if (invoice.discount > 0) {
      invoiceText
          .writeln('Discount: -\$${invoice.discount.toStringAsFixed(2)}');
    }

    invoiceText
      ..writeln('TOTAL: \$${invoice.total.toStringAsFixed(2)}')
      ..writeln('')
      ..writeln('Thank you for your business!')
      ..writeln('')
      ..writeln(
          'Generated on ${_formatDate(DateTime.now().toIso8601String())}');

    Share.share(invoiceText.toString());
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<RuntimeController>(
            builder: (context, themeController, _) {
              return IconButton(
                onPressed: themeController.toggleTheme,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    themeController.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    key: ValueKey(themeController.isDarkMode),
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInvoice(context),
            tooltip: 'Share Invoice',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: isDarkMode ? 4 : 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invoice Header
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Invoice #${invoice.displayInvoiceNumber}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Date: ${_formatDate(invoice.saleDate)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                ),
                                if (invoice.cashier != null)
                                  Text(
                                    'Cashier: ${invoice.cashier!.name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color
                                              ?.withOpacity(0.6),
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          // Success indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Paid',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getPaymentIcon(invoice.paymentMethod),
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Payment: ${_formatPaymentMethod(invoice.paymentMethod)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(),

                      // Items Header
                      Text(
                        'Items (${invoice.items.length})',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),

                      // Items List
                      Expanded(
                        child: invoice.items.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 48,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color
                                          ?.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No items found',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.5),
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: invoice.items.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final item = invoice.items[index];
                                  final productName =
                                      item.product?.name ?? 'Unknown Product';

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: item.product?.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              item.product!.imageUrl!,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.shopping_bag,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                    title: Text(
                                      productName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    subtitle: Text(
                                      '${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.7),
                                          ),
                                    ),
                                    trailing: Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      const Divider(),

                      // Summary Section
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal:',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                '\$${invoice.subtotal.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          if (invoice.tax > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tax:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  '\$${invoice.tax.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                          if (invoice.discount > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  '-\$${invoice.discount.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.green,
                                      ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                Text(
                                  '\$${invoice.total.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareInvoice(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Invoice'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'digital_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  String _formatPaymentMethod(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      case 'digital_wallet':
        return 'Digital Wallet';
      default:
        return paymentMethod.toUpperCase();
    }
  }
}
