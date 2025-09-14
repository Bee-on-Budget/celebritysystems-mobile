import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/login/logic/user cubit/user_cubit.dart';
import '../../../logic/company_home_cubit/company_home_cubit.dart';
import '../../../logic/company_home_cubit/company_home_state.dart';

import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';

companyHomeAppBar(
  BuildContext context,
  Color backgroundColor,
  void Function(VoidCallback fn) setState,
  String? selectedCompanyName, // Add this parameter
  void Function(String?) onCompanyChanged, // Add this parameter
) {
  final username = context.read<UserCubit>().state?.username ?? 'User';
  String appbarTitle = selectedCompanyName ??
      username; // Use selected company or fallback to username

  Future<void> handleLogout() async {
    final userCubit = context.read<UserCubit>();

    final user = context.read<UserCubit>().state;
    // Clear user state
    userCubit.logout(user!.userId!);

    // Navigate to login screen
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginScreen,
        (route) => false,
      );
    }
  }

  return AppBar(
    title: Row(
      children: [
        // Text("data"),
        Text(
          appbarTitle.length > 14
              ? appbarTitle.substring(0, 16) + '…' // add ellipsis
              : appbarTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        Expanded(
          child: BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
            builder: (context, state) {
              final cubit = context.read<CompanyHomeCubit>();
              final subcontractsList = cubit.subcontractList;

              // Get unique company names from both mainCompany and controllerCompany
              final Set<String> uniqueCompanyNames = {};
              for (var subcontract in subcontractsList) {
                uniqueCompanyNames.add(subcontract.mainCompany.name);
                uniqueCompanyNames.add(subcontract.controllerCompany.name);
              }

              final companiesNames = uniqueCompanyNames.toList()..sort();

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconEnabledColor: Colors.white,
                  dropdownColor: ColorsManager.royalIndigo.withOpacity(0.9),
                  style: const TextStyle(
                    color: ColorsManager.mistWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  underline: const SizedBox(),
                  value: null,
                  // selectedCompanyName, // Use the selected company name : null,

                  items: companiesNames.map((name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        style: const TextStyle(color: ColorsManager.mistWhite),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      // Update the selected company first
                      onCompanyChanged(newValue);

                      // Perform async operations first
                      final selectedCompany = subcontractsList
                          .map((sub) => sub.mainCompany)
                          .followedBy(subcontractsList
                              .map((sub) => sub.controllerCompany))
                          .firstWhere((company) => company.name == newValue);

                      final selectedCompanyId = selectedCompany.id;
                      final currentCompanyId = await SharedPrefHelper.getInt(
                          SharedPrefKeys.companyId);

                      if (selectedCompanyId == currentCompanyId) {
                        await SharedPrefHelper.removeData(
                            SharedPrefKeys.subCompanyId);
                        await SharedPrefHelper.removeData(
                            SharedPrefKeys.subCompanyContractsIds);
                        onCompanyChanged(username);
                      } else {
                        await SharedPrefHelper.setData(
                            SharedPrefKeys.subCompanyId, selectedCompanyId);
                        // Get all contract ids for this company (as main company)
                        final contractIds = subcontractsList
                            .where((sub) =>
                                sub.mainCompany.id == selectedCompanyId)
                            .map((sub) => sub.contract.id)
                            .toList();
                        await SharedPrefHelper.setData(
                            SharedPrefKeys.subCompanyContractsIds, contractIds);
                      }

                      // Update the UI state after async operations are complete
                      if (context.mounted) {
                        setState(() {
                          appbarTitle = newValue;
                          // Any synchronous state updates go here
                          // The actual dropdown value will be handled by the widget automatically
                        });
                      }
                    }

                    print(
                        "managed company: ${await SharedPrefHelper.getInt(SharedPrefKeys.subCompanyId)}");
                    print(
                        "managed contractIds: ${await SharedPrefHelper.getString(SharedPrefKeys.subCompanyContractsIds)}");
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
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
    foregroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    actions: [
      BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return IconButton(
            icon: Icon(
              Icons.translate,
            ),
            onPressed: () {
              context.read<LanguageCubit>().toggleLanguage(context);
              // context.read<LanguageCubit>().changeLanguage(context, "an");
              setState(() {});
            },
            tooltip: 'Switch to English',
          );
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('logout'.tr()),
              content: Text('are_you_sure_you_want_to_logout'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('no'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('yes'.tr()),
                ),
              ],
            ),
          );
          if (shouldLogout ?? false) {
            await handleLogout();
          }
        },
        tooltip: 'logout'.tr(),
      ),
    ],
  );
}

// import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
// import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/routing/routes.dart';
// import '../../../../../core/theming/colors.dart';
// import '../../../../../features/login/logic/user cubit/user_cubit.dart';
// import '../../../logic/company_home_cubit/company_home_cubit.dart';
// import '../../../logic/company_home_cubit/company_home_state.dart';

// import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
// import 'package:celebritysystems_mobile/core/helpers/constants.dart';

// companyHomeAppBar(
//   BuildContext context,
//   Color backgroundColor,
//   void Function(VoidCallback fn) setState,
// ) {
//   Future<void> handleLogout() async {
//     final userCubit = context.read<UserCubit>();

//     final user = context.read<UserCubit>().state;
//     // Clear user state
//     userCubit.logout(user!.userId!);

//     // Navigate to login screen
//     if (context.mounted) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         Routes.loginScreen,
//         (route) => false,
//       );
//     }
//   }

//   return AppBar(
//     title: Row(
//       children: [
//         Expanded(
//           child: BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
//             builder: (context, state) {
//               final cubit = context.read<CompanyHomeCubit>();
//               final subcontractsList = cubit.subcontractList;

//               // Get unique company names from both mainCompany and controllerCompany
//               final Set<String> uniqueCompanyNames = {};
//               for (var subcontract in subcontractsList) {
//                 uniqueCompanyNames.add(subcontract.mainCompany.name);
//                 uniqueCompanyNames.add(subcontract.controllerCompany.name);
//               }

//               final companiesNames = uniqueCompanyNames.toList()..sort();

//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   dropdownColor: ColorsManager.royalIndigo.withOpacity(0.9),
//                   style: const TextStyle(color: ColorsManager.mistWhite),
//                   underline: const SizedBox(),
//                   value: companiesNames.isNotEmpty
//                       ? companiesNames.first
//                       : null, //TODO: change the value
//                   items: companiesNames.map((name) {
//                     return DropdownMenuItem<String>(
//                       value: name,
//                       child: Text(
//                         name,
//                         style: const TextStyle(color: ColorsManager.mistWhite),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) async {
//                     if (newValue != null) {
//                       // Perform async operations first
//                       final selectedCompany = subcontractsList
//                           .map((sub) => sub.mainCompany)
//                           .followedBy(subcontractsList
//                               .map((sub) => sub.controllerCompany))
//                           .firstWhere((company) => company.name == newValue);

//                       final selectedCompanyId = selectedCompany.id;
//                       final currentCompanyId = await SharedPrefHelper.getInt(
//                           SharedPrefKeys.companyId);

//                       if (selectedCompanyId == currentCompanyId) {
//                         await SharedPrefHelper.removeData(
//                             SharedPrefKeys.subCompanyId);
//                         await SharedPrefHelper.removeData(
//                             SharedPrefKeys.subCompanyContractsIds);
//                       } else {
//                         await SharedPrefHelper.setData(
//                             SharedPrefKeys.subCompanyId, selectedCompanyId);
//                         // Get all contract ids for this company (as main company)
//                         final contractIds = subcontractsList
//                             .where((sub) =>
//                                 sub.mainCompany.id == selectedCompanyId)
//                             .map((sub) => sub.contract.id)
//                             .toList();
//                         await SharedPrefHelper.setData(
//                             SharedPrefKeys.subCompanyContractsIds, contractIds);
//                       }

//                       // Update the UI state after async operations are complete
//                       if (mounted) {
//                         setState(() {
//                           // Any synchronous state updates go here
//                           // The actual dropdown value will be handled by the widget automatically
//                         });
//                       }
//                     }

//                     print(
//                         "managed company: ${await SharedPrefHelper.getString(SharedPrefKeys.subCompanyId)}");
//                     print(
//                         "managed contractIds: ${await SharedPrefHelper.getString(SharedPrefKeys.subCompanyContractsIds)}");
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Text(
//         //   'tickets_page'.tr(),
//         //   style: TextStyle(
//         //     color: Colors.white,
//         //     fontWeight: FontWeight.bold,
//         //     fontSize: 20,
//         //   ),
//         // ),
//       ],
//     ),
//     backgroundColor: Colors.transparent,
//     flexibleSpace: Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             ColorsManager.royalIndigo,
//             ColorsManager.coralBlaze,
//           ],
//         ),
//       ),
//     ),
//     foregroundColor: Colors.white,
//     elevation: 0,
//     automaticallyImplyLeading: false,
//     actions: [
//       BlocBuilder<LanguageCubit, LanguageState>(
//         builder: (context, state) {
//           return IconButton(
//             icon: Icon(
//               Icons.translate,
//             ),
//             onPressed: () {
//               context.read<LanguageCubit>().toggleLanguage(context);
//               // context.read<LanguageCubit>().changeLanguage(context, "an");
//               setState(() {});
//             },
//             tooltip: 'Switch to English',
//           );
//         },
//       ),
//       IconButton(
//         icon: const Icon(
//           Icons.logout,
//           color: Colors.white,
//         ),
//         onPressed: () async {
//           final shouldLogout = await showDialog<bool>(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('logout'.tr()),
//               content: Text('are_you_sure_you_want_to_logout'.tr()),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: Text('no'.tr()),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: Text('yes'.tr()),
//                 ),
//               ],
//             ),
//           );
//           if (shouldLogout ?? false) {
//             await handleLogout();
//           }
//         },
//         tooltip: 'logout'.tr(),
//       ),
//     ],
//   );
// }
