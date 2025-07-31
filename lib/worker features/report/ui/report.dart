import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/primary_button.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/widgets/check_list_card.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/widgets/service_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../logic/report cubit/report_cubit.dart';
import 'widgets/info_row_widget.dart';

class ServiceReportScreen extends StatefulWidget {
  const ServiceReportScreen({super.key, required this.ticket});

  final OneTicketResponse ticket;

  @override
  State<ServiceReportScreen> createState() => _ServiceReportScreenState();
}

class _ServiceReportScreenState extends State<ServiceReportScreen> {
  File? _uploadedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildImageUploadCard(),
            const SizedBox(height: 8),
            PrimaryButton(
              text: "Submit",
              onPressed: () {
                print("onPressed");
                // Add uploaded image to the report request
                // context.read<ReportCubit>().reportRequest?.image = _uploadedImage;
                context
                    .read<ReportCubit>()
                    .sendReport(1, context.read<ReportCubit>().reportRequest!);
              },
            )
          ],
        ),
      ),
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

  Widget _buildImageUploadCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt,
                    color: ColorsManager.coralBlaze, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Upload Images',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Attach photos of the service work, equipment, or any relevant documentation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Upload Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _uploadedImage == null
                        ? () => _pickImage(ImageSource.camera)
                        : null,
                    icon: const Icon(Icons.camera_alt, size: 20),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _uploadedImage == null
                          ? ColorsManager.coralBlaze
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _uploadedImage == null
                        ? () => _pickImage(ImageSource.gallery)
                        : null,
                    icon: const Icon(Icons.photo_library, size: 20),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _uploadedImage == null
                          ? Colors.grey[600]
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Display uploaded image
            if (_uploadedImage != null) ...[
              Row(
                children: [
                  Icon(Icons.image, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Uploaded Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildImageDisplay(),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.grey[300]!, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No image uploaded yet',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _uploadedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _replaceImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _uploadedImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Image uploaded successfully!'),
            backgroundColor: Colors.green[600],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _replaceImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _uploadedImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Image removed'),
        backgroundColor: Colors.orange[600],
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
