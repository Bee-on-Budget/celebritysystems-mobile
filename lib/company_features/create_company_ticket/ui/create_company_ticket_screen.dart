import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/image_picker_widget.dart';

class CreateCompanyTicketScreen extends StatefulWidget {
  const CreateCompanyTicketScreen({super.key});

  @override
  State<CreateCompanyTicketScreen> createState() =>
      _CreateCompanyTicketScreenState();
}

class _CreateCompanyTicketScreenState extends State<CreateCompanyTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final _locationController = TextEditingController();
  File? _selectedImage;
  String? _selectedScreen;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();

    // final listOfCompanyScreens = context.read<TicketCubit>();
  }

  // Static list of screen names
  static const List<String> screenNames = [
    'LG',
    'Samsung',
    'Review',
    'LCD',
    'LOD',
    'Toshipa',
    'Dell',
    'HP',
    'Treview',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // _locationController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // Validate required fields
      if (_selectedScreen == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a screen/section'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Implement ticket creation logic with image
      String imageInfo = _selectedImage != null
          ? ' with image: ${_selectedImage!.path.split('/').last}'
          : ' without image';

      String ticketDetails = '''
Ticket Details:
- Screen: $_selectedScreen
- Priority: $_selectedPriority
- Title: ${_titleController.text}
- Description: ${_descriptionController.text}
''';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket created successfully!$imageInfo'),
          backgroundColor: ColorsManager.freshMint,
        ),
      );

      print(ticketDetails); // For debugging
      Navigator.pop(context);
    }
  }

  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: ColorsManager.slateGray),
        ),
        hint: Text(hint ?? 'Select $label'),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
        dropdownColor: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: AppBar(
        title: const Text(
          'Create Support Ticket',
          style: TextStyle(
            color: ColorsManager.mistWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ColorsManager.coralBlaze,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 48,
                      color: ColorsManager.coralBlaze,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Submit a Support Request',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.slateGray,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Fill in the details below to create your ticket',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsManager.slateGray,
                      ),
                    ),
                  ],
                ),
              ),

              // Screen Selection Dropdown
              _buildDropdownField(
                label: 'Screen/Section',
                icon: Icons.computer,
                value: _selectedScreen,
                items: screenNames,
                onChanged: (value) {
                  setState(() {
                    _selectedScreen = value;
                  });
                },
                hint: 'Select affected screen',
              ),

              const SizedBox(height: 16),

              // Title Field
              CustomTextField(
                label: 'Ticket Title',
                icon: Icons.title,
                controller: _titleController,
                // validator: (value) {
                //   if (value == null || value.trim().isEmpty) {
                //     return 'Please enter a ticket title';
                //   }
                //   if (value.trim().length < 5) {
                //     return 'Title must be at least 5 characters long';
                //   }
                //   return null;
                // },
              ),

              const SizedBox(height: 16),

              // Description Field
              Container(
                decoration: BoxDecoration(
                  color: ColorsManager.paleLavenderBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    prefixIcon: const Icon(Icons.description),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Describe the issue in detail...',
                    hintStyle: const TextStyle(color: ColorsManager.slateGray),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Location Field (Optional)
              // CustomTextField(
              //   label: 'Location (Optional)',
              //   icon: Icons.location_on,
              //   controller: _locationController,
              //   // validator: null, // Make it optional
              // ),

              const SizedBox(height: 16),

              // Image Picker Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorsManager.paleLavenderBlue,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: ColorsManager.coralBlaze,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Attachment (Optional)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.slateGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a screenshot or image to help us understand the issue',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsManager.slateGray,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ImagePickerWidget(
                      onImageSelected: _onImageSelected,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              PrimaryButton(
                text: 'Create Support Ticket',
                onPressed: _submitTicket,
              ),

              const SizedBox(height: 16),

              // Help Text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsManager.freshMint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsManager.freshMint.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorsManager.freshMint,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Our support team will review your ticket and respond within 24 hours.',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorsManager.slateGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';

// import '../../../../core/theming/colors.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/widgets/primary_button.dart';
// import '../../../../core/widgets/image_picker_widget.dart';

// class CreateCompanyTicketScreen extends StatefulWidget {
//   const CreateCompanyTicketScreen({super.key});

//   @override
//   State<CreateCompanyTicketScreen> createState() =>
//       _CreateCompanyTicketScreenState();
// }

// class _CreateCompanyTicketScreenState extends State<CreateCompanyTicketScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _contactController = TextEditingController();
//   // final _googleMapsLinkController = TextEditingController();
//   File? _selectedImage;

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _locationController.dispose();
//     _contactController.dispose();
//     // _googleMapsLinkController.dispose();
//     super.dispose();
//   }

//   void _submitTicket() {
//     if (_formKey.currentState!.validate()) {
//       // TODO: Implement ticket creation logic with image
//       String imageInfo = _selectedImage != null
//           ? ' with image: ${_selectedImage!.path.split('/').last}'
//           : ' without image';

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ticket created successfully!$imageInfo'),
//           backgroundColor: ColorsManager.freshMint,
//         ),
//       );
//       Navigator.pop(context);
//     }
//   }

//   void _onImageSelected(File? image) {
//     setState(() {
//       _selectedImage = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.mistWhite,
//       appBar: AppBar(
//         title: const Text(
//           'Create Ticket',
//           style: TextStyle(
//             color: ColorsManager.mistWhite,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: ColorsManager.coralBlaze,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 16,
//             children: [
//               // Title Field
//               CustomTextField(
//                 label: 'Ticket Title',
//                 icon: Icons.title,
//                 controller: _titleController,
//               ),

//               // Description Field
//               TextField(
//                 controller: _descriptionController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Description',
//                   prefixIcon: const Icon(Icons.description),
//                   filled: true,
//                   fillColor: ColorsManager.paleLavenderBlue,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintStyle: const TextStyle(color: ColorsManager.slateGray),
//                 ),
//               ),
//               // Location Field
//               // CustomTextField(
//               //   label: 'Location',
//               //   icon: Icons.location_on,
//               //   controller: _locationController,
//               // ),

//               // Image Picker
//               ImagePickerWidget(
//                 onImageSelected: _onImageSelected,
//               ),

//               const SizedBox(height: 16),

//               // Submit Button
//               PrimaryButton(
//                 text: 'Create Ticket',
//                 onPressed: _submitTicket,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
