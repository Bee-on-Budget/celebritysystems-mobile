import 'package:celebritysystems_mobile/company_features/create_company_ticket/logic/cubit/create_ticket_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyServicePage extends StatefulWidget {
  @override
  _MyServicePageState createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  List<Map<String, dynamic>> serviceTypes = [
    {
      'name': 'Preventive Maintenance',
      'checked': false,
      'enum': 'PREVENTIVE_MAINTENANCE'
    },
    {'name': 'Regular Service', 'checked': false, 'enum': 'REGULAR_SERVICE'},
    {
      'name': 'Call Back Service',
      'checked': false,
      'enum': 'CALL_BACK_SERVICE'
    },
    {
      'name': 'Emergency Service',
      'checked': false,
      'enum': 'EMERGENCY_SERVICE'
    },
  ];

  Widget _buildServiceTypeCard(createTicketCubit) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'service_type'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3.5,
              ),
              itemCount: serviceTypes.length,
              itemBuilder: (context, index) {
                final service = serviceTypes[index];
                final isChecked = service['checked'] as bool;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      serviceTypes[index]['checked'] =
                          !serviceTypes[index]['checked'];

                      for (var element in serviceTypes) {
                        if (element["checked"] == true &&
                            element != serviceTypes[index]) {
                          element["checked"] = false;
                        }
                      }
                      print(serviceTypes);

                      for (var element in serviceTypes) {
                        if (element["checked"] == true) {
                          context
                              .read<CreateTicketCubit>()
                              .createCompanyTicketReq
                              ?.serviceType = element["enum"];
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isChecked ? Colors.green[50] : Colors.grey[50],
                      border: Border.all(
                        color: isChecked ? Colors.green : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isChecked ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: isChecked
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            service['name'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isChecked
                                  ? Colors.green[800]
                                  : Colors.grey[600],
                            ),
                          ),
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
    final createTicketCubit = context.read<CreateTicketCubit>();
    return _buildServiceTypeCard(createTicketCubit);
    // Scaffold(
    //   body: SingleChildScrollView(child: _buildServiceTypeCard()),
    // );
  }
}
