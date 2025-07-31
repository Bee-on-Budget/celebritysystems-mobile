import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

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
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _googleMapsLinkController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _googleMapsLinkController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement ticket creation logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket created successfully!'),
          backgroundColor: ColorsManager.freshMint,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: AppBar(
        title: const Text(
          'Create Ticket',
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
            spacing: 16,
            children: [
              // Title Field
              CustomTextField(
                label: 'Ticket Title',
                icon: Icons.title,
                controller: _titleController,
              ),

              // Description Field
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  filled: true,
                  fillColor: ColorsManager.paleLavenderBlue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: ColorsManager.slateGray),
                ),
              ),
              // Location Field
              CustomTextField(
                label: 'Location',
                icon: Icons.location_on,
                controller: _locationController,
              ),
              // TODO:: add dropdown to screens

              // TODO:: add capture a picture button or add new photo
              const SizedBox(height: 16),

              // Submit Button
              PrimaryButton(
                text: 'Create Ticket',
                onPressed: _submitTicket,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
