import 'package:celebritysystems_mobile/company_features/show_contract/data/model/contract_response.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/data/repo/contract_repo.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/logic/contract_cubit/contract_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart' as result;

class ContractCubit extends Cubit<ContractState> {
  final ContractRepo _contractRepo;
  ContractCubit(this._contractRepo) : super(ContractState.initial());

  Future<void> getContracts(int companyId) async {
    emit(const ContractState.loading());

    final result.ApiResult<List<Contract>> contractResult =
        await _contractRepo.getContracts(companyId);

    switch (contractResult) {
      case result.Success(:final data):
        emit(ContractState.success(data));
        break;
      case result.Failure(:final errorHandler):
        print("We have Failure");
        final msg =
            errorHandler.apiErrorModel.message ?? "Failed to get contracts";
        emit(ContractState.error(error: msg));
        break;
    }
  }

  void resetState() {
    emit(const ContractState.initial());
  }
}
