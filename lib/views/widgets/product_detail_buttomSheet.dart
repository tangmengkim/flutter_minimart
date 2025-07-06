import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/services/product_service.dart';
import 'package:ministore/dio/services/shelves_service.dart';
import 'package:ministore/views/widgets/shelf_popup_widget.dart';

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
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(product.description ?? 'No description'),
                  const SizedBox(height: 12),
                  Row(
  children: [
    Icon(Icons.location_on, size: 20, color: Colors.grey),
    const SizedBox(width: 4),
    GestureDetector(
      onTap: () async {
        final shelfProducts = await ShelvesService().getShelfById(
          product.section?.id.toString() ?? '',
        );

        showShelfPopup(
          context: context,
          currentProduct: product,
          shelfProducts: shelfProducts.products
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
