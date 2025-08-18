import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../api/company_tickets_api_service.dart';
import '../models/company_tickets_response.dart';

class CompanyTicketRepo {
  final CompanyTicketsApiService _companyTicketApiService;

  CompanyTicketRepo(this._companyTicketApiService);

  Future<ApiResult<List<CompanyTicketResponse>>> getCompanyTickets(
      int companyId) async {
    try {
      final List<CompanyTicketResponse> response =
          await _companyTicketApiService.getCompanyTickets(companyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<CompanyTicketResponse>> getTicketById(int ticketId) async {
    try {
      final CompanyTicketResponse response =
          await _companyTicketApiService.getTicket(ticketId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> putTicket(CompanyTicketResponse ticket) async {
    try {
      await _companyTicketApiService.putTicket(ticket);
      return const ApiResult.success(null);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
