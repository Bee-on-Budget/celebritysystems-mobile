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

  void getHomeTickets(String username) async {
    emit(HomeState.loading());

    print("I Am before getHomeTickets request");
    final result.ApiResult<List<OneTicketResponse>> response =
        await _ticketRepo.getTickets(username);

    print("I Am after getHomeTickets request");

    print("response IS : " + response.toString());
    print(response);

    switch (response) {
      case result.Success(:final data):
        print(
            "WE HAVE SUCCESS RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        emit(HomeState.success(data));

      case result.Failure(:final errorHandler):
        print(
            "WE HAVE ERROR RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        emit(HomeState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }

  void getTicketsCount(String username) async {
    emit(HomeState.loading());

    print("I Am before getTicketsCount request");
    final result.ApiResult<TicketsCount> response =
        await _ticketRepo.getTicketsCount(username);

    print("I Am after getTicketsCount request");

    print("response IS : " + response.toString());
    print(response);

    switch (response) {
      case result.Success(:final data):
        assignedCount = data.assignedCount!;
        completedCount = data.completedCount!;
        print(
            "WE HAVE SUCCESS RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        emit(HomeState.success(data));

      case result.Failure(:final errorHandler):
        print(
            "WE HAVE ERROR RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        emit(HomeState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }
}
