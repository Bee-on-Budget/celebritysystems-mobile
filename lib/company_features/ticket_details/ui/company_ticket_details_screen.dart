import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/theming/colors.dart';
import '../../home/data/models/company_tickets_response.dart';
import 'components/google_link_ui.dart';

class CompanyTicketDetailsScreen extends StatelessWidget {
  const CompanyTicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  final CompanyTicketResponse ticket;

  String _formatDate(String? rawDate) {
    if (rawDate == null) return "unknown".tr();
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat.yMMMMd().add_jm().format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.blueGrey;

    switch (status.toLowerCase()) {
      case 'open':
      case 'new':
        return Colors.blue;
      case 'in progress':
      case 'assigned':
        return Colors.amber;
      case 'completed':
      case 'resolved':
      case 'closed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildTicketHeader(),
                _buildTicketContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: ColorsManager.royalIndigo,
      foregroundColor: Colors.black87,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'ticket_details'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        background: Container(
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
      ),
    );
  }

  Widget _buildTicketHeader() {
    final statusColor = _getStatusColor(ticket.status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            ColorsManager.coralBlaze.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Ticket ID Badge
          if (ticket.id != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorsManager.coralBlaze.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorsManager.coralBlaze.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.confirmation_number_rounded,
                    size: 16,
                    color: ColorsManager.coralBlaze,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${"ticket".tr()} #${ticket.id}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorsManager.coralBlaze,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Title
          Text(
            ticket.title ?? 'Untitled Ticket',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Status and Creation Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor, statusColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ticket.status ?? "unknown".tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Created Date Chip
              if (ticket.createdAt != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(ticket.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Section
          if (ticket.description != null && ticket.description!.isNotEmpty)
            _buildSection(
              title: "description".tr(),
              icon: Icons.description_rounded,
              children: [
                _buildDescriptionCard(),
              ],
            ),

          // Company Information Section
          _buildSection(
            title: "company_details".tr(),
            icon: Icons.business_rounded,
            children: [
              _buildInfoGrid([
                _InfoItem(
                  icon: Icons.business_center_rounded,
                  label: "company".tr(),
                  value: ticket.companyName,
                ),
                _InfoItem(
                  icon: Icons.monitor_rounded,
                  label: "screens".tr(),
                  value: ticket.screenName,
                ),
                _InfoItem(
                  icon: Icons.category_rounded,
                  label: "Screen_type".tr(),
                  value: ticket.screenType,
                ),
              ]),
            ],
          ),

          // Location Section
          if (ticket.location != null)
            _buildSection(
              title: "location".tr(),
              icon: Icons.location_on_rounded,
              children: [
                googleLinkUi(
                  icon: Icons.location_on_rounded,
                  title: "location".tr(),
                  url: ticket.location,
                ),
              ],
            ),

          // Assignment Section
          _buildSection(
            title: "assignment_details".tr(),
            icon: Icons.people_rounded,
            children: [
              _buildInfoGrid([
                _InfoItem(
                  icon: Icons.person_rounded,
                  label: "assigned_to".tr(),
                  value: ticket.assignedToWorkerName,
                ),
                _InfoItem(
                  icon: Icons.supervisor_account_rounded,
                  label: "assigned_by".tr(),
                  value: ticket.assignedBySupervisorName,
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorsManager.coralBlaze.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: ColorsManager.coralBlaze,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          ...children,
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        ticket.description ?? 'No description provided',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ticket.description != null
              ? Colors.grey.shade800
              : Colors.grey.shade500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildInfoRow(item),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Colors.grey.shade200,
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(_InfoItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorsManager.coralBlaze.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            item.icon,
            color: ColorsManager.coralBlaze,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.coralBlaze,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.value ?? 'Not provided',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: item.value != null
                      ? Colors.grey.shade800
                      : Colors.grey.shade500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String? value;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
// class CompanyTicketDetailsScreen extends StatelessWidget {
//   const CompanyTicketDetailsScreen({
//     super.key,
//     required this.ticket,
//   });

//   final CompanyTicketResponse ticket;

//   String _formatDate(String? rawDate) {
//     if (rawDate == null) return "Unknown";
//     try {
//       final dateTime = DateTime.parse(rawDate);
//       return DateFormat.yMMMMd().add_jm().format(dateTime);
//     } catch (_) {
//       return rawDate;
//     }
//   }

//   Widget _buildDetailItem({
//     required IconData icon,
//     required String title,
//     required String? value,
//   }) {
//     final primaryColor = ColorsManager.coralBlaze;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [primaryColor.withOpacity(0.05), primaryColor.withOpacity(0.1)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Icon and Title Row
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: primaryColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: primaryColor, size: 24),
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: primaryColor,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           // Data underneath
//           Text(
//             value ?? 'Not provided',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: value != null ? Colors.grey.shade800 : Colors.grey.shade500,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String? status) {
//     if (status == null) return Colors.blueGrey;

//     switch (status.toLowerCase()) {
//       case 'open':
//       case 'new':
//         return Colors.blue;
//       case 'in progress':
//       case 'assigned':
//         return Colors.amber;
//       case 'completed':
//       case 'resolved':
//       case 'closed':
//         return Colors.green;
//       case 'cancelled':
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.blueGrey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor(ticket.status);

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Text(
//           'Ticket Details',
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         shadowColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section with gradient background
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.white, Colors.grey.shade100],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   // Ticket ID Badge
//                   if (ticket.id != null)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Ticket #${ticket.id}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ),

//                   const SizedBox(height: 16),

//                   // Title
//                   Text(
//                     ticket.title ?? 'Untitled Ticket',
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       height: 1.2,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                   const SizedBox(height: 16),

//                   // Status Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [statusColor, statusColor.withOpacity(0.8)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: statusColor.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       ticket.status ?? 'Unknown',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Content Section
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   _buildDetailItem(
//                     icon: Icons.description_rounded,
//                     title: "Description",
//                     value: ticket.description,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.business_rounded,
//                     title: "Company",
//                     value: ticket.companyName,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.monitor_rounded,
//                     title: "Screen",
//                     value: ticket.screenName,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.category_rounded,
//                     title: "Screen Type",
//                     value: ticket.screenType,
//                   ),

//                   googleLinkUi(
//                     icon: Icons.location_on_rounded,
//                     title: "Location",
//                     url: ticket.location,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.person_rounded,
//                     title: "Assigned To",
//                     value: ticket.assignedToWorkerName,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.supervisor_account_rounded,
//                     title: "Assigned By",
//                     value: ticket.assignedBySupervisorName,
//                   ),

//                   _buildDetailItem(
//                     icon: Icons.schedule_rounded,
//                     title: "Created At",
//                     value: _formatDate(ticket.createdAt),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
