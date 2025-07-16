import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:celebritysystems_mobile/features/home/data/models/tickets_count.dart';
import 'package:celebritysystems_mobile/features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/features/home/data/repos/ticket_repo.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final TicketRepo _ticketRepo;
  HomeCubit(this._ticketRepo) : super(HomeState.initial());

  int assignedCount = 0;
  int completedCount = 0;

  Future<void> loadHomeData(String username) async {
    emit(Loading<List<OneTicketResponse>>());

    final ticketsResult = await _ticketRepo.getTickets(username);
    final countResult = await _ticketRepo.getTicketsCount(username);

    List<OneTicketResponse> tickets = [];
    TicketsCount? count;

    // Extract ticket data
    switch (ticketsResult) {
      case result.Success(:final data):
        tickets = data;
      case result.Failure(:final errorHandler):
        final msg =
            errorHandler.apiErrorModel.message ?? "Failed to load tickets";
        emit(Error<List<OneTicketResponse>>(error: msg));
        return;
    }

    // Extract count data
    switch (countResult) {
      case result.Success(:final data):
        count = data;
      case result.Failure(:final errorHandler):
        final msg =
            errorHandler.apiErrorModel.message ?? "Failed to load counts";
        emit(Error<List<OneTicketResponse>>(error: msg));
        return;
    }

    // Assign count values
    assignedCount = count?.assignedCount ?? 0;
    completedCount = count?.completedCount ?? 0;

    emit(Success<List<OneTicketResponse>>(tickets));
  }
}
