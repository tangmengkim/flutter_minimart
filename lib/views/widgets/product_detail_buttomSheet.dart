import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/views/widgets/section_popup_widget.dart';

void showProductDetailBottomSheet({
  required BuildContext context,
  required Product product,
  int initialQty = 1,
  required void Function(int newQty) onQuantityChanged,
  bool isUpdate = false,
}) {
  int quantity = initialQty;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (context, setState) {
            final isOut = product.isOutOfStock == true;
            final isLow = product.isLowStock == true;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: product.imageUrl != null
                            ? NetworkImage(product.imageUrl!)
                            : const AssetImage('assets/images/product_icon.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text('\$${product.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.green)),
                            if (product.barcode != null)
                              Text("Barcode: ${product.barcode}",
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (product.description?.isNotEmpty == true)
                    Text(product.description!)
                  else
                    const Text("No description available"),
                  const SizedBox(height: 12),

                  /// Stock info
                  Row(
                    children: [
                      Icon(Icons.inventory_2, size: 20, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Stock: ${product.stockQuantity} (Min: ${product.minStockLevel})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      if (isLow)
                        const Chip(
                          label: Text("Low Stock"),
                          backgroundColor: Colors.orange,
                          visualDensity: VisualDensity.compact,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      if (isOut)
                        const Chip(
                          label: Text("Out of Stock"),
                          backgroundColor: Colors.red,
                          visualDensity: VisualDensity.compact,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// Category + Location
                  if (product.category != null)
                    Row(
                      children: [
                        Icon(Icons.category, size: 20, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(product.category!.name,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  const SizedBox(height: 8),

                  /// Location clickable
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.grey),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () async {
                          showSectionPopup(
                            context: context,
                            currentProduct: product,
                          );
                        },
                        child: Text(
                          '${product.section?.name ?? "Unknown Section"} > ${product.shelf?.name ?? "Unknown Shelf"}',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Quantity picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity',
                          style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          Text(quantity.toString(),
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => quantity++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(isUpdate ? 'Update Quantity' : 'Add to Cart'),
                      onPressed: () {
                        onQuantityChanged(quantity);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isUpdate
                                  ? '${product.name} updated to x$quantity'
                                  : '${product.name} added x$quantity to cart',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
