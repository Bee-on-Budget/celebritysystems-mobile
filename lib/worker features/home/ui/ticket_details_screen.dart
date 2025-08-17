import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: Text(
          "Ticket Details",
          style: TextStyle(fontSize: 20.sp),
        ),
        backgroundColor: ColorsManager.coralBlaze,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Container(
          // Use dynamic height with min/max or remove fixed height to make it flexible
          // height: 650.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
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
              SizedBox(height: 12.h),
              Text(
                ticket.description ?? "",
                style: TextStyle(fontSize: 15.sp),
              ),
              Divider(height: 40.h),
              _header("📄 Details"),
              _info("Company", ticket.companyName ?? ""),
              _info("Screen", ticket.screenName ?? ""),
              _info("Assigned To", ticket.assignedToWorkerName ?? ""),
              _info("Assigned By", ticket.assignedBySupervisorName ?? ""),
              _info("Created At", _formatDate(ticket.createdAt ?? "")),
              Divider(height: 40.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black87, // darken background
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.all(10.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              ticket.ticketImageUrl ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/logo.png');
                              },
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    ticket.ticketImageUrl ?? '',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/logo.png');
                    },
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.h,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              _header("📌 Status"),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Chip(
                    label: Text(
                      ticket.status ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    backgroundColor: _statusColor(ticket.status ?? ""),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: BlocProvider(
                                create: (context) => ReportCubit(getIt()),
                                child: ServiceReportScreen(ticket: ticket),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ticket.status == "OPEN"
                          ? Chip(
                              label: Text(
                                "Submit Report",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                              backgroundColor: ColorsManager.slateGray,
                            )
                          : SizedBox(
                              width: 100.w,
                            )),
                ],
              ),
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
        fontSize: big ? 20.sp : 16.sp,
        fontWeight: FontWeight.w600,
        color: ColorsManager.graphiteBlack,
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp),
            ),
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
