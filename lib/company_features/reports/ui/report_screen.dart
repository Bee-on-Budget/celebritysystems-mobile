import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import 'package:celebritysystems_mobile/company_features/home/logic/company_home_cubit/company_home_state.dart'
    as company_state;
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_response.dart';
import 'package:celebritysystems_mobile/company_features/reports/logic/cubit/report_cubit.dart';
import 'package:celebritysystems_mobile/company_features/reports/logic/cubit/report_state.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // List to store selected card IDs
  List<int> selectedCardIds = [];

  // Date selection variables
  DateTime? startDate;
  DateTime? endDate;

  // Report cubit
  late ReportCubit _reportCubit;

  @override
  void initState() {
    super.initState();
    _reportCubit = getIt<ReportCubit>();
    _loadCompanyScreens();
  }

  Future<void> _loadCompanyScreens() async {
    int companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);
    if (!mounted) return; // ✅ ensures widget is still in the tree
    context.read<CompanyHomeCubit>().loadCompanyScreensData(companyId);
  }

  @override
  void dispose() {
    _reportCubit.close();
    super.dispose();
  }

  void _toggleCardSelection(int? cardId) {
    if (cardId == null) return;

    setState(() {
      if (selectedCardIds.contains(cardId)) {
        selectedCardIds.remove(cardId);
      } else {
        selectedCardIds.add(cardId);
      }
    });

    // Print selected IDs for debugging
    print('Selected Card IDs: $selectedCardIds');
  }

  bool _isCardSelected(int? cardId) {
    return cardId != null && selectedCardIds.contains(cardId);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Start Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsManager.royalIndigo,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorsManager.graphiteBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        // If end date is before start date, reset end date
        if (endDate != null && endDate!.isBefore(picked)) {
          endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select End Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsManager.royalIndigo,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorsManager.graphiteBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _canGenerateReport() {
    return selectedCardIds.isNotEmpty && startDate != null && endDate != null;
  }

  void _generateReport() {
    if (!_canGenerateReport()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please select screens and both start and end dates',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: ColorsManager.softCrimson,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Create the request
    final request = GenerateReportRequest(
      screenIds: selectedCardIds,
      startDate:
          startDate!.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      endDate: endDate!.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      reportType: 'SUMMARY',
    );

    // Call the cubit to generate report
    _reportCubit.generateReport(request);
  }

  Widget _buildSummaryItem(
      IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorsManager.slateGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.graphiteBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerSection() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsManager.royalIndigo.withOpacity(0.05),
            ColorsManager.coralBlaze.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsManager.paleLavenderBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.royalIndigo,
                        ColorsManager.coralBlaze
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.date_range_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Select Date Range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.graphiteBlack,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // Start Date Picker
                Expanded(
                  child: _buildDatePickerCard(
                    'Start Date',
                    _formatDate(startDate),
                    startDate != null,
                    () => _selectStartDate(context),
                  ),
                ),
                SizedBox(width: 16),
                // End Date Picker
                Expanded(
                  child: _buildDatePickerCard(
                    'End Date',
                    _formatDate(endDate),
                    endDate != null,
                    () => _selectEndDate(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerCard(
      String label, String value, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.royalIndigo.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ColorsManager.royalIndigo
                : ColorsManager.paleLavenderBlue,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorsManager.royalIndigo.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: isSelected
                      ? ColorsManager.royalIndigo
                      : ColorsManager.slateGray,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? ColorsManager.royalIndigo
                        : ColorsManager.slateGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? ColorsManager.royalIndigo
                    : ColorsManager.graphiteBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionSummary() {
    if (selectedCardIds.isEmpty && startDate == null && endDate == null) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsManager.royalIndigo.withOpacity(0.1),
            ColorsManager.coralBlaze.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsManager.royalIndigo.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorsManager.royalIndigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.summarize_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Selection Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.royalIndigo,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (selectedCardIds.isNotEmpty) ...[
            _buildSummaryRow(
              Icons.screen_share_rounded,
              'Selected Screens',
              '${selectedCardIds.length}',
              ColorsManager.royalIndigo,
            ),
            SizedBox(height: 8),
          ],
          if (startDate != null || endDate != null) ...[
            _buildSummaryRow(
              Icons.calendar_today_rounded,
              'Date Range',
              '${_formatDate(startDate)} - ${_formatDate(endDate)}',
              ColorsManager.coralBlaze,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorsManager.graphiteBlack,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reportCubit,
      child: BlocBuilder<ReportCubit, ReportState<GenerateReportResponse>>(
        builder: (context, state) {
          // Handle state changes
          if (state is Loading<GenerateReportResponse>) {
            // Show loading indicator
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Generating report...'),
                    ],
                  ),
                  backgroundColor: ColorsManager.royalIndigo,
                  duration: Duration(seconds: 2),
                ),
              );
            });
          } else if (state is Success<GenerateReportResponse>) {
            // Show success dialog with report data
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showReportResultsDialog(state.data);
            });
          } else if (state is Error<GenerateReportResponse>) {
            // Show error message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: ColorsManager.softCrimson,
                ),
              );
            });
          }

          return Scaffold(
            backgroundColor: ColorsManager.mistWhite,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
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
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.assessment_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Report Generator',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              actions: [
                // Show count of selected items
                Container(
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${selectedCardIds.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Date Picker Section
                _buildDatePickerSection(),

                // Selection Summary
                _buildSelectionSummary(),

                if (selectedCardIds.isNotEmpty ||
                    startDate != null ||
                    endDate != null)
                  SizedBox(height: 20),

                // Cards list
                BlocBuilder<CompanyHomeCubit, company_state.CompanyHomeState>(
                  builder: (context, state) {
                    if (state is company_state.Error) {
                      return Center(
                        child: Text("Error"),
                      );
                    } else if (state is company_state.Loading) {
                      return Center(
                        child: Text("Loading"),
                      );
                    } else if (state is company_state.Success) {
                      final List<CompanyScreenModel> screens = state.data;
                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: screens.length,
                          itemBuilder: (context, index) {
                            final company = screens[index];
                            final isSelected = _isCardSelected(company.id);

                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: isSelected ? 12 : 4,
                                shadowColor: isSelected
                                    ? ColorsManager.royalIndigo.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () => _toggleCardSelection(company.id),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: isSelected
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                ColorsManager.royalIndigo
                                                    .withOpacity(0.1),
                                                ColorsManager.coralBlaze
                                                    .withOpacity(0.05),
                                              ],
                                            )
                                          : null,
                                      border: isSelected
                                          ? Border.all(
                                              color: ColorsManager.royalIndigo,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          // Selection indicator
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? ColorsManager.royalIndigo
                                                    : ColorsManager
                                                        .paleLavenderBlue,
                                                width: 2,
                                              ),
                                              color: isSelected
                                                  ? ColorsManager.royalIndigo
                                                  : Colors.transparent,
                                            ),
                                            child: isSelected
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 20),

                                          // Card content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  company.name ?? 'No Name',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? ColorsManager
                                                            .royalIndigo
                                                        : ColorsManager
                                                            .graphiteBlack,
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                if (company.screenType != null)
                                                  _buildInfoRow(
                                                    Icons.category_rounded,
                                                    company.screenType!,
                                                    isSelected,
                                                  ),
                                                if (company.location != null)
                                                  _buildInfoRow(
                                                    Icons.location_on_rounded,
                                                    company.location!,
                                                    isSelected,
                                                  ),
                                                if (company.solutionType !=
                                                    null)
                                                  _buildInfoRow(
                                                    Icons.settings_rounded,
                                                    company.solutionType!,
                                                    isSelected,
                                                  ),
                                                if (company.id != null)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: ColorsManager
                                                            .paleLavenderBlue
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        'ID: ${company.id}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorsManager
                                                              .slateGray,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
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
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: Text("No State"),
                    );
                  },
                ),
              ],
            ),

            // Generate Report Button
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.extended(
                heroTag: 'generate_report_button',
                onPressed: _generateReport,
                label: Text(
                  _canGenerateReport() ? 'Generate Report' : 'Select Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                icon: Icon(
                  _canGenerateReport()
                      ? Icons.rocket_launch_rounded
                      : Icons.warning_rounded,
                  size: 24,
                ),
                backgroundColor: _canGenerateReport()
                    ? ColorsManager.royalIndigo
                    : ColorsManager.slateGray,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportResultsDialog(GenerateReportResponse reportData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: ColorsManager.royalIndigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.assessment_rounded,
                color: ColorsManager.royalIndigo,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Generated Report',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.graphiteBlack,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: 0.6.sh, // Max 60% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryItem(
                  Icons.screen_share_rounded,
                  'Report Type',
                  reportData.reportType,
                  ColorsManager.royalIndigo,
                ),
                SizedBox(height: 12.h),
                _buildSummaryItem(
                  Icons.calendar_today_rounded,
                  'Date Range',
                  '${reportData.startDate} - ${reportData.endDate}',
                  ColorsManager.coralBlaze,
                ),
                SizedBox(height: 12.h),
                _buildSummaryItem(
                  Icons.info_outline_rounded,
                  'Total Components',
                  '${reportData.totalCounts.overallTotal}',
                  ColorsManager.slateGray,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Component Breakdown:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.graphiteBlack,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                ...reportData.totalCounts.componentTotals.entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  color: ColorsManager.slateGray,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value}',
                              style: TextStyle(
                                color: ColorsManager.royalIndigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reportCubit.resetState();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.royalIndigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                minimumSize: Size(double.infinity, 44.h),
              ),
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? ColorsManager.royalIndigo.withOpacity(0.7)
                : ColorsManager.slateGray,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? ColorsManager.royalIndigo.withOpacity(0.8)
                    : ColorsManager.slateGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
