import 'package:celebritysystems_mobile/features/home/data/models/tickets_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'ticket_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class TicketApiService {
  factory TicketApiService(Dio dio) = _TicketApiService;

  @GET('${ApiConstants.workerTickets}/{username}')
  Future<List<OneTicketResponse>> getTickets(@Path('username') String username);
}
