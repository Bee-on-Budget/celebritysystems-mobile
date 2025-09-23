import 'package:video_player/video_player.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/clickable_link.dart';
import 'package:celebritysystems_mobile/core/widgets/primary_button.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/report/ui/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

class TicketDetailsScreen extends StatefulWidget {
  final OneTicketResponse ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  String? mediaLink;
  bool isDownloading = false; // Add loading state

  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  // Add this method to handle download
  void _downloadImage(BuildContext context, int ticketId) async {
    setState(() {
      isDownloading = true;
    });

    try {
      // Create a temporary HomeCubit instance for this operation
      final homeCubit = HomeCubit(getIt());
      final mediaFile = await homeCubit.downloadImage(ticketId);

      setState(() {
        mediaLink = mediaFile;
        isDownloading = false;
      });

      print("mediaFile");
      print(mediaFile);
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      print("Error downloading image: $e");
      // You might want to show a snackbar or error message here
    }
  }

  String _formatDate(String iso) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(DateTime.parse(iso));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildModernAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildTicketHeader(),
                  SizedBox(height: 16.h),
                  _buildDetailsCard(),
                  SizedBox(height: 16.h),
                  clickableLinkWidget(
                      icon: Icons.location_on,
                      title: 'location'.tr(),
                      url: widget.ticket.location ?? "",
                      cardColor: Colors.white),
                  SizedBox(height: 16.h),
                  _buildImageCard(context),
                  SizedBox(height: 16.h),
                  _buildStatusAndActionCard(context),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: ColorsManager.graphiteBlack,
      title: Text(
        "ticket_details".tr(),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: ColorsManager.graphiteBlack,
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 16.sp,
            color: ColorsManager.graphiteBlack,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsManager.coralBlaze,
            ColorsManager.coralBlaze.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.coralBlaze.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.confirmation_number_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  widget.ticket.title ?? "",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (widget.ticket.description?.isNotEmpty == true) ...[
            SizedBox(height: 16.h),
            Text(
              widget.ticket.description!,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ColorsManager.royalIndigo,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "details".tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.graphiteBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildDetailRow(
            Icons.business_outlined,
            "company".tr(),
            widget.ticket.companyName ?? "",
          ),
          _buildDetailRow(
            Icons.monitor_outlined,
            "screen_name".tr(),
            widget.ticket.screenName ?? "",
          ),
          _buildDetailRow(
            Icons.person_outline,
            "assigned_to".tr(),
            widget.ticket.assignedToWorkerName ?? "",
          ),
          _buildDetailRow(
            Icons.supervisor_account_outlined,
            "assigned_by".tr(),
            widget.ticket.assignedBySupervisorName ?? "",
          ),
          _buildDetailRow(
            Icons.schedule_outlined,
            "created_at".tr(),
            _formatDate(widget.ticket.createdAt ?? ""),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: ColorsManager.slateGray,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.slateGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value.isEmpty ? "N/A" : value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.graphiteBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Icon(
                  Icons.image_outlined,
                  color: ColorsManager.royalIndigo,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Ticket Media",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.graphiteBlack,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Download button
                PrimaryButton(
                  text: isDownloading ? "Loading..." : "View Media",
                  onPressed: () => _downloadImage(context, widget.ticket.id!),
                  // isDownloading
                  //   ? null
                  //   : () => _downloadImage(context, widget.ticket.id!),
                ),
                SizedBox(height: 16.h),

                // Image display area
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: mediaLink != null
                          ? () => _showFullScreenImage(context)
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: _buildImageContent(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Helper to check if the link is a video
  bool _isVideo(String? url) {
    if (url == null || url.isEmpty) return false;

    // Convert to lowercase for case-insensitive comparison
    final lowerUrl = url.toLowerCase();

    // Check for common video file extensions
    final videoExtensions = [
      '.mp4',
      '.mov',
      '.avi',
      '.mkv',
      '.webm',
      '.flv',
      '.wmv',
      '.m4v',
      '.3gp',
      '.ogv'
    ];

    // Check if URL ends with any video extension
    for (final ext in videoExtensions) {
      if (lowerUrl.endsWith(ext)) {
        return true;
      }
    }

    // Check for video extensions with query parameters
    for (final ext in videoExtensions) {
      if (lowerUrl.contains(ext)) {
        final index = lowerUrl.indexOf(ext);
        final afterExt = lowerUrl.substring(index + ext.length);
        // If after extension there's only query params or nothing, it's likely a video
        if (afterExt.isEmpty ||
            afterExt.startsWith('?') ||
            afterExt.startsWith('#')) {
          return true;
        }
      }
    }

    return false;
  }

  VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  Future<void> _initializeVideo(String url) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }
    _videoController = VideoPlayerController.network(url);
    await _videoController!.initialize();
    setState(() {
      _videoInitialized = true;
    });
  }

  Widget _buildImageContent() {
    if (isDownloading) {
      return Container(
        color: const Color(0xFFF8FAFC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorsManager.coralBlaze),
            ),
            SizedBox(height: 16.h),
            Text(
              "Downloading media...",
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.slateGray,
              ),
            ),
          ],
        ),
      );
    }

    if (mediaLink == null) {
      return Container(
        color: const Color(0xFFF8FAFC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_outlined,
              size: 48.sp,
              color: ColorsManager.slateGray,
            ),
            SizedBox(height: 8.h),
            Text(
              "Click to view media",
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.slateGray,
              ),
            ),
          ],
        ),
      );
    }

    // Check if it's a video first
    if (_isVideo(mediaLink)) {
      // Initialize video if not already initialized or if URL changed
      if (!_videoInitialized ||
          _videoController == null ||
          _videoController!.dataSource != mediaLink) {
        _videoInitialized = false;
        _initializeVideo(mediaLink!);
        return Container(
          color: const Color(0xFFF8FAFC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorsManager.coralBlaze),
              ),
              SizedBox(height: 16.h),
              Text(
                "Loading video...",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.slateGray,
                ),
              ),
            ],
          ),
        );
      }

      if (!_videoController!.value.isInitialized) {
        return Container(
          color: const Color(0xFFF8FAFC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorsManager.coralBlaze),
              ),
              SizedBox(height: 16.h),
              Text(
                "Initializing video...",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.slateGray,
                ),
              ),
            ],
          ),
        );
      }

      return GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),

            // Video controls overlay
            if (_showControls)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top controls - Video indicator
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "VIDEO",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Spacer(),

                      // Center play/pause button
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 48.sp,
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                        ),
                      ),

                      Spacer(),

                      // Bottom controls
                      Container(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          children: [
                            // Progress bar
                            VideoProgressIndicator(
                              _videoController!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: ColorsManager.coralBlaze,
                                bufferedColor: Colors.white.withOpacity(0.3),
                                backgroundColor: Colors.white.withOpacity(0.1),
                              ),
                            ),

                            SizedBox(height: 1.h),

                            // Time display and controls
                            Row(
                              children: [
                                // Current time / Total time
                                Text(
                                  "${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Spacer(),

                                // Replay button
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.replay,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    onPressed: _replayVideo,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Show/hide controls on video end
            if (_videoController!.value.position >=
                    _videoController!.value.duration &&
                _videoController!.value.duration.inSeconds > 0)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.replay,
                          color: Colors.white,
                          size: 64.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Video Ended",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton.icon(
                          onPressed: _replayVideo,
                          icon: Icon(Icons.replay),
                          label: Text("Replay"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.coralBlaze,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Default: show image
    return Stack(
      children: [
        Image.network(
          mediaLink!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorsManager.coralBlaze),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Loading image...",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorsManager.slateGray,
                    ),
                  ),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF8FAFC),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 48.sp,
                    color: ColorsManager.slateGray,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Failed to load image",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorsManager.slateGray,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 8.w,
          right: 8.w,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.zoom_in,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndActionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag_outlined,
                color: ColorsManager.royalIndigo,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "status".tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.graphiteBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(widget.ticket.status ?? "")
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _statusColor(widget.ticket.status ?? "")
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: _statusColor(widget.ticket.status ?? ""),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.ticket.status ?? "",
                        style: TextStyle(
                          color: _statusColor(widget.ticket.status ?? ""),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.ticket.status == "OPEN") ...[
                SizedBox(width: 12.w),
                _buildSubmitReportButton(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitReportButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => _navigateToReport(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorsManager.slateGray,
                ColorsManager.slateGray.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.slateGray.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_outlined,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "submit_report".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    // Only show if mediaLink is available & not a video

    if (mediaLink == null) return;
    if (_isVideo(mediaLink)) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16.w),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.network(
                      mediaLink!, // Use the actual mediaLink variable
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: EdgeInsets.all(40.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 64.sp,
                                color: ColorsManager.slateGray,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "Image not available",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsManager.slateGray,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                right: 16.w,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24.r),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToReport(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: BlocProvider(
            create: (context) => ReportCubit(getIt()),
            child: ServiceReportScreen(ticket: widget.ticket),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF3B82F6); // Blue
      case 'in progress':
        return const Color(0xFFF59E0B); // Amber
      case 'closed':
        return const Color(0xFF10B981); // Emerald
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
// Add these helper methods to your class:

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _resetHideTimer();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
    _resetHideTimer();
  }

  void _replayVideo() {
    _videoController!.seekTo(Duration.zero);
    _videoController!.play();
    setState(() {
      _showControls = true;
    });
    _resetHideTimer();
  }

  void _resetHideTimer() {
    _hideControlsTimer?.cancel();
    if (_videoController!.value.isPlaying) {
      _hideControlsTimer = Timer(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
