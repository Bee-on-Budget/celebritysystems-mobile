import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_cubit.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/ui/company_profile.dart';
import 'package:celebritysystems_mobile/company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import 'package:celebritysystems_mobile/company_features/home/ui/home_screen/company_home_screen.dart';
import 'package:celebritysystems_mobile/company_features/reports/ui/report_screen.dart';
import 'package:celebritysystems_mobile/company_features/screens/ui/screen_page.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/features/login/logic/user cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  late final int _companyId;
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _companyId = context.read<UserCubit>().state?.companyId ?? 0;

    // Initialize screens list
    _screens.addAll([
      CompanyHomeScreen(),
      ScreenPage(
        companyId: _companyId,
      ),
      ReportScreen(),
      BlocProvider(
        create: (context) => ProfileCubit(getIt()),
        child: CompanyDetailsScreen(),
      ),
      // const TicketsSection(),
      // const ScreensSection(),
    ]);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Load company screens data when dependencies are available
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       context.read<CompanyHomeCubit>().loadCompanyScreensData(4);
  //     }
  //   });
  // }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // BlocProvider(
        //   create: (context) => getIt<CompanyHomeCubit>(),
        //   child:
        Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: ColorsManager.coralBlaze,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.screen_share),
            label: 'Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Company',
          ),
        ],
      ),
    );
    // );
  }
}


// //floatingActionButton: _currentIndex == 0
//         //     ? FloatingActionButton(
//         //         onPressed: () {
//         //           final companyScreens =
//         //               context.read<CompanyHomeCubit>().listOfCompanyScreen;
//         //           context.pushNamed(Routes.createCompanyTicketScreen,
//         //               arguments: companyScreens);
//         //         },
//         //         backgroundColor: ColorsManager.coralBlaze,
//         //         child: const Icon(Icons.add, color: Colors.white),
//         //       )
//         //     : null,