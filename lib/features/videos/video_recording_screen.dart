import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_icon.dart';

/// 동영상 녹화 화면
class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _deniedPermission = false;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;
  late CameraController _cameraController; // 모드 변경시 덮어써지므로 final 삭제

  // 버튼애니메이션
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 200,
    ),
  );
  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  /// 녹화 진행상황 애니메이션
  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.1,
  );

  /// 권한 요청
  Future<void> initPermission() async {
    final cameraPermission = await Permission.camera.request(); // 카메라 권한 요청
    final micPermission = await Permission.microphone.request(); // 마이크 권한 요청

    // 한번만 요청하지 마라 / 다시는 요청하지 마라
    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    // 권한 모두 허용
    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
    } else {
      _deniedPermission = true; // challenge
    }
    setState(() {});
  }

  /// 카메라 초기화
  Future<void> initCamera() async {
    final cameras = await availableCameras(); // [0] : 후면카메라, [1] : 전면카메라

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode; // 카메라가 가진 값으로 초기화함
  }

  @override
  void initState() {
    super.initState();

    initPermission();
    // 녹화 circular
    _progressAnimationController.addListener(() {
      // 애니메이션 value 변경될 때마다 알려줌
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      // 애니메이션 끝났는지 알려줌
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  /// 카메라 모드 변경
  Future<void> toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera(); // 모드 바뀌면 카메라 설정 바꿔야하므로
    setState(() {});
  }

  /// 플래시모드 변경
  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  void _startRecording(TapDownDetails details) {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _deniedPermission
                        ? 'Allow Permission!'
                        : 'Request Permission......',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  const CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),

                  // 버튼영역
                  Positioned(
                    top: Sizes.size20,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        // 카메라 모드 전환
                        IconButton(
                          color: Colors.white,
                          onPressed: toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                          ),
                        ),

                        // challenge 1 - flash button widget처리
                        Gaps.v10,
                        // 플래시 off
                        FlashIcon(
                          isActive: _flashMode == FlashMode.off,
                          onPressed: () => _setFlashMode(FlashMode.off),
                          icon: Icons.flash_off_rounded,
                        ),

                        Gaps.v10,
                        // 플래시 on
                        FlashIcon(
                          isActive: _flashMode == FlashMode.always,
                          onPressed: () => _setFlashMode(FlashMode.always),
                          icon: Icons.flash_on_rounded,
                        ),

                        Gaps.v10,
                        // 플래시 자동
                        FlashIcon(
                          isActive: _flashMode == FlashMode.auto,
                          onPressed: () => _setFlashMode(FlashMode.auto),
                          icon: Icons.flash_auto_rounded,
                        ),

                        Gaps.v10,
                        // 손전등
                        FlashIcon(
                          isActive: _flashMode == FlashMode.torch,
                          onPressed: () => _setFlashMode(FlashMode.torch),
                          icon: Icons.flashlight_on_rounded,
                        ),
                      ],
                    ),
                  ),

                  // 녹화버튼
                  Positioned(
                      bottom: Sizes.size40,
                      child: GestureDetector(
                        onTapDown: _startRecording,
                        onTapUp: (details) => _stopRecording(),
                        child: ScaleTransition(
                          scale: _buttonAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: Sizes.size80 + Sizes.size14,
                                height: Sizes.size80 + Sizes.size14,
                                child: CircularProgressIndicator(
                                  color: Colors.red.shade400,
                                  strokeWidth: Sizes.size6,
                                  value: _progressAnimationController.value,
                                ),
                              ),
                              Container(
                                width: Sizes.size80,
                                height: Sizes.size80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
