import 'package:celebritysystems_mobile/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'create_ticket_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class CreateTicketApiService {
  factory CreateTicketApiService(Dio dio) = _CreateTicketApiService;

  @POST('/tickets')
  Future<void> createTicket(
    @Body() FormData formData,
    @DioOptions() Options? options, // Add options parameter
  );
}
