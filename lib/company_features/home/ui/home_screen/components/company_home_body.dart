import 'package:celebritysystems_mobile/company_features/ticket_details/ui/company_ticket_details_screen.dart';
import 'package:celebritysystems_mobile/core/widgets/error_widget.dart';
import 'package:celebritysystems_mobile/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theming/colors.dart';
import '../../../data/models/company_tickets_response.dart';
import '../../../logic/company_home_cubit/company_home_cubit.dart';
import '../../../logic/company_home_cubit/company_home_state.dart';
import 'status_label.dart';

Widget companyHomeBody(Future<void> Function() onRefresh) {
  return BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
    buildWhen: (previous, current) {
      // Only rebuild when the state is relevant to tickets
      return current is Loading ||
          current is Error ||
          current is Success<List<CompanyTicketResponse>>;
    },
    builder: (context, state) {
      if (state is Loading) {
        return customLoadingWidget("loading_tickets".tr());
      }

      if (state is Error) {
        return customErrorWidget("error_msg".tr());
      }

      if (state is Success<List<CompanyTicketResponse>>) {
        final tickets = state.data.reversed.toList();

        if (tickets.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade50,
                    Colors.grey.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsManager.coralBlaze.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: ColorsManager.coralBlaze,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "no_tickets_yet".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "your_tickets_will_appear_here_once_they_are_created".tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: RefreshIndicator(
                color: ColorsManager.coralBlaze,
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
                onRefresh: onRefresh,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(context, ticket);
                  },
                ),
              ),
            ),
          ],
        );
      }

      return const SizedBox.shrink();
    },
  );
}

Widget _buildTicketCard(BuildContext context, CompanyTicketResponse ticket) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          ColorsManager.royalIndigo.withAlpha(55),
          ColorsManager.royalIndigo.withAlpha(5),

          // ColorsManager.coralBlaze.withAlpha(5),
          // Colors.white,
          // Colors.grey.shade50,
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: CompanyTicketDetailsScreen(ticket: ticket),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.title ?? 'untitled_ticket'.tr(),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '#${ticket.id?.toString() ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  StatusLabel(status: ticket.status),
                ],
              ),

              SizedBox(height: 16),

              // Screen info with icon
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorsManager.coralBlaze.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monitor,
                      size: 16,
                      color: ColorsManager.coralBlaze,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '${ticket.screenName ?? 'unknown'.tr()} • ${ticket.screenType ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ColorsManager.coralBlaze,
                      ),
                    ),
                  ],
                ),
              ),

              // Date with improved styling
              if (ticket.createdAt != null) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatDate(ticket.createdAt!),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],

              // Subtle bottom accent
              SizedBox(height: 12),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsManager.coralBlaze,
                      ColorsManager.coralBlaze.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today'.tr();
    } else if (difference.inDays == 1) {
      return 'yesterday'.tr();
    } else if (difference.inDays < 7) {
      return '${difference.inDays}${'days ago'.tr()}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  } catch (e) {
    return dateString.split('T').first;
  }
}

// Widget companyHomeBody(Future<void> Function() onRefresh) {
//   return BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
//     builder: (context, state) {
//       if (state is Loading) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }

//       if (state is Error) {
//         return Center(
//           child: Text(
//             state.error,
//             style: const TextStyle(
//               color: Colors.redAccent,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }

//       if (state is Success<List<CompanyTicketResponse>>) {
//         final tickets = state.data;

//         if (tickets.isEmpty) {
//           return const Center(
//             child: Text(
//               "There are no tickets yet!",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           );
//         }

//         return Column(
//           children: [
//             SizedBox(
//               height: 10.h,
//             ),
//             Expanded(
//               child: RefreshIndicator(
//                 color: ColorsManager.coralBlaze,
//                 onRefresh: onRefresh,
//                 child: ListView.separated(
//                   itemCount: tickets.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final ticket = tickets[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4, vertical: 6),
//                       child: Material(
//                         elevation: 2,
//                         borderRadius: BorderRadius.circular(12),
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(12),
//                           onTap: () {
//                             Navigator.of(context).push(
//                               PageRouteBuilder(
//                                 transitionDuration:
//                                     const Duration(milliseconds: 300),
//                                 pageBuilder:
//                                     (context, animation, secondaryAnimation) =>
//                                         FadeTransition(
//                                   opacity: animation,
//                                   child: CompanyTicketDetailsScreen(
//                                       ticket: ticket),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 /// Title & Status
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         ticket.title ?? 'Untitled Ticket',
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     StatusLabel(status: ticket.status),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),

//                                 /// Screen name & type
//                                 Text(
//                                   '${ticket.screenName ?? 'Unknown'} • ${ticket.screenType ?? 'N/A'}',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),

//                                 /// Date
//                                 if (ticket.createdAt != null) ...[
//                                   const SizedBox(height: 6),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.calendar_today,
//                                           size: 14, color: Colors.grey),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         ticket.createdAt!.split('T').first,
//                                         style: const TextStyle(fontSize: 13),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       }

//       return const SizedBox.shrink();
//     },
//   );
// }
