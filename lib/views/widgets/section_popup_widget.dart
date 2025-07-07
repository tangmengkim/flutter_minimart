import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/services/section_service.dart';

void showSectionPopup({
  required BuildContext context,
  required Product currentProduct,
}) async {
  final sectionId = currentProduct.section?.id;
  if (sectionId == null) return;

  // Fetch section detail (includes shelves and products)
  final sectionDetailResp =
      await SectionService().getSectionById(sectionId.toString());
  final section = sectionDetailResp.section;

  // Group products by shelf ID
  final productsByShelfId = <int, List<Product>>{};
  for (var product in section.products) {
    final shelfId = product.shelf?.id;
    if (shelfId != null) {
      productsByShelfId.putIfAbsent(shelfId, () => []).add(product);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Section: ${currentProduct.section?.name ?? "-"}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...section.shelves.map((shelf) {
                final shelfProducts = productsByShelfId[shelf.id] ?? [];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shelf.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/shelf_row.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: shelfProducts.isEmpty
                            ? const Center(
                                child: Text(
                                  "No products on this shelf",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8),
                                itemCount: shelfProducts.length,
                                itemBuilder: (context, index) {
                                  final product = shelfProducts[index];
                                  final isCurrent =
                                      product.id == currentProduct.id;
                                  final imageUrl = product.imageUrl ?? '';

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SizedBox(
                                      width: 70,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: imageUrl.isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl: imageUrl,
                                                        placeholder:
                                                            (context, url) =>
                                                                const SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                                'assets/images/product_icon.png',
                                                                width: 50,
                                                                height: 50),
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/product_icon.png',
                                                        width: 50,
                                                        height: 50),
                                              ),
                                              if (isCurrent)
                                                const Icon(Icons.star,
                                                    color: Colors.amber,
                                                    size: 16),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.name,
                                            style:
                                                const TextStyle(fontSize: 10),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    },
  );
}
