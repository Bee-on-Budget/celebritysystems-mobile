import 'package:celebritysystems_mobile/company_features/company_profile/data/model/company_model.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_cubit.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_state.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/error_widget.dart';
import 'package:celebritysystems_mobile/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailsScreen extends StatefulWidget {
  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadCompanyProfile();
  }

  Future<void> _loadCompanyProfile() async {
    int subcompanyId =
        await SharedPrefHelper.getInt(SharedPrefKeys.subCompanyId);
    int companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);
    if (!mounted) return; // ✅ ensures widget is still in the tree
    if (subcompanyId != 0) {
      context.read<ProfileCubit>().getCompanyProfile(subcompanyId);
    } else {
      context.read<ProfileCubit>().getCompanyProfile(companyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is Loading) {
          return customLoadingWidget("loading_profile".tr());
        } else if (state is Error) {
          return customErrorWidget(state);
        } else if (state is Success<CompanyModel>) {
          final company = state.data;

          return Scaffold(
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  heroTag: 'explore_contracts_button',
                  onPressed: () {
                    context.pushNamed(Routes.contractScreen);
                  },
                  label: Text(
                    'explore_contracts'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  icon: Icon(
                    Icons.pages,
                    size: 24,
                  ),
                  backgroundColor: ColorsManager.royalIndigo,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              backgroundColor: ColorsManager.mistWhite,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                // toolbarHeight: 80.h,
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
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'company_details'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: CompanyCard(company: company),
                ),
              ));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class CompanyCard extends StatelessWidget {
  final CompanyModel company;

  const CompanyCard({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header
            Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: company.activated
                        ? ColorsManager.mistWhite
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(27.5.r),
                  ),
                  child: Icon(
                    Icons.business,
                    color: company.activated
                        ? ColorsManager.coralBlaze
                        : Colors.grey[600],
                    size: 28.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              company.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: company.activated
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              company.activated
                                  ? 'active'.tr()
                                  : 'inactive'.tr(),
                              style: TextStyle(
                                color: company.activated
                                    ? Colors.green[600]
                                    : Colors.red[600],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${company.userList.length} ${'users'.tr()}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Company Details
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                children: [
                  _buildDetailRow(Icons.phone, 'phone'.tr(), company.phone),
                  SizedBox(height: 16.h),
                  _buildDetailRow(Icons.email, 'email'.tr(), company.email),
                  SizedBox(height: 16.h),
                  _buildDetailUrlRow(
                      Icons.location_on, 'location'.tr(), company.location),
                  SizedBox(height: 24.h),
                  // Users Section Header
                  Row(
                    children: [
                      Icon(Icons.people,
                          color: ColorsManager.royalIndigo, size: 20.r),
                      SizedBox(width: 8.w),
                      Text(
                        '${'users'.tr()}(${company.userList.length})',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Users List
            Container(
              height: 0.45.sh, // 45% of screen height for better responsiveness
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: company.userList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48.r,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'no_users_found'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(12.r),
                      itemCount: company.userList.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        return UserTile(user: company.userList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorsManager.royalIndigo, size: 18.r),
        SizedBox(width: 12.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 14.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: ColorsManager.graphiteBlack,
              fontSize: 14.sp,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailUrlRow(IconData icon, String label, String url) {
    final uri = Uri.tryParse(url);
    final isValid =
        uri != null && (uri.isScheme("http") || uri.isScheme("https"));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorsManager.royalIndigo, size: 18.r),
        SizedBox(width: 12.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 14.sp,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (isValid && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("Invalid or unlaunchable URL: $url");
              }
            },
            child: Text(
              'View the location Maps',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: ColorsManager.royalIndigo,
            child: Text(
              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            children: [
              _buildPermissionBadge('read'.tr(), user.canRead),
              SizedBox(height: 6.h),
              _buildPermissionBadge('edit'.tr(), user.canEdit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionBadge(String label, bool hasPermission) {
    return Container(
      height: 22.h,
      width: 45.w,
      decoration: BoxDecoration(
        color: hasPermission ? Colors.green[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: hasPermission ? Colors.green[700] : Colors.grey[600],
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
