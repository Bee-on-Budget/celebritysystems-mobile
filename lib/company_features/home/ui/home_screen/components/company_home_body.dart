import 'package:celebritysystems_mobile/company_features/ticket_details/ui/company_ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theming/colors.dart';
import '../../../data/models/company_tickets_response.dart';
import '../../../logic/company_home_cubit/company_home_cubit.dart';
import '../../../logic/company_home_cubit/company_home_state.dart';
import 'status_label.dart';

Widget companyHomeBody(Future<void> Function() onRefresh) {
  return BlocBuilder<CompanyHomeCubit, CompanyHomeState>(
    builder: (context, state) {
      if (state is Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is Error) {
        return Center(
          child: Text(
            state.error,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      if (state is Success<List<CompanyTicketResponse>>) {
        final tickets = state.data;

        if (tickets.isEmpty) {
          return const Center(
            child: Text(
              "There are no tickets yet!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: ColorsManager.coralBlaze,
          onRefresh: onRefresh,
          child: ListView.separated(
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              FadeTransition(
                                opacity: animation,
                                child: CompanyTicketDetailsScreen(ticket: ticket),
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ticket.title ?? 'Untitled Ticket',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              StatusLabel(status: ticket.status),
                            ],
                          ),
                          const SizedBox(height: 8),

                          /// Screen name & type
                          Text(
                            '${ticket.screenName ?? 'Unknown'} • ${ticket.screenType ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          /// Date
                          if (ticket.createdAt != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  ticket.createdAt!.split('T').first,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }

      return const SizedBox.shrink();
    },
  );
}
