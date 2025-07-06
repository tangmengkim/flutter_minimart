import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';

void showShelfPopup({
  required BuildContext context,
  required Product currentProduct,
  required List<Product> shelfProducts, // all products in that shelf
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shelf View: ${currentProduct.section?.name} > ${currentProduct.shelf?.name}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              // Shelf view (3 rows)
              Column(
                children: List.generate(3, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/shelf_row.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: shelfProducts
                            .where((p) => p.shelf?.level == rowIndex + 1)
                            .map((product) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              product.imageUrl != null
                                                  ? NetworkImage(product.imageUrl!)
                                                  : const AssetImage('assets/images/product_icon.png')
                                                      as ImageProvider,
                                        ),
                                        if (product.id == currentProduct.id)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.star,
                                                color: Colors.amber),
                                          ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    },
  );
}
