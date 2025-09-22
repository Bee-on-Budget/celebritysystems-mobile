import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/company_features/screens/data/models/ticket_history_response.dart';
import 'package:celebritysystems_mobile/company_features/screens/logic/screen_cubit/screen_cubit.dart';
import 'package:celebritysystems_mobile/company_features/screens/logic/screen_cubit/screen_state.dart';
import 'package:celebritysystems_mobile/core/widgets/clickable_link.dart';
import 'package:celebritysystems_mobile/core/widgets/error_widget.dart';
import 'package:celebritysystems_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenHistoryPage extends StatefulWidget {
  final CompanyScreenModel screen;

  const ScreenHistoryPage({super.key, required this.screen});
  @override
  _ScreenHistoryPageState createState() => _ScreenHistoryPageState();
}

class _ScreenHistoryPageState extends State<ScreenHistoryPage> {
  Set<int> expandedTickets = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ScreenCubit>().getTicketsHistoryForScreen(widget.screen.id!);
  }

  // Fake data
  // final CompanyScreenModelTest screenDetails = CompanyScreenModelTest(
  //   id: 1,
  //   name: "Main Lobby Display",
  //   screenType: "LED Display",
  //   location: "Building A - Ground Floor",
  //   solutionType: "Digital Signage",
  // );

  Color getStatusColor(String status) {
    switch (status) {
      case 'OPEN':
        return Colors.red;
      case 'IN_PROGRESS':
        return Colors.orange;
      case 'RESOLVED':
        return Colors.blue;
      case 'CLOSED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'not_provided'.tr();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('screen_page'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: BlocBuilder<ScreenCubit, ScreenState>(
          builder: (context, state) {
            if (state is Error) {
              return customErrorWidget(state);
            }
            if (state is Loading) {
              return customLoadingWidget("loading".tr());
            }
            if (state is Success) {
              final ticketsHistory = state.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen Details Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tv, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'screen_details'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildDetailRow('screen_name'.tr(), widget.screen.name,
                            Icons.label),
                        _buildDetailRow('type'.tr(), widget.screen.screenType,
                            Icons.category),
                        // _buildDetailRow('location'.tr(), widget.screen.location,
                        //     Icons.location_on),

                        _buildDetailRow('solution_type'.tr(),
                            widget.screen.solutionType, Icons.build),
                        SizedBox(height: 8),

                        clickableLinkWidget(
                            icon: Icons.location_on,
                            title: 'location'.tr(),
                            url: widget.screen.location),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Tickets Section Header
                  Row(
                    children: [
                      Icon(Icons.assignment, color: Colors.grey[700], size: 28),
                      SizedBox(width: 12),
                      Text(
                        'tickets'.tr(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${ticketsHistory.length} ${'tickets'.tr()}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Tickets List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ticketsHistory.length,
                    itemBuilder: (context, index) {
                      final ticket = ticketsHistory[index];
                      final isExpanded = expandedTickets.contains(ticket.id);

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Ticket Header
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    expandedTickets.remove(ticket.id);
                                  } else {
                                    expandedTickets.add(ticket.id!);
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                getStatusColor(ticket.status!)
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '#${ticket.id}',
                                            style: TextStyle(
                                              color: getStatusColor(
                                                  ticket.status!),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                getStatusColor(ticket.status!),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            ticket.status!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      ticket.title!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      ticket.description!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      maxLines: isExpanded ? null : 2,
                                      overflow: isExpanded
                                          ? null
                                          : TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${'created_at'.tr()}: ${formatDateTime(ticket.openedAt)}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expanded Content
                            if (isExpanded) ...[
                              Divider(height: 1),
                              _buildExpandedTicketContent(ticket),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'not_provided'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedTicketContent(TicketHistoryResponse ticket) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket Details Section
          _buildSectionHeader('ticket_details'.tr(), Icons.info_outline),
          SizedBox(height: 12),

          if (ticket.ticketImageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ticket.ticketImageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          _buildInfoGrid([
            {'label': 'assigned_by'.tr(), 'value': ticket.createdBy},
            {'label': 'assigned_to'.tr(), 'value': ticket.assignedToWorkerName},
            {
              'label': 'assigned_by'.tr(),
              'value': ticket.assignedBySupervisorName
            },
            {
              'label': 'service_type'.tr(),
              'value': ticket.serviceTypeDisplayName
            },
          ]),

          SizedBox(height: 16),

          _buildTimelineInfo(ticket),

          // Worker Report Section
          if (ticket.workerReport != null) ...[
            SizedBox(height: 24),
            _buildSectionHeader(
                'service_report'.tr(), Icons.assignment_turned_in),
            SizedBox(height: 12),
            _buildWorkerReport(ticket.workerReport!),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(List<Map<String, String?>> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '${item['label']}:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item['value'] ?? 'not_provided'.tr(),
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTimelineInfo(TicketHistoryResponse ticket) {
    final timeline = [
      {
        'label': 'created_at'.tr(),
        'time': ticket.openedAt,
        'icon': Icons.schedule
      },
      {
        'label': 'assigned'.tr(),
        'time': ticket.inProgressAt,
        'icon': Icons.play_arrow
      },
      {
        'label': 'completed'.tr(),
        'time': ticket.resolvedAt,
        'icon': Icons.check
      },
      {
        'label': 'completed'.tr(),
        'time': ticket.closedAt,
        'icon': Icons.check_circle
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'created_at'.tr()}:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        ...timeline.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 16,
                    color:
                        item['time'] != null ? Colors.green : Colors.grey[400],
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${item['label']}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    formatDateTime(item['time'] as DateTime?),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildWorkerReport(WorkerReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Report basic info
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'service_date'.tr()}: ${formatDateTime(report.reportDate)}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('${'defects_found'.tr()}:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text(report.defectsFound),
              SizedBox(height: 8),
              Text('${'solutions_implemented'.tr()}:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text(report.solutionsProvided),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Checklist - same as before
        Text(
          '${'equipment_checklist'.tr()}:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        ...report.checklist.entries.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    entry.value == 'OK' ? Icons.check_circle : Icons.cancel,
                    color: entry.value == 'OK' ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: entry.value == 'OK'
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: entry.value == 'OK'
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(height: 16),

        // Solution image
        Text(
          'ticket_image'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            report.solutionImage,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(child: Icon(Icons.image_not_supported)),
            ),
          ),
        ),
      ],
    );
  }
}
