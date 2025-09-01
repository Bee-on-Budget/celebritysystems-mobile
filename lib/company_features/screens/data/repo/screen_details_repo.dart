import 'package:celebritysystems_mobile/company_features/screens/data/api/screen_api_service.dart';
import 'package:celebritysystems_mobile/company_features/screens/data/models/ticket_history_response.dart';
import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';

class ScreenDetailsRepo {
  final ScreenApiService _screenApiService;

  ScreenDetailsRepo(this._screenApiService);

  Future<ApiResult<List<TicketHistoryResponse>>> getTicketsHistoryForScreen(
      int screenId) async {
    try {
      final List<TicketHistoryResponse> response =
          await _screenApiService.getTicketsHistoryForScreen(screenId);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
