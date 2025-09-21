import 'dart:io';

import 'package:celebritysystems_mobile/company_features/create_company_ticket/logic/cubit/create_ticket_cubit.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/logic/cubit/create_ticket_state.dart';
import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/ui/widget/service_type_card.dart';
import 'package:celebritysystems_mobile/core/widgets/image_or_video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routing/routes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class CreateTicketScreen extends StatefulWidget {
  final List<CompanyScreenModel> screensList;
  const CreateTicketScreen({super.key, required this.screensList});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo; // Add video support
  CompanyScreenModel? _selectedScreenModel;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTicket() async {
    if (!_validateForm()) return;

    final companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);

    // Update the create ticket request object
    final cubit = context.read<CreateTicketCubit>();
    cubit.createCompanyTicketReq?.title = _titleController.text.trim();
    cubit.createCompanyTicketReq?.description =
        _descriptionController.text.trim();
    cubit.createCompanyTicketReq?.companyId = companyId;
    cubit.createCompanyTicketReq?.screenId = _selectedScreenModel!.id;
    cubit.createCompanyTicketReq?.status = "OPEN";

    // Get the selected media file (either image or video)
    final mediaFile = _selectedImage ?? _selectedVideo;

    // Create the ticket with media file
    cubit.createCompanyTicket(
      cubit.createCompanyTicketReq!,
      mediaFile,
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedScreenModel == null) {
      _showErrorSnackBar('please_select_a_screen'.tr());
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ColorsManager.freshMint,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Updated to handle both image and video
  void _onMediaSelected(File? image, File? video) {
    setState(() {
      _selectedImage = image;
      _selectedVideo = video;
    });
  }

  // // Keep for backward compatibility if used elsewhere
  // void _onImageSelected(File? image) {
  //   setState(() {
  //     _selectedImage = image;
  //     _selectedVideo = null; // Clear video when image is selected
  //   });
  // }

  void _onScreenSelected(CompanyScreenModel? screen) {
    setState(() {
      _selectedScreenModel = screen;
    });
  }

  // Helper methods for media handling
  bool get hasMediaSelected => _selectedImage != null || _selectedVideo != null;
  File? get selectedMediaFile => _selectedImage ?? _selectedVideo;
  bool get isVideoSelected => _selectedVideo != null;
  String get mediaTypeDisplayText =>
      isVideoSelected ? 'video'.tr() : 'image'.tr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      appBar: _buildAppBar(),
      body: BlocConsumer<CreateTicketCubit, CreateTicketState>(
        listener: (context, state) {
          if (state is Success) {
            _showSuccessSnackBar('support_ticket_created_successfully'.tr());
            context.pushNamedAndRemoveUntil(
              Routes.companyHomeScreen,
              predicate: (route) => false,
            );
          } else if (state is Error) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 24),
                  _buildScreenDropdown(),
                  _buildScreenDetailsCard(),
                  const SizedBox(height: 16),
                  MyServicePage(),
                  const SizedBox(height: 16),
                  _buildTitleField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildMediaPickerSection(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(state),
                  const SizedBox(height: 16),
                  _buildHelpText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'create_support_ticket'.tr(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsManager.royalIndigo,
              ColorsManager.coralBlaze,
            ],
          ),
        ),
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            size: 48,
            color: ColorsManager.coralBlaze,
          ),
          const SizedBox(height: 8),
          Text(
            'submit_a_support_request'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorsManager.slateGray,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'fill_in_the_details_below_to_create_your_ticket'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: ColorsManager.slateGray,
            ),
          ),
        ],
      ),
    );
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
          labelText: 'screen*'.tr(),
          prefixIcon: const Icon(Icons.computer),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: ColorsManager.slateGray),
        ),
        hint: Text('select_affected_screen'.tr()),
        items: widget.screensList.map((CompanyScreenModel screen) {
          return DropdownMenuItem<CompanyScreenModel>(
            value: screen,
            child: SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.6, // control width,
                child: Text(
                  _getScreenDisplayName(screen),
                  overflow: TextOverflow.ellipsis, // show "..." if too long
                  maxLines: 1,
                )),
          );
        }).toList(),
        onChanged: _onScreenSelected,
        validator: (value) {
          if (value == null) {
            return 'please_select_a_screen'.tr();
          }
          return null;
        },
        dropdownColor: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String _getScreenDisplayName(CompanyScreenModel screen) {
    String displayName = screen.name ?? 'unknown'.tr();
    if (screen.location != null) {
      displayName += ' (${screen.location})';
    } else if (screen.screenType != null) {
      displayName += ' (${screen.screenType})';
    } else if (screen.id != null) {
      displayName += ' (ID: ${screen.id})';
    }
    return displayName;
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
          _buildDetailsHeader(),
          const SizedBox(height: 16),
          ..._buildScreenDetailsList(),
        ],
      ),
    );
  }

  Widget _buildDetailsHeader() {
    return Row(
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
        Expanded(
          child: Text(
            'screen_details'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsManager.slateGray,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScreenDetailsList() {
    final details = <Widget>[];
    final screen = _selectedScreenModel!;

    details.add(_buildDetailRow(
        'screen_name'.tr(), screen.name ?? 'N/A', Icons.computer));

    if (screen.screenType != null) {
      details.add(const SizedBox(height: 12));
      details.add(_buildDetailRow(
          'Screen_type'.tr(), screen.screenType!, Icons.category));
    }

    if (screen.location != null) {
      details.add(const SizedBox(height: 12));
      details.add(_buildDetailClickableLinkRow(
          'location'.tr(), screen.location!, Icons.location_on));
    }

    if (screen.solutionType != null) {
      details.add(const SizedBox(height: 12));
      details.add(_buildDetailRow(
          'solution_type'.tr(), screen.solutionType!, Icons.build));
    }

    if (screen.id != null) {
      details.add(const SizedBox(height: 12));
      details.add(
          _buildDetailRow('screen_id'.tr(), screen.id.toString(), Icons.tag));
    }

    return details;
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

  Widget _buildDetailClickableLinkRow(String label, String url, IconData icon) {
    final uri = Uri.tryParse(url);
    final isValid =
        uri != null && (uri.isScheme("http") || uri.isScheme("https"));

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
              GestureDetector(
                onTap: () async {
                  if (isValid && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint("Invalid or unlaunchable URL: $url");
                  }
                },
                child: Text(
                  'View the location on Google Maps',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return CustomTextField(
      label: 'ticket_title*'.tr(),
      icon: Icons.title,
      controller: _titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'please_enter_a_ticket_title'.tr();
        }
        if (value.trim().length < 5) {
          return 'Title must be at least 5 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.paleLavenderBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'description*'.tr(),
          prefixIcon: const Icon(Icons.description),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'describe_the_issue_in_detail'.tr(),
          hintStyle: const TextStyle(color: ColorsManager.slateGray),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'please_enter_a_description'.tr();
          }
          if (value.trim().length < 10) {
            return 'description_must_be_at_least_10_characters_long'.tr();
          }
          return null;
        },
      ),
    );
  }

  // Updated to use new media picker widget
  Widget _buildMediaPickerSection() {
    return Container(
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
          Row(
            children: [
              const Icon(
                Icons.attach_file,
                color: ColorsManager.coralBlaze,
              ),
              SizedBox(width: 8),
              Text(
                'attachment_optional'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.slateGray,
                ),
              ),
              if (hasMediaSelected) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColorsManager.freshMint.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    mediaTypeDisplayText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: ColorsManager.freshMint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'add_a_photo_or_video_to_help_us_understand_the_issue'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: ColorsManager.slateGray,
            ),
          ),
          const SizedBox(height: 12),
          ImageOrVideoWidget(
            onMediaSelected: _onMediaSelected,
            initialImagePath: _selectedImage?.path,
            initialVideoPath: _selectedVideo?.path,
          ),
          // ImagePickerWidget(
          //   onMediaSelected: _onMediaSelected,
          //   initialImagePath: _selectedImage?.path,
          //   initialVideoPath: _selectedVideo?.path,
          // ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(CreateTicketState state) {
    final isLoading = state is Loading;

    return PrimaryButton(
      text:
          isLoading ? 'creating_ticket...'.tr() : 'create_support_ticket'.tr(),
      onPressed: _submitTicket,
    );
  }

  Widget _buildHelpText() {
    return Container(
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
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: ColorsManager.freshMint,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'our_support_team_will_review_your_ticket_and_respond_within_24_hours'
                  .tr(),
              style: const TextStyle(
                fontSize: 12,
                color: ColorsManager.slateGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
