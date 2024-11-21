import '../../config/config.dart';
import '../../infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

///-- this class return our entities instance - Product
class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) {
  
    return Product(
        id: json['id'],
        title: json['title'],
        price: double.parse(json['price'].toString()),
        description: json['description'],
        slug: json['slug'],
        stock: json['stock'],
        sizes: List<String>.from(json['sizes'].map((size) => size)),
        gender: json['gender'],
        tags: List<String>.from(json['tags'].map((tag) => tag)),
        images: List<String>.from(json['images'].map((image) {
          if (image is Map) {
            if (image['url'].toString().startsWith('/')) {
              return image['url'] as String;
            } else {
//---> images comes to API for access it we use NetWorkApi
              return '${Environment.apiUrl}/files/product/${image['url']}';
            }
          } else {
            //---> when run app is open for load all products
            if (image.toString().startsWith('/')) {
              return image;
            }

            return '${Environment.apiUrl}/files/product/$image';
          }
        })),
        user: json['user'] != null ? UserMapper.userJsonToEntity(json['user']) : null);
  }
}
