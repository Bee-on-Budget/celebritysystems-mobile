import 'package:celebritysystems_mobile/company_features/show_contract/data/model/contract_response.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/logic/contract_cubit/contract_cubit.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/logic/contract_cubit/contract_state.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/widgets/error_widget.dart';
import 'package:celebritysystems_mobile/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _getcontracts();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  Future<void> _getcontracts() async {
    int companyId = await SharedPrefHelper.getInt(SharedPrefKeys.companyId);
    if (!mounted) return;
    context.read<ContractCubit>().getContracts(companyId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'contracts'.tr(),
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocBuilder<ContractCubit, ContractState>(
          builder: (context, state) {
            if (state is Loading) {
              return customLoadingWidget("Loading Contracts...");
            } else if (state is Error) {
              return customErrorWidget(state);
            } else if (state is Success) {
              final contracts = state.data;
              return Column(
                children: [
                  // Stats Header
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem('total_contracts'.tr(),
                              '${contracts.length}', Icons.description),
                        ),
                        // Container(width: 1, height: 40, color: Colors.white24),
                        // Expanded(
                        //   child: _buildStatItem(
                        //       'active'.tr(), '2', Icons.check_circle),
                        // ),
                        Container(width: 1, height: 40, color: Colors.white24),
                        Expanded(
                          child: _buildStatItem(
                              'value'.tr(),
                              '\$${contracts.fold(0.0, (sum, c) => sum + c.contractValue).toStringAsFixed(0)}',
                              Icons.attach_money),
                        ),
                      ],
                    ),
                  ),

                  // Contract List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: contracts.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - _controller.value)),
                              child: Opacity(
                                opacity: _controller.value,
                                child:
                                    _buildContractCard(contracts[index], index),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContractCard(Contract contract, int index) {
    final isExpired = contract.expiredAt.isBefore(DateTime.now());
    final daysUntilExpiry =
        contract.expiredAt.difference(DateTime.now()).inDays;

    return Container(
      margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 8 : 0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: isExpired ? Colors.red.shade200 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isExpired ? Colors.red.shade50 : const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? Colors.red.shade100
                            : const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.description,
                        color: isExpired
                            ? Colors.red.shade600
                            : const Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${"contract".tr()} #${contract.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contract.accountName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(
                        isExpired ? 'expired'.tr() : 'active'.tr(), isExpired),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Contract Info Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'duration'.tr(),
                            contract.durationType.toLowerCase().replaceFirst(
                                contract.durationType[0],
                                contract.durationType[0].toUpperCase()),
                            Icons.schedule,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'value'.tr(),
                            '\$${contract.contractValue.toStringAsFixed(0)}',
                            Icons.attach_money,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'type'.tr(),
                            contract.operatorType.toLowerCase().replaceFirst(
                                contract.operatorType[0],
                                contract.operatorType[0].toUpperCase()),
                            Icons.business,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Date Range
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'start_date'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(contract.startContractAt),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1E293B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 2,
                            decoration: BoxDecoration(
                              color: const Color(0xFF64748B).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'end_date'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(contract.expiredAt),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isExpired
                                        ? Colors.red.shade600
                                        : const Color(0xFF1E293B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isExpired && daysUntilExpiry <= 30) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber,
                                color: Colors.orange.shade600, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Expires in $daysUntilExpiry days',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    //Screens
                    if (contract.screenIds.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (contract.screenIds.isNotEmpty) ...[
                            Expanded(
                              child: _buildBadgeSection(
                                'screens'.tr(),
                                contract.screenIds.map((id) => '#$id').toList(),
                                const Color(0xFF06B6D4),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF3B82F6), size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status, bool isExpired) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isExpired ? Colors.red.shade600 : Colors.green.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBadgeSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan'.tr(),
      'feb'.tr(),
      'mar'.tr(),
      'apr'.tr(),
      'may'.tr(),
      'jun'.tr(),
      'jul'.tr(),
      'aug'.tr(),
      'sep'.tr(),
      'oct'.tr(),
      'nov'.tr(),
      'dec'.tr()
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
