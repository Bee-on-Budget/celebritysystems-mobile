import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/image_picker_widget.dart';
import 'package:celebritysystems_mobile/core/widgets/primary_button.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/widgets/check_list_card.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/widgets/service_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../logic/report cubit/report_cubit.dart';
import '../logic/report cubit/report_state.dart';
import 'widgets/info_row_widget.dart';

class ServiceReportScreen extends StatefulWidget {
  const ServiceReportScreen({super.key, required this.ticket});

  final OneTicketResponse ticket;

  @override
  State<ServiceReportScreen> createState() => _ServiceReportScreenState();
}

class _ServiceReportScreenState extends State<ServiceReportScreen> {
  File? _selectedImage;

  // File? _uploadedImage;
  // final ImagePicker _picker = ImagePicker();
  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Report submitted successfully ✅"),
              backgroundColor: Colors.green,
            ),
          );
          context.pushReplacementNamed(Routes.homeScreen);
        } else if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                title: const Text('Service Report'),
                backgroundColor: ColorsManager.coralBlaze,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 16),
                    MyServicePage(),
                    const SizedBox(height: 16),
                    CheckListCardWidget(),
                    const SizedBox(height: 16),
                    _buildServiceDetailsCard(),
                    const SizedBox(height: 16),
                    _buildSignatureCard(),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ImagePickerWidget(
                          onImageSelected: _onImageSelected,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      text: "Submit",
                      onPressed: () {
                        context.read<ReportCubit>().sendReport(
                              widget.ticket.id!,
                              context.read<ReportCubit>().reportRequest!,
                              _selectedImage,
                              null,
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 🔄 Loading overlay
            if (state is Loading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'LED SCREEN SERVICE REPORT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.ticket.screenType ?? "-",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InfoRowWidget(
                          icon: Icons.business,
                          label: 'Company Name',
                          value: widget.ticket.companyName ?? ""),
                      const SizedBox(height: 12),
                      InfoRowWidget(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: widget.ticket.location ?? '_'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      InfoRowWidget(
                          icon: Icons.calendar_today,
                          label: 'Service Date',
                          value: DateFormat('dd/MM/yyyy')
                              .format(DateTime.now())
                              .toString()), // ex: '05/02/2025'
                      const SizedBox(height: 12),
                      InfoRowWidget(
                          icon: Icons.screenshot_monitor_rounded,
                          label: 'Screen Name',
                          value: widget.ticket.screenName ?? 'Not specified'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    final servicesRendered = [
      'Control System',
      'Power Cables',
      'Data Cables',
      'Power Supply',
      'Receiving Cards',
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Services Rendered
            const Text(
              'Services Rendered',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            ...servicesRendered.map((service) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.blue[600], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          service,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 16),

            // Defects Found
            const Text(
              'Defects Found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                border: Border(
                    left: BorderSide(color: Colors.yellow[600]!, width: 4)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextField(
                    onChanged: (defectsFoundValue) {
                      context.read<ReportCubit>().reportRequest?.defectsFound =
                          defectsFoundValue;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.yellow[50],
                      hintText: 'Ex: There was a screen offline.',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        // borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        // borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  )
                      // Text(
                      //   'ex:There was a screen offline.',
                      //   style: TextStyle(fontSize: 14, color: Colors.black87),
                      // ),
                      ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Solutions
            const Text(
              'Solutions Implemented',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(
                    left: BorderSide(color: Colors.green[600]!, width: 4)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: TextField(
                    onChanged: (solutionsProvidedValue) {
                      context
                          .read<ReportCubit>()
                          .reportRequest
                          ?.solutionsProvided = solutionsProvidedValue;
                    },
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.green[50],
                      hintText:
                          'Ex: Restart the router and now is showing online.',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        // borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        // borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  )
                      //  Text(
                      //   'Restart the router and now is showing online.',
                      //   style: TextStyle(fontSize: 14, color: Colors.black87),
                      // ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Signatures',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSignatureBox('Service Supervisor')),
                const SizedBox(width: 12),
                Expanded(child: _buildSignatureBox('Technician')),
                const SizedBox(width: 12),
                Expanded(child: _buildSignatureBox('Authorized Person')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureBox(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              'Signature',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Authorized Signature',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
