import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/domain.dart';
import '../../../../presentation/provider/auth/auth_provider.dart';
import '../../../infrastructure/datasource_impl/products/products_datasource_impl.dart';
import '../../../infrastructure/repository_impl/product/products_repository_impl.dart';


  /// take of authProvider bearer Token for send to ProductsDatasourceImpl because its required access token for do a request API with Dio
 
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  
  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(accessToken: accessToken )
  );

  return productsRepository;
});

