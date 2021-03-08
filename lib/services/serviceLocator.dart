
import 'package:get_it/get_it.dart';
import 'package:museumora/services/moduleServices/authentication_service.dart';
import 'package:museumora/services/moduleServices/local_storage_service.dart';
import 'package:museumora/services/moduleServices/userServices.dart';

GetIt use = GetIt.instance;

Future<void> servicesSetup() async {
  // LocalStorageService localStorageService =
  //     await LocalStorageService.getInstance();

  // use.registerSingleton<LocalStorageService>(localStorageService);

  use.registerSingleton<UserService>(UserService());

  use.registerFactory<AuthenticationService>(() => AuthenticationService());
}
