import 'package:dio/dio.dart';

import '../../../config/config.dart';
import '../../../domain/domain.dart';
import '../../errors/product_errors.dart';
import '../../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  /// ProductsDatasourceImpl required access token for do a request API with Dio
  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  ///--> create file, send to API and received the json response
  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
//--> create file to send to request api
      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: fileName)});

      final response = await dio.post('/files/product', data: data);

      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  ///--> List of current images + images was added to API
  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload =
        photos.where((element) => element.contains('/')).toList();
    final photosToIgnore =
        photos.where((element) => !element.contains('/')).toList();

//--- crear una serie de Futures de carga de imágenes
    final List<Future<String>> uploadJob =
        photosToUpload.map(_uploadFile).toList();

//--> call to api and return only the image name of [photosToUpload]
    final newImages = await Future.wait(uploadJob);
    return [...photosToIgnore, ...newImages];
  }

//---> when user do tap on FloatingButton on ProductScreen is modify the FormState that is send to createUpdateProduct
//--> for do request to api for load images files to API, after that do another request API
//--> For load all information of products(title, price, images)
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';

      //-- post method dont need product id / path method need it
      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id');
      final productLi = await _uploadPhotos(productLike['images']);

      productLike['images'] = productLi;
      final response = await dio.request(url,
          data: productLike, options: Options(method: method));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  ///--> is conect with Product Provider that is show on the [ProductScreen]
  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  ///---> is use when app is open --
  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) async {
    final List<Product> productsList = [];
    try {
      if (term.isNotEmpty) {
        final response = await dio.get<List>('/products/all/$term');
        for (final product in response.data ?? []) {
          final Product products = ProductMapper.jsonToEntity(product);

          productsList.add(products);
        }
      }

      return productsList;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
