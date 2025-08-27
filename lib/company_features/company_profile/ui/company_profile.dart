import 'package:celebritysystems_mobile/company_features/company_profile/data/model/company_model.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_cubit.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_state.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Company {
//   final String name;
//   final String phone;
//   final String email;
//   final String location;
//   final bool activated;
//   final List<User> userList;

//   Company({
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.location,
//     required this.activated,
//     required this.userList,
//   });
// }

// class User {
//   final int id;
//   final String email;
//   final String username;
//   final String fullName;
//   final bool canRead;
//   final bool canEdit;

//   User({
//     required this.id,
//     required this.email,
//     required this.username,
//     required this.fullName,
//     required this.canRead,
//     required this.canEdit,
//   });
// }

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
    int companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);
    if (!mounted) return; // ✅ ensures widget is still in the tree
    context.read<ProfileCubit>().getCompanyProfile(companyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is Loading) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorsManager.mistWhite,
                  ColorsManager.royalIndigo.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        } else if (state is Error) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorsManager.coralBlaze,
                  Colors.red.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    state.error,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is Success<CompanyModel>) {
          final company = state.data;

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
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Company Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              body: CompanyCard(company: company)
              // ListView.builder(
              //   padding: EdgeInsets.all(16),
              //   itemCount: companies.length,
              //   itemBuilder: (context, index) {
              //     return CompanyCard(company: companies[index]);
              //   },
              // ),
              );
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
    return SizedBox(
      height: 650.h,
      child: Card(
        // color: ColorsManager.mistWhite,
        margin: EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: company.activated
                          ? ColorsManager.mistWhite
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.business,
                      color: company.activated
                          ? ColorsManager.coralBlaze
                          : Colors.grey[600],
                      size: 28.r,
                    ),
                  ),
                  SizedBox(width: 16),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: company.activated
                                    ? ColorsManager.mistWhite
                                    : Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                company.activated ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: company.activated
                                      ? Colors.green[400]
                                      : Colors.red[700],
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${company.userList.length} users',
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
              SizedBox(height: 20.h),
              // Company Details
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.phone, 'Phone', company.phone),
                    SizedBox(height: 12.h),
                    _buildDetailRow(Icons.email, 'Email', company.email),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                        Icons.location_on, 'Location', company.location),
                    SizedBox(height: 20.h),
                    // Users Section
                    Row(
                      children: [
                        Icon(Icons.people,
                            color: ColorsManager.royalIndigo, size: 20.r),
                        SizedBox(width: 8.w),
                        Text(
                          'Users (${company.userList.length})',
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

              SizedBox(height: 12.h),

              // Users List
              Container(
                height: 380.h, // set height as you want
                width: double.infinity, // or a fixed width
                decoration: BoxDecoration(
                  color: ColorsManager.mistWhite, // optional background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListView(
                  children: company.userList
                      .map((user) => UserTile(user: user))
                      .toList(),
                ),
              ),
              // ...company.userList.map((user) => UserTile(user: user)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: ColorsManager.royalIndigo, size: 18.r),
        SizedBox(width: 12.h),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
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
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsManager.mistWhite,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorsManager.mistWhite),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: ColorsManager.royalIndigo,
            child: Text(
              user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
              style: TextStyle(
                color: ColorsManager.mistWhite,
                fontWeight: FontWeight.bold,
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
                ),
                SizedBox(height: 2.h),
                Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildPermissionBadge('Read', user.canRead),
              SizedBox(height: 4.h),
              _buildPermissionBadge('Edit', user.canEdit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionBadge(String label, bool hasPermission) {
    return Container(
      height: 20.h,
      width: 40.w,
      // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: hasPermission ? Colors.green[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: hasPermission ? Colors.green[700] : Colors.grey[600],
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
