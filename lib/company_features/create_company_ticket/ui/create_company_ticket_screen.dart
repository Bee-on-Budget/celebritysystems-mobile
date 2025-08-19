import 'dart:io';

import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/image_picker_widget.dart';
import '../../../core/widgets/primary_button.dart';

class CreateCompanyTicketScreen extends StatefulWidget {
  final List<CompanyScreenModel> screensList;
  const CreateCompanyTicketScreen({super.key, required this.screensList});

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
  CompanyScreenModel? _selectedScreenModel;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
  }

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
      if (_selectedScreenModel == null) {
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
- Screen: ${_selectedScreenModel!.name}
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

  Widget _buildScreenDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<CompanyScreenModel>(
        value: _selectedScreenModel,
        decoration: InputDecoration(
          labelText: 'Screen/Section',
          prefixIcon: const Icon(Icons.computer),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: ColorsManager.slateGray),
        ),
        hint: const Text('Select affected screen'),
        items: widget.screensList.map((CompanyScreenModel screen) {
          // Create unique display name
          String displayName = screen.name ?? 'Unknown';
          if (screen.location != null) {
            displayName += ' (${screen.location})';
          } else if (screen.screenType != null) {
            displayName += ' (${screen.screenType})';
          } else if (screen.id != null) {
            displayName += ' (ID: ${screen.id})';
          }

          return DropdownMenuItem<CompanyScreenModel>(
            value: screen,
            child: Text(displayName),
          );
        }).toList(),
        onChanged: (CompanyScreenModel? value) {
          setState(() {
            _selectedScreenModel = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a screen/section';
          }
          return null;
        },
        dropdownColor: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildScreenDetailsCard() {
    if (_selectedScreenModel == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsManager.freshMint.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorsManager.freshMint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: ColorsManager.freshMint,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Screen Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.slateGray,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Screen Details
          _buildDetailRow('Screen Name', _selectedScreenModel?.name ?? 'N/A',
              Icons.computer),
          if (_selectedScreenModel?.screenType != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow('Screen Type', _selectedScreenModel!.screenType!,
                Icons.category),
          ],
          if (_selectedScreenModel?.location != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
                'Location', _selectedScreenModel!.location!, Icons.location_on),
          ],
          if (_selectedScreenModel?.solutionType != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow('Solution Type',
                _selectedScreenModel!.solutionType!, Icons.build),
          ],
          if (_selectedScreenModel!.id != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(
                'Screen ID', _selectedScreenModel!.id.toString(), Icons.tag),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: ColorsManager.coralBlaze.withOpacity(0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.slateGray,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorsManager.slateGray,
                ),
              ),
            ],
          ),
        ),
      ],
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
              _buildScreenDropdown(),

              // Screen Details Card
              _buildScreenDetailsCard(),

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


// class CreateCompanyTicketScreen extends StatefulWidget {
//   final List<CompanyScreenModel> screensList;
//   const CreateCompanyTicketScreen({super.key, required this.screensList});

//   @override
//   State<CreateCompanyTicketScreen> createState() =>
//       _CreateCompanyTicketScreenState();
// }

// class _CreateCompanyTicketScreenState extends State<CreateCompanyTicketScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   // final _locationController = TextEditingController();
//   File? _selectedImage;
//   String? _selectedScreen;
//   String? _selectedPriority;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     // _locationController.dispose();
//     super.dispose();
//   }

//   void _submitTicket() {
//     if (_formKey.currentState!.validate()) {
//       // Validate required fields
//       if (_selectedScreen == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select a screen/section'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // TODO: Implement ticket creation logic with image
//       String imageInfo = _selectedImage != null
//           ? ' with image: ${_selectedImage!.path.split('/').last}'
//           : ' without image';

//       String ticketDetails = '''
// Ticket Details:
// - Screen: $_selectedScreen
// - Priority: $_selectedPriority
// - Title: ${_titleController.text}
// - Description: ${_descriptionController.text}
// ''';

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ticket created successfully!$imageInfo'),
//           backgroundColor: ColorsManager.freshMint,
//         ),
//       );

//       print(ticketDetails); // For debugging
//       Navigator.pop(context);
//     }
//   }

//   void _onImageSelected(File? image) {
//     setState(() {
//       _selectedImage = image;
//     });
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required IconData icon,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//     String? hint,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorsManager.paleLavenderBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           filled: true,
//           fillColor: Colors.transparent,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           hintStyle: const TextStyle(color: ColorsManager.slateGray),
//         ),
//         hint: Text(hint ?? 'Select $label'),
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please select $label';
//           }
//           return null;
//         },
//         dropdownColor: ColorsManager.paleLavenderBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   Widget _buildScreenDetailsCard() {
//     if (_selectedScreen == null) return const SizedBox.shrink();

//     // Find the selected screen model
//     CompanyScreenModel? selectedScreenModel = widget.screensList
//         .firstWhere((screen) => screen.name == _selectedScreen);

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(top: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorsManager.freshMint.withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorsManager.freshMint.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.info_outline,
//                   color: ColorsManager.freshMint,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Text(
//                   'Screen Details',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: ColorsManager.slateGray,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // Screen Details
//           _buildDetailRow(
//               'Screen Name', selectedScreenModel.name ?? 'N/A', Icons.computer),
//           if (selectedScreenModel.screenType != null) ...[
//             const SizedBox(height: 12),
//             _buildDetailRow(
//                 'Screen Type', selectedScreenModel.screenType!, Icons.category),
//           ],
//           if (selectedScreenModel.location != null) ...[
//             const SizedBox(height: 12),
//             _buildDetailRow(
//                 'Location', selectedScreenModel.location!, Icons.location_on),
//           ],
//           if (selectedScreenModel.solutionType != null) ...[
//             const SizedBox(height: 12),
//             _buildDetailRow('Solution Type', selectedScreenModel.solutionType!,
//                 Icons.build),
//           ],
//           if (selectedScreenModel.id != null) ...[
//             const SizedBox(height: 12),
//             _buildDetailRow(
//                 'Screen ID', selectedScreenModel.id.toString(), Icons.tag),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           icon,
//           size: 18,
//           color: ColorsManager.coralBlaze.withOpacity(0.7),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: ColorsManager.slateGray,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: ColorsManager.slateGray,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.mistWhite,
//       appBar: AppBar(
//         title: const Text(
//           'Create Support Ticket',
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
//             children: [
//               // Header Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 margin: const EdgeInsets.only(bottom: 24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(
//                       Icons.support_agent,
//                       size: 48,
//                       color: ColorsManager.coralBlaze,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Submit a Support Request',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Fill in the details below to create your ticket',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Screen Selection Dropdown
//               _buildDropdownField(
//                 label: 'Screen/Section',
//                 icon: Icons.computer,
//                 value: _selectedScreen,
//                 items:
//                     widget.screensList.map((screen) => screen.name!).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedScreen = value;
//                   });
//                 },
//                 hint: 'Select affected screen',
//               ),

//               // Screen Details Card
//               _buildScreenDetailsCard(),

//               const SizedBox(height: 16),

//               // Title Field
//               CustomTextField(
//                 label: 'Ticket Title',
//                 icon: Icons.title,
//                 controller: _titleController,
//                 // validator: (value) {
//                 //   if (value == null || value.trim().isEmpty) {
//                 //     return 'Please enter a ticket title';
//                 //   }
//                 //   if (value.trim().length < 5) {
//                 //     return 'Title must be at least 5 characters long';
//                 //   }
//                 //   return null;
//                 // },
//               ),

//               const SizedBox(height: 16),

//               // Description Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: ColorsManager.paleLavenderBlue,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     labelText: 'Description *',
//                     prefixIcon: const Icon(Icons.description),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: 'Describe the issue in detail...',
//                     hintStyle: const TextStyle(color: ColorsManager.slateGray),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter a description';
//                     }
//                     if (value.trim().length < 10) {
//                       return 'Description must be at least 10 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Location Field (Optional)
//               // CustomTextField(
//               //   label: 'Location (Optional)',
//               //   icon: Icons.location_on,
//               //   controller: _locationController,
//               //   // validator: null, // Make it optional
//               // ),

//               const SizedBox(height: 16),

//               // Image Picker Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: ColorsManager.paleLavenderBlue,
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(
//                           Icons.attach_file,
//                           color: ColorsManager.coralBlaze,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Attachment (Optional)',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: ColorsManager.slateGray,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Add a screenshot or image to help us understand the issue',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     ImagePickerWidget(
//                       onImageSelected: _onImageSelected,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Submit Button
//               PrimaryButton(
//                 text: 'Create Support Ticket',
//                 onPressed: _submitTicket,
//               ),

//               const SizedBox(height: 16),

//               // Help Text
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorsManager.freshMint.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: ColorsManager.freshMint.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: ColorsManager.freshMint,
//                       size: 20,
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Our support team will review your ticket and respond within 24 hours.',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: ColorsManager.slateGray,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//*************************************************************************************************\\
//
// */

// import 'dart:io';
// import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/theming/colors.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/widgets/primary_button.dart';
// import '../../../../core/widgets/image_picker_widget.dart';

// class CreateCompanyTicketScreen extends StatefulWidget {
//   final List<CompanyScreenModel> screensList;
//   const CreateCompanyTicketScreen({super.key, required this.screensList});

//   @override
//   State<CreateCompanyTicketScreen> createState() =>
//       _CreateCompanyTicketScreenState();
// }

// class _CreateCompanyTicketScreenState extends State<CreateCompanyTicketScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   // final _locationController = TextEditingController();
//   File? _selectedImage;
//   String? _selectedScreen;
//   String? _selectedPriority;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     // _locationController.dispose();
//     super.dispose();
//   }

//   void _submitTicket() {
//     if (_formKey.currentState!.validate()) {
//       // Validate required fields
//       if (_selectedScreen == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select a screen/section'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       // TODO: Implement ticket creation logic with image
//       String imageInfo = _selectedImage != null
//           ? ' with image: ${_selectedImage!.path.split('/').last}'
//           : ' without image';

//       String ticketDetails = '''
// Ticket Details:
// - Screen: $_selectedScreen
// - Priority: $_selectedPriority
// - Title: ${_titleController.text}
// - Description: ${_descriptionController.text}
// ''';

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ticket created successfully!$imageInfo'),
//           backgroundColor: ColorsManager.freshMint,
//         ),
//       );

//       print(ticketDetails); // For debugging
//       Navigator.pop(context);
//     }
//   }

//   void _onImageSelected(File? image) {
//     setState(() {
//       _selectedImage = image;
//     });
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required IconData icon,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//     String? hint,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorsManager.paleLavenderBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           filled: true,
//           fillColor: Colors.transparent,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           hintStyle: const TextStyle(color: ColorsManager.slateGray),
//         ),
//         hint: Text(hint ?? 'Select $label'),
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please select $label';
//           }
//           return null;
//         },
//         dropdownColor: ColorsManager.paleLavenderBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorsManager.mistWhite,
//       appBar: AppBar(
//         title: const Text(
//           'Create Support Ticket',
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
//             children: [
//               // Header Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 margin: const EdgeInsets.only(bottom: 24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(
//                       Icons.support_agent,
//                       size: 48,
//                       color: ColorsManager.coralBlaze,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Submit a Support Request',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Fill in the details below to create your ticket',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Screen Selection Dropdown
//               _buildDropdownField(
//                 label: 'Screen/Section',
//                 icon: Icons.computer,
//                 value: _selectedScreen,
//                 items:
//                     widget.screensList.map((screen) => screen.name!).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedScreen = value;
//                   });
//                 },
//                 hint: 'Select affected screen',
//               ),

//               const SizedBox(height: 16),

//               // Title Field
//               CustomTextField(
//                 label: 'Ticket Title',
//                 icon: Icons.title,
//                 controller: _titleController,
//                 // validator: (value) {
//                 //   if (value == null || value.trim().isEmpty) {
//                 //     return 'Please enter a ticket title';
//                 //   }
//                 //   if (value.trim().length < 5) {
//                 //     return 'Title must be at least 5 characters long';
//                 //   }
//                 //   return null;
//                 // },
//               ),

//               const SizedBox(height: 16),

//               // Description Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: ColorsManager.paleLavenderBlue,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     labelText: 'Description *',
//                     prefixIcon: const Icon(Icons.description),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: 'Describe the issue in detail...',
//                     hintStyle: const TextStyle(color: ColorsManager.slateGray),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter a description';
//                     }
//                     if (value.trim().length < 10) {
//                       return 'Description must be at least 10 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Location Field (Optional)
//               // CustomTextField(
//               //   label: 'Location (Optional)',
//               //   icon: Icons.location_on,
//               //   controller: _locationController,
//               //   // validator: null, // Make it optional
//               // ),

//               const SizedBox(height: 16),

//               // Image Picker Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: ColorsManager.paleLavenderBlue,
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(
//                           Icons.attach_file,
//                           color: ColorsManager.coralBlaze,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Attachment (Optional)',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: ColorsManager.slateGray,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Add a screenshot or image to help us understand the issue',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: ColorsManager.slateGray,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     ImagePickerWidget(
//                       onImageSelected: _onImageSelected,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Submit Button
//               PrimaryButton(
//                 text: 'Create Support Ticket',
//                 onPressed: _submitTicket,
//               ),

//               const SizedBox(height: 16),

//               // Help Text
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorsManager.freshMint.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: ColorsManager.freshMint.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: ColorsManager.freshMint,
//                       size: 20,
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Our support team will review your ticket and respond within 24 hours.',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: ColorsManager.slateGray,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



























//******************* ************************************** ********************************************
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
