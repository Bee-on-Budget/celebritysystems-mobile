import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_state.dart';
import 'package:celebritysystems_mobile/features/ticket/ui/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  // final List<Map<String, dynamic>> tickets = [
  //   {
  //     "id": 0,
  //     "title": "Button not clickable",
  //     "description": "Submit button is not responsive on mobile devices.",
  //     "createdBy": 101,
  //     "assignedToWorkerName": "Ahmed N.",
  //     "assignedBySupervisorName": "Lina A.",
  //     "screenName": "Booking Screen",
  //     "companyName": "Celebrity Tours",
  //     "status": "Open",
  //     "createdAt": "2025-06-08T22:40:48.745Z",
  //     "attachmentFileName": "screenshot.png"
  //   },
  //   {
  //     "id": 1,
  //     "title": "Page crash on load",
  //     "description": "Home page crashes on Android 11.",
  //     "createdBy": 104,
  //     "assignedToWorkerName": "Ahmed N.",
  //     "assignedBySupervisorName": "Ziad K.",
  //     "screenName": "Home",
  //     "companyName": "Star Events",
  //     "status": "In Progress",
  //     "createdAt": "2025-06-09T15:20:00.000Z",
  //     "attachmentFileName": ""
  //   },
  // ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeTickets("worker1"); //TODO
  }

  String _formatDate(String iso) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(iso));
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color.fromARGB(255, 57, 127, 167);
      case 'in progress':
        return ColorsManager.royalIndigo;
      case 'closed':
        return ColorsManager.coralBlaze;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: AppBar(
        title: const Text("My Tickets"),
        backgroundColor: ColorsManager.coralBlaze,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Error) {
          return Center(child: Text(state.error));
        } else if (state is Success) {
          final tickets = state.data;

          if (tickets.isEmpty) {
            return const Center(child: Text("No tickets found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final ticket = tickets[index] as OneTicketResponse;

              return Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    //Navigate to ticket details
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FadeTransition(
                          opacity: animation,
                          child: TicketDetailsScreen(ticket: ticket),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ticket Title
                        Row(
                          children: [
                            Icon(Icons.confirmation_number_outlined,
                                color: ColorsManager.coralBlaze),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                ticket.title ?? "-",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsManager.graphiteBlack,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Meta Info
                        _infoRow(Icons.business, ticket.companyName ?? ""),
                        _infoRow(Icons.person,
                            "By: ${ticket.assignedBySupervisorName}"),
                        _infoRow(Icons.screenshot_monitor_outlined,
                            ticket.screenName ?? ""),

                        SizedBox(height: 10.h),

                        // Status and Date
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                ticket.status ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor:
                                  _statusColor(ticket.status ?? ""),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(ticket.createdAt ?? ""),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 131, 131, 131)),
                            ),
                          ],
                        ),

                        // if (ticket['attachmentFileName'].isNotEmpty) ...[
                        //   const SizedBox(height: 10),
                        //   Row(
                        //     children: const [
                        //       Icon(Icons.attach_file,
                        //           size: 18, color: ColorsManager.slateGray),
                        //       SizedBox(width: 4),
                        //       Text(
                        //         "Attachment included",
                        //         style:
                        //             TextStyle(color: ColorsManager.slateGray),
                        //       ),
                        //     ],
                        //   ),
                        // ]
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorsManager.slateGray),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: ColorsManager.graphiteBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
