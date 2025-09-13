import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_count.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'ticket_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class TicketApiService {
  factory TicketApiService(Dio dio) = _TicketApiService;

  @GET('${ApiConstants.workerTickets}/{username}')
  Future<List<OneTicketResponse>> getTickets(@Path('username') String username);

  @GET('${ApiConstants.workerTickets}/{username}/count')
  Future<TicketsCount> getTicketsCount(@Path('username') String username);

  @GET('tickets/{id}/image/download')
  Future<String> downloadImage(@Path('id') int ticketId);
}
