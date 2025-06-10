import 'package:celebritysystems_mobile/core/networking/dio_factory.dart';
import 'package:celebritysystems_mobile/features/login/data/apis/login_api_service.dart';
import 'package:celebritysystems_mobile/features/login/data/repos/login_repo.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  //Dio & ApiService
  Dio dio = DioFactory.getDio();
  //login
  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  // //login
  // getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  // getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  //LazySingleton will create the obj just once.
  //Factory will create new obj everytime I need it.
  // m3 al cubit LazySingleton will throw error Cann't emit new state after state close.& you will not find (x) in cubit if it was disposed or distroyed because it was a singleton.
}
