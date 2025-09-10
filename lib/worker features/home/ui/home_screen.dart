import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_state.dart';
import 'package:celebritysystems_mobile/worker%20features/home/ui/ticket_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/routing/routes.dart';
import '../../../features/login/logic/user cubit/user_cubit.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Animation controllers for the border effect
  late AnimationController _borderController;
  late Animation<double> _borderAnimation;
  int? _highlightedTicketId;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Initialize border animation controller
    _borderController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeInOut),
    );

    final username = context.read<UserCubit>().state?.username ?? 'default';
    context.read<HomeCubit>().loadHomeData(username);
    _fadeController.forward();

    // IMPORTANT: Use addPostFrameCallback to ensure the route is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationTicketId = ModalRoute.of(context)?.settings.arguments;

      debugPrint("=== HOME SCREEN ARGUMENTS DEBUG ===");
      debugPrint("Raw arguments: $notificationTicketId");
      debugPrint("Arguments type: ${notificationTicketId.runtimeType}");

      int? ticketId;

      // Handle different argument types
      if (notificationTicketId is int) {
        ticketId = notificationTicketId;
      } else if (notificationTicketId is String) {
        ticketId = int.tryParse(notificationTicketId);
      } else if (notificationTicketId != null) {
        ticketId = int.tryParse(notificationTicketId.toString());
      }

      debugPrint("Parsed ticket ID: $ticketId");
      debugPrint("=== END HOME SCREEN ARGUMENTS DEBUG ===");

      if (ticketId != null && ticketId > 0) {
        setState(() {
          _highlightedTicketId = ticketId;
        });
        _startBorderAnimation();
        debugPrint("Starting highlight animation for ticket ID: $ticketId");
      } else {
        debugPrint("No valid notification ticket ID found, skipping animation");
      }
    });
  }

  void _startBorderAnimation() {
    _borderController.forward().then((_) {
      // Reset the highlighted ticket after animation completes
      if (mounted) {
        setState(() {
          _highlightedTicketId = null;
        });
        _borderController.reset();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  String _formatDate(String iso) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(iso));
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF4A90E2);
      case 'in progress':
        return const Color(0xFF7B68EE);
      case 'closed':
        return const Color(0xFF28C76F);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  Future<void> handleLogout() async {
    final userCubit = context.read<UserCubit>();
    final user = context.read<UserCubit>().state;
    // Clear user state
    userCubit.logout(user!.userId!);

    // Navigate to login screen
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent auto pop
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is Loading) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsManager.mistWhite,
                        ColorsManager.coralBlaze.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              } else if (state is Error) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsManager.coralBlaze,
                        Colors.red.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          state.error,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is Success<List<OneTicketResponse>>) {
                final tickets = state.data.reversed.toList();

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "my_tickets".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(128, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          BlocBuilder<LanguageCubit, LanguageState>(
                            builder: (context, state) {
                              return IconButton(
                                icon: Icon(
                                  Icons.translate,
                                ),
                                onPressed: () {
                                  context
                                      .read<LanguageCubit>()
                                      .toggleLanguage(context);
                                  // context.read<LanguageCubit>().changeLanguage(context, "an");
                                  setState(() {});
                                },
                                tooltip: 'Switch to English',
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('logout'.tr()),
                                  content: Text(
                                      'are_you_sure_you_want_to_logout'.tr()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('no'.tr()),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('yes'.tr()),
                                    ),
                                  ],
                                ),
                              );
                              if (shouldLogout ?? false) {
                                await handleLogout();
                              }
                            },
                            tooltip: 'logout'.tr(),
                          ),
                        ],
                        expandedHeight: 280.h,
                        floating: false,
                        pinned: true,
                        elevation: 0,
                        backgroundColor: ColorsManager.coralBlaze,
                        foregroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Stats cards with improved spacing
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatsCard(
                                          "assigned".tr(),
                                          context
                                              .read<HomeCubit>()
                                              .assignedCount
                                              .toString(),
                                          Icons.assignment,
                                          Colors.white.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: _buildStatsCard(
                                          "completed".tr(),
                                          context
                                              .read<HomeCubit>()
                                              .completedCount
                                              .toString(),
                                          Icons.check_circle_outline,
                                          Colors.white.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Improved TabBar design
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorPadding: EdgeInsets.all(4),
                                    labelColor: Colors.white,
                                    unselectedLabelColor:
                                        Colors.white.withValues(alpha: 0.7),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    dividerColor: Colors
                                        .transparent, // Remove the ugly line
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.white.withValues(alpha: 0.1),
                                    ),
                                    tabs: [
                                      Tab(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Text('active'.tr()),
                                        ),
                                      ),
                                      Tab(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Text('completed'.tr()),
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
                      SliverFillRemaining(
                        child: TabBarView(
                          children: [
                            _buildTicketList(tickets
                                .where(
                                    (t) => t.status?.toLowerCase() != 'closed')
                                .toList()),
                            _buildTicketList(tickets
                                .where(
                                    (t) => t.status?.toLowerCase() == 'closed')
                                .toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      String title, String count, IconData icon, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 8.h),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList(List<OneTicketResponse> tickets) {
    return RefreshIndicator(
      onRefresh: () async {
        String username =
            await SharedPrefHelper.getString(SharedPrefKeys.username);
        await context.read<HomeCubit>().loadHomeData(username);
      },
      child: tickets.isEmpty
          ? ListView(
              // RefreshIndicator requires a scrollable child
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300, // ensure enough space to allow pull-down gesture
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "no_tickets_in_this_tab".tr(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final isHighlighted = ticket.id == _highlightedTicketId;

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _borderAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // Animated border for highlighted ticket
                          border: isHighlighted
                              ? Border.all(
                                  color: Color.lerp(
                                    ColorsManager.coralBlaze,
                                    ColorsManager.coralBlaze
                                        .withValues(alpha: 0.3),
                                    ((1 +
                                            math.sin(_borderAnimation.value *
                                                4 *
                                                math.pi)) /
                                        2),
                                  )!,
                                  width: 3.0,
                                )
                              : null,
                          // Animated glow effect
                          boxShadow: isHighlighted
                              ? [
                                  BoxShadow(
                                    color: ColorsManager.coralBlaze.withValues(
                                      alpha: 0.4 *
                                          ((1 +
                                                  math.sin(
                                                      _borderAnimation.value *
                                                          4 *
                                                          math.pi)) /
                                              2),
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Container(
                          margin: EdgeInsets.all(isHighlighted ? 2.0 : 0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.grey.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child:
                                          TicketDetailsScreen(ticket: ticket),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: ColorsManager.coralBlaze
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.confirmation_number_outlined,
                                            color: ColorsManager.coralBlaze,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            ticket.title ?? "-",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1A1A1A),
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    _infoRow(Icons.business_outlined,
                                        ticket.companyName ?? ""),
                                    _infoRow(Icons.person_outline,
                                        "By: ${ticket.assignedBySupervisorName}"),
                                    _infoRow(Icons.monitor_outlined,
                                        ticket.screenName ?? ""),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _statusColor(
                                                ticket.status ?? ""),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _statusColor(
                                                        ticket.status ?? "")
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            ticket.status ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                _formatDate(
                                                    ticket.createdAt ?? ""),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
              },
            ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF4A4A4A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
