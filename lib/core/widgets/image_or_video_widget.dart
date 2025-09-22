import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../theming/colors.dart';

class ImageOrVideoWidget extends StatefulWidget {
  final Function(File? image, File? video) onMediaSelected;
  final String? initialImagePath;
  final String? initialVideoPath;

  const ImageOrVideoWidget({
    super.key,
    required this.onMediaSelected,
    this.initialImagePath,
    this.initialVideoPath,
  });

  @override
  State<ImageOrVideoWidget> createState() => _ImageOrVideoWidgetState();
}

class _ImageOrVideoWidgetState extends State<ImageOrVideoWidget> {
  File? _selectedImage;
  File? _selectedVideo;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
    if (widget.initialVideoPath != null) {
      _selectedVideo = File(widget.initialVideoPath!);
      _initializeVideoPlayer();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    if (_selectedVideo != null) {
      _videoController = VideoPlayerController.file(_selectedVideo!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        // Clear any existing video when selecting an image
        if (_selectedVideo != null) {
          _videoController?.dispose();
          _videoController = null;
          _selectedVideo = null;
        }

        setState(() {
          _selectedImage = File(image.path);
        });
        widget.onMediaSelected(_selectedImage, null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_picking_image'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 10), // 10 seconds limit
        preferredCameraDevice: CameraDevice.rear,
      );

      if (video != null && mounted) {
        final file = File(video.path);

        // 🔹 Compress the video
        final info = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality
              .MediumQuality, // LowQuality, MediumQuality, HighQuality
          deleteOrigin: false, // keep original file
        );

        if (info == null || info.file == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('video_compression_failed'.tr()),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final compressedFile = info.file!;
        final fileSizeInBytes = await compressedFile.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        print('Compressed video size: ${fileSizeInMB.toStringAsFixed(2)} MB');

        if (fileSizeInMB > 10) {
          // 10MB limit
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${"video_is_too_large_even_after_compression".tr()} (${fileSizeInMB.toStringAsFixed(1)}MB).',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        // Clear any existing image when selecting a video
        if (_selectedImage != null) {
          _selectedImage = null;
        }

        _videoController?.dispose();

        setState(() {
          _selectedVideo = compressedFile;
        });

        _initializeVideoPlayer();
        widget.onMediaSelected(null, _selectedVideo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_recording_video'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // Future<void> _recordVideo() async {
  //   try {
  //     final XFile? video = await _picker.pickVideo(
  //       source: ImageSource.camera,
  //       maxDuration: const Duration(seconds: 30), // 30 seconds limit
  //       preferredCameraDevice: CameraDevice.rear,
  //     );

  //     if (video != null && mounted) {
  //       // Check file size before processing
  //       final file = File(video.path);
  //       final fileSizeInBytes = await file.length();
  //       final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

  //       print('Video file size: ${fileSizeInMB.toStringAsFixed(2)} MB');

  //       // If file is too large, show warning
  //       if (fileSizeInMB > 10) {
  //         // 10MB limit
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                   'Video file is too large (${fileSizeInMB.toStringAsFixed(1)}MB). Please try a shorter video.'),
  //               backgroundColor: Colors.orange,
  //             ),
  //           );
  //           return;
  //         }
  //       }

  //       // Clear any existing image when selecting a video
  //       if (_selectedImage != null) {
  //         _selectedImage = null;
  //       }

  //       _videoController?.dispose();

  //       setState(() {
  //         _selectedVideo = file;
  //       });

  //       _initializeVideoPlayer();
  //       widget.onMediaSelected(null, _selectedVideo);
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('${'error_recording_video'.tr()}: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'select_image_source'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: ColorsManager.mistWhite,
                      ),
                      label: Text('camera'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.coralBlaze,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text('gallery'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.coralBlaze,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _removeMedia() {
    _videoController?.dispose();
    _videoController = null;

    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
    });
    widget.onMediaSelected(null, null);
  }

  Widget _buildVideoPlayer() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _removeMedia,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'video'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ticket_media'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorsManager.slateGray,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: ColorsManager.paleLavenderBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorsManager.slateGray.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: _selectedVideo != null
              ? _buildVideoPlayer()
              : _selectedImage != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _removeMedia,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: ColorsManager.slateGray.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'add_media'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                ColorsManager.slateGray.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showImageSourceDialog,
                              icon: const Icon(Icons.photo_camera, size: 18),
                              label: Text('select_image'.tr()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.coralBlaze,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _recordVideo,
                              icon: const Icon(Icons.videocam, size: 18),
                              label: Text('record_video'.tr()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorsManager.royalIndigo.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'video_limit_10s'.tr(),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                ColorsManager.slateGray.withValues(alpha: 0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:video_player/video_player.dart';

// import '../theming/colors.dart';

// class ImageOrVideoWidget extends StatefulWidget {
//   final Function(File? image, File? video) onMediaSelected;
//   final String? initialImagePath;
//   final String? initialVideoPath;

//   const ImageOrVideoWidget({
//     super.key,
//     required this.onMediaSelected,
//     this.initialImagePath,
//     this.initialVideoPath,
//   });

//   @override
//   State<ImageOrVideoWidget> createState() => _ImageOrVideoWidgetState();
// }

// class _ImageOrVideoWidgetState extends State<ImageOrVideoWidget> {
//   File? _selectedImage;
//   File? _selectedVideo;
//   VideoPlayerController? _videoController;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialImagePath != null) {
//       _selectedImage = File(widget.initialImagePath!);
//     }
//     if (widget.initialVideoPath != null) {
//       _selectedVideo = File(widget.initialVideoPath!);
//       _initializeVideoPlayer();
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   void _initializeVideoPlayer() {
//     if (_selectedVideo != null) {
//       _videoController = VideoPlayerController.file(_selectedVideo!)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (image != null && mounted) {
//         // Clear any existing video when selecting an image
//         if (_selectedVideo != null) {
//           _videoController?.dispose();
//           _videoController = null;
//           _selectedVideo = null;
//         }

//         setState(() {
//           _selectedImage = File(image.path);
//         });
//         widget.onMediaSelected(_selectedImage, null);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${'error_picking_image'.tr()}: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _recordVideo() async {
//     try {
//       final XFile? video = await _picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(seconds: 15), // 15 seconds limit
//         preferredCameraDevice: CameraDevice.rear,
//       );

//       if (video != null && mounted) {
//         // Clear any existing image when selecting a video
//         if (_selectedImage != null) {
//           _selectedImage = null;
//         }

//         _videoController?.dispose();

//         setState(() {
//           _selectedVideo = File(video.path);
//         });

//         _initializeVideoPlayer();
//         widget.onMediaSelected(null, _selectedVideo);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${'error_recording_video'.tr()}: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'select_image_source'.tr(),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.camera);
//                       },
//                       icon: const Icon(Icons.camera_alt),
//                       label: Text('camera'.tr()),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorsManager.coralBlaze,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _pickImage(ImageSource.gallery);
//                       },
//                       icon: const Icon(Icons.photo_library),
//                       label: Text('gallery'.tr()),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorsManager.coralBlaze,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _removeMedia() {
//     _videoController?.dispose();
//     _videoController = null;

//     setState(() {
//       _selectedImage = null;
//       _selectedVideo = null;
//     });
//     widget.onMediaSelected(null, null);
//   }

//   Widget _buildVideoPlayer() {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       return Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: SizedBox(
//               width: double.infinity,
//               height: 200,
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: _videoController!.value.size.width,
//                   height: _videoController!.value.size.height,
//                   child: VideoPlayer(_videoController!),
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Center(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (_videoController!.value.isPlaying) {
//                       _videoController!.pause();
//                     } else {
//                       _videoController!.play();
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _videoController!.value.isPlaying
//                         ? Icons.pause
//                         : Icons.play_arrow,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 8,
//             right: 8,
//             child: GestureDetector(
//               onTap: _removeMedia,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 8,
//             left: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.videocam,
//                     color: Colors.white,
//                     size: 12,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'video'.tr(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'ticket_media'.tr(),
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: ColorsManager.slateGray,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           height: 200,
//           decoration: BoxDecoration(
//             color: ColorsManager.paleLavenderBlue,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: ColorsManager.slateGray.withValues(alpha: 0.3),
//               width: 1,
//             ),
//           ),
//           child: _selectedVideo != null
//               ? _buildVideoPlayer()
//               : _selectedImage != null
//                   ? Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.file(
//                             _selectedImage!,
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: _removeMedia,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.add_a_photo,
//                           size: 48,
//                           color: ColorsManager.slateGray.withValues(alpha: 0.6),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'add_media'.tr(),
//                           style: TextStyle(
//                             fontSize: 16,
//                             color:
//                                 ColorsManager.slateGray.withValues(alpha: 0.6),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: _showImageSourceDialog,
//                               icon: const Icon(Icons.photo_camera, size: 18),
//                               label: Text('select_image'.tr()),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: ColorsManager.coralBlaze,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 textStyle: const TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             ElevatedButton.icon(
//                               onPressed: _recordVideo,
//                               icon: const Icon(Icons.videocam, size: 18),
//                               label: Text('record_video'.tr()),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     ColorsManager.royalIndigo.withOpacity(0.8),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 8,
//                                 ),
//                                 textStyle: const TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'video_limit_15s'.tr(),
//                           style: TextStyle(
//                             fontSize: 10,
//                             color:
//                                 ColorsManager.slateGray.withValues(alpha: 0.5),
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ],
//                     ),
//         ),
//       ],
//     );
//   }
// }
