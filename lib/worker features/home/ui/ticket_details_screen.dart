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
          height: 650.h,
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
              Image.asset('assets/images/logo.png'),
              // Image.network(
              //     "data:image/jpeg;base64,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"),
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
