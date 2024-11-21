import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/domain.dart';
import 'products_repository_provider.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }

///---- the state of [ProductFormProvider] is send to [createOrUpdateProduct] because if user add new images with the camera or gallery device or modify the information of product need it to do request to API
/// After to do the request to API The state of ProductsNotifier is update and show it on the screen
  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      
      final isProductInList =
          state.products.any((element) => element.id == product.id);

      if (!isProductInList) {
        state = state.copyWith(products: [...state.products, product]);
        return true;
      }

      state = state.copyWith(
          products: state.products
              .map(
                (element) => (element.id == product.id) ? product : element,
              )
              .toList());
      return true;
    } catch (e) {
      return false;
    }
  }

  ///--> carga al inicio de la app and it use for show list of all Products
  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}


///---> ProductState its use for loading products with the app is started and create new products in the api
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
