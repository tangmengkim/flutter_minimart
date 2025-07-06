import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/main.dart';
import 'package:ministore/provider/cart_provider.dart';
import 'package:ministore/provider/product_provider.dart';
import 'package:ministore/route_page.dart';
import 'package:ministore/util/data.dart';
import 'package:ministore/views/widgets/customTextField.dart';
import 'package:ministore/views/widgets/product_detail_buttomSheet.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Wait for the widget to mount, then fetch products
    Future.microtask(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.fetchProducts();
    });
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();
    if (!_scrollController.hasClients ||
        provider.isFetchingMore ||
        !provider.hasMore) {
      return;
    }

    final thresholdPixels = 50;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - thresholdPixels) {
      print("=========>");
      provider.fetchMoreProducts();
    }
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    print("======>");
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("========>didchange");
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPersistentHeader(
            // pinned: true,
            // floating: true,
            delegate: _SubAppBarDelegate(
              minHeight: 260,
              maxHeight: 260,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: AssetImage('assets/images/mart_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShelf(),
                    _buildShelf(),
                    _buildShelf(),
                  ],
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SubAppBarDelegate(
              minHeight: 86,
              maxHeight: 86,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                alignment: Alignment.centerLeft,
                // padding: EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            provider.searchController,
                            'Search Products',
                            keyboardType: TextInputType.text,
                            prefixIcon: Icon(Icons.search),
                            onChanged: (value) {
                              provider.setSearch(value);
                            },
                          ),
                        ),
                        GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, pageProductForm),
                            child: Icon(
                              Icons.add_to_photos,
                              size: 40,
                              color: Theme.of(context).colorScheme.secondary,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              if (provider.loading) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return SliverList(
                  key: GlobalKey(),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == provider.products.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = provider.products[index];
                      return _buildProductItem(context, product);
                    },
                    childCount: provider.products.length +
                        (provider.isFetchingMore ? 1 : 0),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
      toolbarHeight: 60,
      expandedHeight: 60,
      // floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Mini Store'),
      ),
      actions: [
        // Dark Mode Toggle Button
        Consumer<RuntimeController>(
          builder: (context, themeController, _) {
            return IconButton.outlined(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  key: ValueKey(themeController.isDarkMode),
                ),
              ),
              tooltip: themeController.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            );
          },
        ),
        // Profile/Login Button
        IconButton.outlined(
            onPressed: () async {
              print('Cart button pressed');
              var isLogin = await Data().get<bool>(DataKeys.isUserAuth);
              print('isLogin: $isLogin');
              isLogin == true
                  ? Navigator.pushNamed(context, pageProfile)
                  : Navigator.pushNamed(context, loginPageRoute);
            },
            icon: Icon(Icons.person))
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return Slidable(
      key: ValueKey(product.id),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Product'),
              content:
                  Text('Are you sure you want to delete "${product.name}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            // Get provider before await
            final productProvider =
                Provider.of<ProductProvider>(context, listen: false);

            await productProvider.deleteProduct(product.id.toString());

            // Check if widget is still mounted before using context
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} deleted')),
              );
            }
          }
        }),
        children: [
          SlidableAction(
            spacing: 10,
            onPressed: (_) => Navigator.pushNamed(
              context,
              pageProductForm,
              arguments: product,
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            spacing: 10,
            onPressed: (_) async {
              final provider =
                  Provider.of<ProductProvider>(context, listen: false);

              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Delete Product'),
                  content: Text(
                      'Are you sure you want to delete "${product.name}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await provider.deleteProduct(product.id.toString());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} deleted')),
                  );
                }
              }
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          final cart = context.read<CartProvider>();
          final isInCart =
              cart.items.any((item) => item.product.id == product.id);
          final existingQty = isInCart
              ? cart.items
                  .firstWhere((item) => item.product.id == product.id)
                  .quantity
              : 1;

          showProductDetailBottomSheet(
            context: context,
            product: product,
            initialQty: existingQty,
            isUpdate: isInCart,
            onQuantityChanged: (qty) {
              if (isInCart) {
                cart.updateQty(product, qty);
              } else {
                cart.addToCartWithQty(product, qty);
              }
            },
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListTile(
              leading: CachedNetworkImage(
                key: Key(product.id.toString()),
                useOldImageOnUrlChange: true,
                imageUrl: product.imageUrl ?? '',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/product_icon.png'),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: GestureDetector(
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildShelf() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(-20, -10),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/shelf_no_background.png',
        fit: BoxFit.fitHeight,
        width: 150,
      ),
    );
  }
}

class _SubAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SubAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SubAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
