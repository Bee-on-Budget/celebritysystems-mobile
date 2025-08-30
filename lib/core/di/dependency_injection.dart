import 'package:celebritysystems_mobile/company_features/company_profile/data/api/profile_api_service.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/data/repo/profile_repo.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_cubit.dart';
import 'package:celebritysystems_mobile/company_features/home/data/api/company_api_service.dart';
import 'package:celebritysystems_mobile/company_features/home/data/api/company_tickets_api_service.dart';
import 'package:celebritysystems_mobile/company_features/home/data/repos/company_repo.dart';
import 'package:celebritysystems_mobile/company_features/home/data/repos/company_ticket_repo.dart';
import 'package:celebritysystems_mobile/company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/api/report_api_service.dart'
    as company_report;
import 'package:celebritysystems_mobile/company_features/reports/data/repos/report_repo.dart'
    as company_report_repo;
import 'package:celebritysystems_mobile/company_features/reports/logic/cubit/report_cubit.dart'
    as company_report_cubit;
import 'package:celebritysystems_mobile/company_features/show_contract/data/api/contract_api_service.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/data/repo/contract_repo.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/logic/contract_cubit/contract_cubit.dart';
import 'package:celebritysystems_mobile/core/networking/dio_factory.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/apis/ticket_api_service.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/repos/ticket_repo.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/features/login/data/apis/login_api_service.dart';
import 'package:celebritysystems_mobile/features/login/data/repos/login_repo.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/repos/report_repo.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../company_features/create_company_ticket/data/api/create_ticket_api_service.dart';
import '../../company_features/create_company_ticket/data/repo/create_ticket_repo.dart';
import '../../company_features/create_company_ticket/logic/cubit/create_ticket_cubit.dart';
import '../../worker features/report/data/apis/report_api_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  //Dio & ApiService
  Dio dio = DioFactory.getDio();
  //login
  getIt.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  //home
  getIt.registerLazySingleton<TicketApiService>(() => TicketApiService(dio));
  getIt.registerLazySingleton<TicketRepo>(() => TicketRepo(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  //report
  getIt.registerLazySingleton<ReportApiService>(() => ReportApiService(dio));
  getIt.registerLazySingleton<ReportRepo>(() => ReportRepo(getIt()));
  getIt.registerFactory<ReportCubit>(() => ReportCubit(getIt()));

  //Company
  getIt.registerLazySingleton<CompanyTicketsApiService>(
      () => CompanyTicketsApiService(dio));
  getIt.registerLazySingleton<CompanyApiService>(() => CompanyApiService(dio));
  getIt.registerLazySingleton<CompanyTicketRepo>(
      () => CompanyTicketRepo(getIt()));
  getIt.registerLazySingleton<CompanyRepo>(() => CompanyRepo(getIt()));
  getIt.registerFactory<CompanyHomeCubit>(() => CompanyHomeCubit(
        companyRepo: getIt(),
        companyTicketRepo: getIt(),
      ));

  //CreateTicket
  getIt.registerLazySingleton<CreateTicketApiService>(
      () => CreateTicketApiService(dio));
  getIt
      .registerLazySingleton<CreateTicketRepo>(() => CreateTicketRepo(getIt()));
  getIt.registerFactory<CreateTicketCubit>(() => CreateTicketCubit(getIt()));

  //Company Report
  getIt.registerLazySingleton<company_report.ReportApiService>(
      () => company_report.ReportApiService(dio));
  getIt.registerLazySingleton<company_report_repo.ReportRepo>(
      () => company_report_repo.ReportRepo(getIt()));
  getIt.registerFactory<company_report_cubit.ReportCubit>(
      () => company_report_cubit.ReportCubit(reportRepo: getIt()));

  //company profile
  getIt.registerLazySingleton<ProfileApiService>(() => ProfileApiService(dio));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));

  //contracts Info
  getIt
      .registerLazySingleton<ContractApiService>(() => ContractApiService(dio));
  getIt.registerLazySingleton<ContractRepo>(() => ContractRepo(getIt()));
  getIt.registerFactory<ContractCubit>(() => ContractCubit(getIt()));

  //LazySingleton will create the obj just once.
  //Factory will create new obj everytime I need it.
  // m3 al cubit LazySingleton will throw error Cann't emit new state after state close.& you will not find (x) in cubit if it was disposed or distroyed because it was a singleton.
}
