import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/domain.dart';
import '../../../presentation/provider/products/search_products_provider.dart';
import '../../../presentation/widgets/delegates/search_product_delegate.dart';
import '../../../presentation/provider/providers.dart';
import '../../../presentation/widgets/shared/shared.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
          title: Text(
            'Products',
            style: TextStyle(color: Colors.purple.shade700),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  final searchedProduct = ref.read(searchedProductsProvider);
                  final valueQueryProvider =
                      ref.read(valueSearchProvider);

                  showSearch<Product?>(
                      query: valueQueryProvider,
                      context: context,
                      delegate: SearchproductDelegate(
                          initialProducts: searchedProduct,
                          searchProductByQuery: ref
                              .read(searchedProductsProvider.notifier)
                              .searchProductByQuery));
                })
          ]),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add new product'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: ProductCard(product: product));
        },
      ),
    );
  }
}
