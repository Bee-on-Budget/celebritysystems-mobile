import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatelessWidget {
  final OneTicketResponse ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  String _formatDate(String iso) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(iso));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: AppBar(
        title: const Text("Ticket Details"),
        backgroundColor: ColorsManager.coralBlaze,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 450.h,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _header("🎫 ${ticket.title}", big: true),
              const SizedBox(height: 10),
              Text(
                ticket.description ?? "",
                style: const TextStyle(fontSize: 15),
              ),
              const Divider(height: 30),
              _header("📄 Details"),
              _info("Company", ticket.companyName ?? ""),
              _info("Screen", ticket.screenName ?? ""),
              _info("Assigned To", ticket.assignedToWorkerName ?? ""),
              _info("Assigned By", ticket.assignedBySupervisorName ?? ""),
              _info("Created At", _formatDate(ticket.createdAt ?? "")),
              const Divider(height: 30),
              _header("📌 Status"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Chip(
                    label: Text(
                      ticket.status ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _statusColor(ticket.status ?? ""),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  FadeTransition(
                            opacity: animation,
                            child: ServiceReportScreen(ticket: ticket),
                          ),
                        ),
                      );

                      // context.pushNamed(Routes.reportScreen);
                    },
                    child: Chip(
                      label: Text(
                        "Submit Report",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: ColorsManager.slateGray,
                    ),
                  ),
                ],
              ),
              // if (ticket['attachmentFileName'].isNotEmpty) ...[
              //   const SizedBox(height: 30),
              //   _header("📎 Attachment"),
              //   Text(ticket['attachmentFileName'],
              //       style: const TextStyle(
              //           fontStyle: FontStyle.italic,
              //           color: ColorsManager.slateGray)),
              // ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String text, {bool big = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: big ? 20 : 16,
        fontWeight: FontWeight.w600,
        color: ColorsManager.graphiteBlack,
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return ColorsManager.royalIndigo;
      case 'in progress':
        return ColorsManager.royalIndigo;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
