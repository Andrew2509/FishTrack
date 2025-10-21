import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../providers/app_provider.dart';
import '../models/fish_detection.dart';
import '../constants/app_constants.dart';
import '../widgets/image_filter_widget.dart';
import '../widgets/detection_result_widget.dart';
import '../widgets/camera_preview_widget.dart';
import '../services/detection_service.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with TickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  final DetectionService _detectionService = DetectionService();

  late AnimationController _scanController;
  late AnimationController _resultController;
  late Animation<double> _scanAnimation;
  late Animation<double> _resultAnimation;

  File? _selectedImage;
  FishDetection? _detectionResult;
  bool _isProcessing = false;
  bool _isCameraMode = false;
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  String _selectedFilter = 'none';
  Map<String, dynamic> _filterSettings = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _resultController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Kualitas Ikan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _toggleCameraMode,
            icon: Icon(_isCameraMode ? Icons.photo_library : Icons.camera_alt),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isCameraMode && _cameraController != null) {
      return _buildCameraView();
    } else {
      return _buildImageSelectionView();
    }
  }

  Widget _buildImageSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 30),

          // Image Selection
          _buildImageSelection(),
          const SizedBox(height: 30),

          // Image Filters
          if (_selectedImage != null) _buildImageFilters(),

          // Detection Result
          if (_detectionResult != null) _buildDetectionResult(),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        CameraPreviewWidget(
          controller: _cameraController!,
          onImageCaptured: _onImageCaptured,
        ),
        _buildCameraOverlay(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deteksi Kualitas Ikan',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Ambil foto ikan atau pilih dari galeri untuk mendeteksi kualitasnya',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelection() {
    return Container(
      constraints: const BoxConstraints(minHeight: 250, maxHeight: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: _selectedImage != null
          ? _buildSelectedImage()
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildSelectedImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: _clearImage,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
        if (_isProcessing)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _selectImage,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Gambar Ikan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ketuk untuk memilih gambar dari galeri',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFilters() {
    return ImageFilterWidget(
      selectedFilter: _selectedFilter,
      filterSettings: _filterSettings,
      onFilterChanged: (filter, settings) {
        setState(() {
          _selectedFilter = filter;
          _filterSettings = settings;
        });
      },
      onApplyFilter: _applyFilter,
    );
  }

  Widget _buildDetectionResult() {
    return AnimatedBuilder(
      animation: _resultAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _resultAnimation.value,
          child: DetectionResultWidget(
            detection: _detectionResult!,
            onRetry: _retryDetection,
            onSave: _saveDetection,
          ),
        );
      },
    );
  }

  Widget _buildCameraOverlay() {
    return Stack(
      children: [
        // Scanning animation
        if (_isProcessing)
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: LinearProgressIndicator(
                  value: _scanAnimation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          ),

        // Camera controls
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _toggleCameraMode,
                icon: const Icon(Icons.photo_library, color: Colors.white),
              ),
              GestureDetector(
                onTap: _captureImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleCameraMode,
                icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: _isProcessing ? null : _processImage,
      icon: _isProcessing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.analytics),
      label: Text(_isProcessing ? 'Memproses...' : 'Deteksi Kualitas'),
    );
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: AppConstants.maxImageSize.toDouble(),
        maxHeight: AppConstants.maxImageSize.toDouble(),
        imageQuality: (AppConstants.imageQuality * 100).round(),
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectionResult = null;
        });
      }
    } catch (e) {
      _showError('Gagal memilih gambar: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() {
        _selectedImage = File(image.path);
        _detectionResult = null;
        _isCameraMode = false;
      });
    } catch (e) {
      _showError('Gagal mengambil foto: $e');
    }
  }

  void _onImageCaptured(File image) {
    setState(() {
      _selectedImage = image;
      _detectionResult = null;
      _isCameraMode = false;
    });
  }

  void _toggleCameraMode() {
    setState(() {
      _isCameraMode = !_isCameraMode;
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _detectionResult = null;
      _selectedFilter = 'none';
      _filterSettings = {};
    });
  }

  Future<void> _applyFilter() async {
    if (_selectedImage == null) return;

    // Apply image filter based on selected filter and settings
    // This would integrate with image processing library
    setState(() {
      // Update image with applied filter
    });
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      _scanController.forward();

      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 2));

      final result = await _detectionService.detectFishQuality(_selectedImage!);

      setState(() {
        _detectionResult = result;
        _isProcessing = false;
      });

      _resultController.forward();

      // Add points to user
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      await appProvider.addPoints(AppConstants.pointsPerDetection);

      // Check for badges
      await _checkForBadges(appProvider);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showError('Gagal memproses gambar: $e');
    }
  }

  Future<void> _checkForBadges(AppProvider appProvider) async {
    final profile = appProvider.userProfile;
    if (profile == null) return;

    // First detection badge
    if (profile.totalDetections == 1) {
      await appProvider.addBadge('first_detection');
    }

    // Detection master badge
    if (profile.totalDetections >= 10) {
      await appProvider.addBadge('detection_master');
    }

    // Quality expert badge
    if (profile.averageScore >= 0.8) {
      await appProvider.addBadge('quality_expert');
    }
  }

  void _retryDetection() {
    setState(() {
      _detectionResult = null;
    });
    _processImage();
  }

  Future<void> _saveDetection() async {
    if (_detectionResult == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.addDetection(_detectionResult!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil deteksi berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
