import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/apis/ticket_api_service.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_count.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';

class TicketRepo {
  final TicketApiService _ticketApiService;

  TicketRepo(this._ticketApiService);

  Future<ApiResult<List<OneTicketResponse>>> getTickets(String username) async {
    try {
      final List<OneTicketResponse> respone =
          await _ticketApiService.getTickets(username);

      print("in repo try respone is " + respone.toString());
      return ApiResult.success(respone);
    } catch (error) {
      print("in repo catch error is " + error.toString());
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<TicketsCount>> getTicketsCount(String username) async {
    try {
      final TicketsCount respone =
          await _ticketApiService.getTicketsCount(username);

      print("in repo try respone is " + respone.toString());
      return ApiResult.success(respone);
    } catch (error) {
      print("in repo catch error is " + error.toString());
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
