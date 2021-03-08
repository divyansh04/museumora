import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:museumora/services/moduleServices/userServices.dart';
import 'package:museumora/services/serviceLocator.dart';
class NetworkInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(RequestOptions options) async {
    String endpoint = options.path;
    print("Request: $endpoint\n<-- ${options.data}");
    // print("<-- ${options.queryParameters}");
    final user = use.get<UserService>().user;
    if (user != null) {
      IdTokenResult authToken = await user.getIdTokenResult();
      options.headers['AUTH_TOKEN'] = authToken.token;
    }
    return options;
  }

  @override
  Future<dynamic> onError(DioError dioError) async {
    String endpoint = dioError.request.path;
    print("Error at endpoint: $endpoint\n<-- $dioError");
    return dioError;
  }

  @override
  Future<dynamic> onResponse(Response response) async {
    print("Response: \n<-- $response");
    return response;
  }
}
