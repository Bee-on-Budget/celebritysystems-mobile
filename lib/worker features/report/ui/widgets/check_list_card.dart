import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckListCardWidget extends StatefulWidget {
  @override
  _CheckListCardWidgetState createState() => _CheckListCardWidgetState();
}

class _CheckListCardWidgetState extends State<CheckListCardWidget> {
  CheckList _mapChecklistItemsToModel() {
    String? getStatus(String itemName) {
      final match = checklistItems.firstWhere(
        (item) => item['name']
            .toString()
            .toLowerCase()
            .contains(itemName.toLowerCase()),
        orElse: () => {'status': null},
      );
      return match['status'];
    }

    return CheckList(
      dataCables: getStatus('Data cables'),
      powerCable: getStatus('Power Cable'),
      powerSupplies: getStatus('Power supplies'),
      ledModules: getStatus('LED Modules'),
      coolingSystems: getStatus('Cooling Systems'),
      serviceLightsSockets: getStatus('Service lights'),
      operatingComputers: getStatus('Operating Computers'),
      software: getStatus('Software'),
      powerDBs: getStatus('Power DBs'),
      mediaConverters: getStatus('Media Converters'),
      controlSystems: getStatus('Control Systems'),
      videoProcessors: getStatus('Video Processors'),
    );
  }

  List<Map<String, dynamic>> checklistItems = [
    {'name': 'Data cables (Cat5/Cat6/RJ45)', 'status': 'OK'},
    {'name': 'Power Cables', 'status': 'OK'},
    {'name': 'Power supplies', 'status': 'OK'},
    {'name': 'LED Modules', 'status': 'OK'},
    {'name': 'Cooling Systems', 'status': 'OK'},
    {'name': 'Service lights & sockets', 'status': 'OK'},
    {'name': 'Operating Computers', 'status': 'OK'},
    {'name': 'Software', 'status': 'OK'},
    {'name': 'Power DBs', 'status': 'OK'},
    {'name': 'Media Converters', 'status': 'OK'},
    {'name': 'Control Systems', 'status': 'X'},
    {'name': 'Video Processors', 'status': 'OK'},
  ];

  Widget _buildChecklistCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equipment Checklist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checklistItems.length,
              itemBuilder: (context, index) {
                final item = checklistItems[index];
                final isOK = item['status'] == 'OK';

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (checklistItems[index]['status'] == 'OK') {
                        checklistItems[index]['status'] = 'X';
                      } else if (checklistItems[index]['status'] == 'X') {
                        checklistItems[index]['status'] = 'OK';
                      }

                      context.read<ReportCubit>().reportRequest?.checklist =
                          _mapChecklistItemsToModel();

                      print(context
                          .read<ReportCubit>()
                          .reportRequest
                          ?.checklist
                          ?.toJson());
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              isOK ? Icons.check_circle : Icons.cancel,
                              color: isOK ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOK ? 'OK' : 'Issue',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isOK ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChecklistCard();
    // Scaffold(
    //   body: SingleChildScrollView(child: _buildServiceTypeCard()),
    // );
  }
}
