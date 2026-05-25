import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'AI_camera_result.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isAnalyzing = false;
  String _liveLabel = '카메라를 물체에 가져다 대세요';

  // MLKit 라벨러 초기화
  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.6),
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        setState(() => _liveLabel = '카메라 권한이 필요합니다');
      }
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {});
    _controller!.startImageStream(_processFrame);
  }

  // 실시간 프레임 분석 (카메라 화면에 라벨 표시용)
  bool _isProcessing = false;
  Future<void> _processFrame(CameraImage image) async {
    if (_isProcessing || _isAnalyzing) return;
    _isProcessing = true;

    try {
      final inputImage = _convertToInputImage(image);
      if (inputImage == null) return;

      final labels = await _labeler.processImage(inputImage);
      if (labels.isNotEmpty && mounted) {
        setState(() {
          _liveLabel = labels.first.label;
        });
      }
    } catch (_) {
      // 에뮬레이터 등 호환되지 않는 카메라 포맷 무시
    } finally {
      _isProcessing = false;
    }
  }

  // CameraImage → InputImage 변환
  InputImage? _convertToInputImage(CameraImage image) {
    final camera = _controller!.description;
    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  // 갤러리에서 이미지 선택 후 분석 (에뮬레이터 테스트용)
  Future<void> _pickFromGallery() async {
    if (_isAnalyzing) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isAnalyzing = true);

    try {
      await _controller?.stopImageStream();

      final inputImage = InputImage.fromFilePath(picked.path);
      final labels = await _labeler.processImage(inputImage);

      if (!mounted) return;

      if (labels.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('물체를 인식하지 못했어요. 다른 사진으로 시도해주세요')),
        );
        await _controller?.startImageStream(_processFrame);
        setState(() => _isAnalyzing = false);
        return;
      }

      final bestLabel = labels.first.label;
      final confidence = labels.first.confidence;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AICameraResultScreen(
            detectedLabel: bestLabel,
            confidence: confidence,
            imagePath: picked.path,
          ),
        ),
      ).then((_) {
        if (mounted) {
          _controller?.startImageStream(_processFrame);
          setState(() => _isAnalyzing = false);
        }
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  // 촬영 버튼 누를 때 — 사진 찍고 최종 분석
  Future<void> _capture() async {
    if (_controller == null || _isAnalyzing) return;

    setState(() => _isAnalyzing = true);

    try {
      // 스트림 잠깐 멈추고 사진 찍기
      await _controller!.stopImageStream();
      final photo = await _controller!.takePicture();

      // 찍은 사진으로 최종 MLKit 분석
      final inputImage = InputImage.fromFilePath(photo.path);
      final labels = await _labeler.processImage(inputImage);

      if (!mounted) return;

      if (labels.isEmpty) {
        // 인식 실패 시 다시 스트림 시작
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('물체를 인식하지 못했어요. 다시 시도해주세요')),
        );
        await _controller!.startImageStream(_processFrame);
        setState(() => _isAnalyzing = false);
        return;
      }

      // 가장 신뢰도 높은 라벨 선택
      final bestLabel = labels.first.label;
      final confidence = labels.first.confidence;

      // 결과 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AICameraResultScreen(
            detectedLabel: bestLabel,
            confidence: confidence,
            imagePath: photo.path,
          ),

        ),
      ).then((_) {
        // 결과 화면에서 돌아오면 스트림 재시작
        if (mounted) {
          _controller!.startImageStream(_processFrame);
          setState(() => _isAnalyzing = false);
        }
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFFD9EACD),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF87A676))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 카메라 미리보기
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),

            // 상단 뒤로가기
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
              ),
            ),

            // 실시간 인식 라벨
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isAnalyzing ? '분석 중...' : _liveLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'RebornFont',
                    ),
                  ),
                ),
              ),
            ),

            // 하단 버튼 영역 (갤러리 + 촬영)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 갤러리 버튼
                  GestureDetector(
                    onTap: _isAnalyzing ? null : _pickFromGallery,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.photo_library,
                          color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // 촬영 버튼
                  GestureDetector(
                    onTap: _isAnalyzing ? null : _capture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: _isAnalyzing
                            ? Colors.grey
                            : const Color(0xFF87A676),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: _isAnalyzing
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.recycling,
                              color: Colors.white, size: 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}