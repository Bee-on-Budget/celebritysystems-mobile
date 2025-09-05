import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckListCardWidget extends StatefulWidget {
  @override
  _CheckListCardWidgetState createState() => _CheckListCardWidgetState();
}

class _CheckListCardWidgetState extends State<CheckListCardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
            .read<ReportCubit>()
            .reportRequest
            ?.checklist = // this is the initial state of the checklist
        _mapChecklistItemsToModel();
  }

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
    {'name': 'data_cables'.tr(), 'status': 'ok'.tr()},
    {'name': 'power_cable'.tr(), 'status': 'ok'.tr()},
    {'name': 'power_supplies'.tr(), 'status': 'ok'.tr()},
    {'name': 'led_modules'.tr(), 'status': 'ok'.tr()},
    {'name': 'cooling_systems'.tr(), 'status': 'ok'.tr()},
    {'name': 'Service lights & sockets', 'status': 'ok'.tr()},
    {'name': 'Operating Computers', 'status': 'ok'.tr()},
    {'name': 'Software', 'status': 'ok'.tr()},
    {'name': 'Power DBs', 'status': 'ok'.tr()},
    {'name': 'Media Converters', 'status': 'ok'.tr()},
    {'name': 'Control Systems', 'status': 'ok'.tr()},
    {'name': 'Video Processors', 'status': 'ok'.tr()},
  ];

  Widget _buildChecklistCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'equipment_checklist'.tr(),
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
                final isOK = item['status'] == 'ok'.tr();

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (checklistItems[index]['status'] == 'ok'.tr()) {
                        checklistItems[index]['status'] = 'issue'.tr();
                      } else if (checklistItems[index]['status'] == 'issue'.tr()) {
                        checklistItems[index]['status'] = 'ok'.tr();
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
                              isOK ? 'ok'.tr() : 'issue'.tr(),
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
