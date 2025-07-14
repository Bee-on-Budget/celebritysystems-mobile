import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/features/home/logic/home%20cubit/home_state.dart';
import 'package:celebritysystems_mobile/features/ticket/ui/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../login/logic/user cubit/user_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<UserCubit>().state;
    print("User in HomeScreen: $user");

    final username = user?.username ?? 'default';
    context.read<HomeCubit>().getHomeTickets(username);
    context.read<HomeCubit>().getTicketsCount(username);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsManager.mistWhite,
        appBar: AppBar(
          title: const Text("  My Tickets"),
          backgroundColor: ColorsManager.coralBlaze,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Error) {
              return Center(child: Text(state.error));
            } else if (state is Success<List<OneTicketResponse>>) {
              final tickets = state.data;

              if (tickets.isEmpty) {
                return const Center(child: Text("No tickets found."));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200.h, // increased height to fit TabBar
                      color: ColorsManager.coralBlaze,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                context
                                    .read<HomeCubit>()
                                    .assignedCount
                                    .toString(),
                                style: TextStyle(
                                  color: ColorsManager.mistWhite,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 50.h,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: ColorsManager.mistWhite,
                                  width: 20,
                                ),
                              ),
                              Text(
                                context
                                    .read<HomeCubit>()
                                    .completedCount
                                    .toString(),
                                style: TextStyle(
                                  color: ColorsManager.mistWhite,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          TabBar(
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white60,
                            tabs: const [
                              Tab(text: 'Assigned Count'),
                              Tab(text: 'Completed Count'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 600.h, // enough height for tab content
                      child: TabBarView(
                        children: [
                          _buildTicketList(tickets
                              .where((t) => t.status?.toLowerCase() != 'closed')
                              .toList()),
                          _buildTicketList(tickets
                              .where((t) => t.status?.toLowerCase() == 'closed')
                              .toList()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTicketList(List<OneTicketResponse> tickets) {
    if (tickets.isEmpty) {
      //TODO
      return const Center(child: Text("No tickets in this tab."));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
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
                  _infoRow(Icons.business, ticket.companyName ?? ""),
                  _infoRow(
                      Icons.person, "By: ${ticket.assignedBySupervisorName}"),
                  _infoRow(Icons.screenshot_monitor_outlined,
                      ticket.screenName ?? ""),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          ticket.status ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _statusColor(ticket.status ?? ""),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(ticket.createdAt ?? ""),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 131, 131, 131),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
