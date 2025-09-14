import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/company_features/home/data/models/subcontract_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';
import '../models/company.dart';

part 'subcontract_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class SubcontractApiService {
  factory SubcontractApiService(Dio dio) = _SubcontractApiService;

  @GET('subcontract/controller-company/{controllerCompanyId}')
  Future<List<SubcontractResponse>> getSubcontractsByCompanyId(
    @Path('controllerCompanyId') int controllerCompanyId,
  );
}
