import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
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

    final printList =
        context.read<CompanyHomeCubit>().loadcompanyScreensData(_companyId);

    print("****************************************************");
    print(printList);
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
        onPressed: () {
          Navigator.pushNamed(context, Routes.createCompanyTicketScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
