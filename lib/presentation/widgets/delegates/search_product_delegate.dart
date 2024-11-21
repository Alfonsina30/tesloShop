import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/domain.dart';

class SearchproductDelegate extends SearchDelegate<Product?> {
  List<Product> initialProducts;
  final Future<List<Product>> Function(String) searchProductByQuery;

  SearchproductDelegate(
      {required this.initialProducts, required this.searchProductByQuery})
      : super(searchFieldLabel: 'Search products', searchFieldStyle: const TextStyle(fontSize: 18));

  ///-- use for add value result movies to streamBuilder
  StreamController<List<Product>> streamProducts = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  void clearStreams() {
    streamProducts.close();
  }

  ///--- when user do a search, _onQueryChanged add the result to the stream
  void _onQueryChanged(String term) {
    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final products = await searchProductByQuery(
          term); //function providerSearchProduct is conect with repository
      initialProducts = products;
      streamProducts.add(products);
      isLoadingStream.add(false);
    });
  }

//-- widget result show it on the screen
  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        initialData: initialProducts,
        stream: streamProducts.stream,
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: ()=> context.push('/product/${product.id}'),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(children: [
                      Flexible(
                        flex: 3,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              height: 130,
                              fit: BoxFit.cover,
                              image: NetworkImage(product.images.first),
                              placeholder: const AssetImage(
                                  'assets/loaders/bottle-loader.gif'),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //Spacer(),
                      Flexible(
                        flex: 5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: GoogleFonts.montserratAlternates()
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                              Text(
                                product.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ]),
                      )
                    ]),
                  ),
                );
              });
        });
  }

//-- widgets list for clean or cancel the search
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded));
          }

          return IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear));
        },
      ),
    ];
  }

//--come back icon
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null); //Closes the search page and returns to the underlying route.
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    ///query is a get and set of class SearchDelegate for use the _queryTextController of the search
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}
