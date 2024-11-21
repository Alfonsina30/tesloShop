import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../../presentation/provider/providers.dart';

//***provider 1 */
/// Initially it is an empty string that changes with the value you want to search for.
final valueSearchProvider = StateProvider<String>((ref) => '');

//***provider 2 */
/// searchedProductsProvider representacion de StateNotifier that working with ListProducts, 
/// do request to [repository] that call the[ ProductsDatasource] that do request to API, the response is Mapper and the return ProductEntites 
/// this response is return [to function searchProductByQuery]  that is use on widget screen [SearchproductDelegate]
final searchedProductsProvider =
    StateNotifierProvider<SearchedProductsNotifier, List<Product>>((ref) {
  final productsRepository = ref.read(productsRepositoryProvider);

  return SearchedProductsNotifier(
      searchProducts: productsRepository.searchProductByTerm, ref: ref);
});

class SearchedProductsNotifier extends StateNotifier<List<Product>> {
  final Future<List<Product>> Function(String) _searchProducts;
//--- is use for call update riverpod method for asign new state
  final Ref ref;

  SearchedProductsNotifier({
    required Future<List<Product>> Function(String) searchProducts,
    required this.ref,
  })  : _searchProducts = searchProducts,
        super([]);

  ///--- this function call the repository return the List query that after is use on SearchproductDelegate on Screen
  Future<List<Product>> searchProductByQuery(String term) async {
    List<Product> products = [];
    try {
      products = await _searchProducts(term); //function repository
      ref
          .read(valueSearchProvider.notifier)
          .update((state) => term); // update riverpod method asign new state

      state = products;
      return products;
    } catch (e) {
      return products;
    }
  }
}
