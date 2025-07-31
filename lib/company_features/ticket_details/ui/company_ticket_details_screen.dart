import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    if (rawDate == null) return "Unknown";
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat.yMMMMd().add_jm().format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String? value,
  }) {
    final primaryColor = ColorsManager.coralBlaze;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.05), primaryColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Data underneath
          Text(
            value ?? 'Not provided',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: value != null ? Colors.grey.shade800 : Colors.grey.shade500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
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
    final statusColor = _getStatusColor(ticket.status);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with gradient background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Ticket ID Badge
                  if (ticket.id != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Ticket #${ticket.id}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    ticket.title ?? 'Untitled Ticket',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [statusColor, statusColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      ticket.status ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailItem(
                    icon: Icons.description_rounded,
                    title: "Description",
                    value: ticket.description,
                  ),

                  _buildDetailItem(
                    icon: Icons.business_rounded,
                    title: "Company",
                    value: ticket.companyName,
                  ),

                  _buildDetailItem(
                    icon: Icons.monitor_rounded,
                    title: "Screen",
                    value: ticket.screenName,
                  ),

                  _buildDetailItem(
                    icon: Icons.category_rounded,
                    title: "Screen Type",
                    value: ticket.screenType,
                  ),

                  googleLinkUi(
                    icon: Icons.location_on_rounded,
                    title: "Location",
                    url: ticket.location,
                  ),

                  _buildDetailItem(
                    icon: Icons.person_rounded,
                    title: "Assigned To",
                    value: ticket.assignedToWorkerName,
                  ),

                  _buildDetailItem(
                    icon: Icons.supervisor_account_rounded,
                    title: "Assigned By",
                    value: ticket.assignedBySupervisorName,
                  ),

                  _buildDetailItem(
                    icon: Icons.schedule_rounded,
                    title: "Created At",
                    value: _formatDate(ticket.createdAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}