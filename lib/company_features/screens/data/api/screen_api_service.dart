import 'package:celebritysystems_mobile/company_features/screens/data/models/ticket_history_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'screen_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ScreenApiService {
  factory ScreenApiService(Dio dio) = _ScreenApiService;

  @GET('/tickets/screen/{screenId}')
  Future<List<TicketHistoryResponse>> getTicketsHistoryForScreen(
    @Path('screenId') int screenId,
  );
}
