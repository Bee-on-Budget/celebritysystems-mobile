import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:celebritysystems_mobile/features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/features/home/data/repos/ticket_repo.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final TicketRepo _ticketRepo;
  HomeCubit(this._ticketRepo) : super(HomeState.initial());

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
}
