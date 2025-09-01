import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/company_features/home/logic/company_home_cubit/company_home_state.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../home/logic/company_home_cubit/company_home_cubit.dart';
import 'screen_details.dart';

class ScreenPage extends StatefulWidget {
  final int companyId;
  const ScreenPage({super.key, required this.companyId});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  // late final int _companyId;

  // List<CompanyScreenModel> listOfCompanyScreen = [];

  @override
  void initState() {
    super.initState();
    // _companyId = context.read<UserCubit>().state?.companyId ?? 0;
    context.read<CompanyHomeCubit>().loadCompanyScreensData(widget.companyId);

    // _loadCompanyScreens();
  }

  // Future<void> _loadCompanyScreens() async {
  //   int companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);
  //   if (!mounted) return; // ✅ ensures widget is still in the tree
  //   context.read<CompanyHomeCubit>().loadCompanyScreensData(companyId);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
      builder: (context, state) {
        if (state is Error) {
          return Center(
            child: Text("Error"),
          );
        } else if (state is Loading) {
          return Center(
            child: Text("Loading"),
          );
        } else if (state is Success) {
          final List<CompanyScreenModel> screens = state.data;
          return Scaffold(
            backgroundColor: ColorsManager.mistWhite,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorsManager.royalIndigo,
                      ColorsManager.coralBlaze,
                    ],
                  ),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.screenshot_monitor_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Screen Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                // Cards list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<CompanyHomeCubit>()
                          .loadCompanyScreensData(widget.companyId);
                    },
                    child: screens.isEmpty
                        ? ListView(
                            // RefreshIndicator requires a scrollable child
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    300, // ensure enough space to allow pull-down gesture
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No Screens Here!",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            // physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: screens.length,
                            itemBuilder: (context, index) {
                              final company = screens[
                                  index]; //Todo change the name for screen

                              return Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: Card(
                                  elevation: 4,
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                          Routes.screenDetailsHistory,
                                          arguments: company);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 20),

                                            // Card content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    company.name ?? 'No Name',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorsManager
                                                          .graphiteBlack,
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  if (company.screenType !=
                                                      null)
                                                    _buildInfoRow(
                                                      Icons.category_rounded,
                                                      company.screenType!,
                                                      false,
                                                    ),
                                                  if (company.location != null)
                                                    _buildInfoRow(
                                                      Icons.location_on_rounded,
                                                      company.location!,
                                                      false,
                                                    ),
                                                  if (company.solutionType !=
                                                      null)
                                                    _buildInfoRow(
                                                      Icons.settings_rounded,
                                                      company.solutionType!,
                                                      false,
                                                    ),
                                                  if (company.id != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8),
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorsManager
                                                              .paleLavenderBlue
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          'ID: ${company.id}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: ColorsManager
                                                                .slateGray,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Text("No State"),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? ColorsManager.royalIndigo.withOpacity(0.7)
                : ColorsManager.slateGray,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? ColorsManager.royalIndigo.withOpacity(0.8)
                    : ColorsManager.slateGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
