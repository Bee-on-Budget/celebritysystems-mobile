import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../../../features/login/logic/user cubit/user_cubit.dart';
import '../../logic/company_home_cubit/company_home_cubit.dart';
import 'components/company_home_app_bar.dart';
import 'components/company_home_body.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  late final int _companyId;

  @override
  void initState() {
    super.initState();

    _companyId = context.read<UserCubit>().state?.companyId ?? 0;
    context.read<CompanyHomeCubit>().loadCompanyHomeData(_companyId);

    // final printList =
    context.read<CompanyHomeCubit>().loadCompanyScreensData(_companyId); //TODO

    // print("****************************************************");
    // print(printList);
    // print("listOfCompanyScreen");
  }

  Future<void> _onRefresh() async {
    context.read<CompanyHomeCubit>().loadCompanyHomeData(_companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: companyHomeAppBar(
        context,
        ColorsManager.coralBlaze,
      ),
      body: companyHomeBody(_onRefresh),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_ticket_button',
        onPressed: () {
          List<CompanyScreenModel> listOfCompanyScreen =
              context.read<CompanyHomeCubit>().listOfCompanyScreen;

          context.pushNamed(Routes.createCompanyTicketScreen,
              arguments: listOfCompanyScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
