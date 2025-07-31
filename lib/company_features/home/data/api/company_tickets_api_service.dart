import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';
import '../models/company_tickets_response.dart';

part 'company_tickets_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class CompanyTicketsApiService {
  factory CompanyTicketsApiService(Dio dio) = _CompanyTicketsApiService;

  @GET('${ApiConstants.companyTickets}/{companyId}')
  Future<List<CompanyTicketResponse>> getCompanyTickets(
    @Path('companyId') int companyId,
  );

  @GET('${ApiConstants.tickets}/{ticketId}')
  Future<CompanyTicketResponse> getTicket(
    @Path('ticketId') int ticketId,
  );

  @PUT(ApiConstants.tickets)
  Future<CompanyTicketResponse> putTicket(
    @Body() CompanyTicketResponse ticket,
  );
}
