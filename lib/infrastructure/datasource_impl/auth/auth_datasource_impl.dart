import 'package:dio/dio.dart';

import '../../../config/config.dart';
import '../../../domain/domain.dart';
import '../../infrastructure.dart';

// 192.168.1.110

//-- User authentication, call API
class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
   /// connectTimeout: Duration(minutes: 1),
    //receiveTimeout: Duration(minutes: 1)
  ));

  @override
  ///---> the provider AuthNotifier call this function for request API
  ///  and send the token that was saved on device
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        /// --> this error is handle on AuthProvider
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  ///---> Do request API, Mapper the response and return User instance
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  ///---> Do request API, Mapper the response and return User instance
  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register',
          data: {'email': email, 'password': password, 'fullName': fullName});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
