import 'dart:convert';

import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../../../features/login/logic/user cubit/user_cubit.dart';
import '../../logic/company_home_cubit/company_home_cubit.dart';
import 'components/company_home_app_bar.dart';
import 'components/company_home_body.dart';

class CompanyHomeScreen extends StatefulWidget {
  String? selectedCompanyName;
  CompanyHomeScreen({super.key});

  static _CompanyHomeScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CompanyHomeScreenState>();
  }

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  late final int _companyId;
  late final bool _canEdit = context.read<UserCubit>().state?.canEdit ?? false;

  @override
  void initState() {
    super.initState();
    _companyId = context.read<UserCubit>().state?.companyId ?? 0;
    _initialRequests();
  }

  Future<void> _initialRequests() async {
    int subcompanyId =
        await SharedPrefHelper.getInt(SharedPrefKeys.subCompanyId);

    print("subcompanyId in initial: $subcompanyId");
    if (subcompanyId != 0) {
      print("contractsIds in initial:");

      String contractsIdsString = await SharedPrefHelper.getString(
          SharedPrefKeys.subCompanyContractsIds);

      List<int> contractsIds = jsonDecode(contractsIdsString).cast<int>();
      print("contractsIds in initial: $contractsIds");
      context.read<CompanyHomeCubit>().loadCompanyHomeData(subcompanyId);
      context
          .read<CompanyHomeCubit>()
          .loadCompanyScreensDataForSubcompany(subcompanyId, contractsIds);
      context.read<CompanyHomeCubit>().loadSubcontracts(_companyId);
    } else {
      context.read<CompanyHomeCubit>().loadCompanyHomeData(_companyId);
      context.read<CompanyHomeCubit>().loadCompanyScreensData(_companyId);
      context.read<CompanyHomeCubit>().loadSubcontracts(_companyId);
    }
  }

  Future<void> _onRefresh() async {
    int subcompanyId =
        await SharedPrefHelper.getInt(SharedPrefKeys.subCompanyId);

    print("subcompanyId in initial: $subcompanyId");
    if (subcompanyId != 0) {
      context.read<CompanyHomeCubit>().loadCompanyHomeData(subcompanyId);
    } else {
      context.read<CompanyHomeCubit>().loadCompanyHomeData(_companyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: companyHomeAppBar(
        context,
        ColorsManager.coralBlaze,
        setState,
        widget.selectedCompanyName,
        (String? newName) {
          setState(() {
            widget.selectedCompanyName = newName;
          });
        },
        _initialRequests, // Pass the _initialRequests method as callback
      ),
      body: companyHomeBody(_onRefresh),
      floatingActionButton: _canEdit
          ? FloatingActionButton(
              heroTag: 'add_ticket_button',
              onPressed: () async {
                int subcompanyId =
                    await SharedPrefHelper.getInt(SharedPrefKeys.subCompanyId);
                if (subcompanyId != 0) {
                  List<CompanyScreenModel> listOfScreensForSubcompany = context
                      .read<CompanyHomeCubit>()
                      .listOfScreensForSubcompany;

                  context.pushNamed(Routes.createCompanyTicketScreen,
                      arguments: listOfScreensForSubcompany);
                } else {
                  List<CompanyScreenModel> listOfCompanyScreen =
                      context.read<CompanyHomeCubit>().listOfCompanyScreen;

                  context.pushNamed(Routes.createCompanyTicketScreen,
                      arguments: listOfCompanyScreen);
                }
                // List<CompanyScreenModel> listOfCompanyScreen =
                //     context.read<CompanyHomeCubit>().listOfCompanyScreen;

                // context.pushNamed(Routes.createCompanyTicketScreen,
                //     arguments: listOfCompanyScreen);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
