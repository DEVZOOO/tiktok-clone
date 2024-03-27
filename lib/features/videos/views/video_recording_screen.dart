import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/views/widgets/flash_icon.dart';

/// 동영상 녹화 화면
class VideoRecordingScreen extends StatefulWidget {
  static const String routeUrl = "/upload";
  static const String routeName = "postVideo";

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _deniedPermission = false;

  final bool _noCamera = kDebugMode && Platform.isIOS;

  bool _isSelfieMode = false;

  late FlashMode _flashMode;
  late CameraController _cameraController; // 모드 변경시 덮어써지므로 final 삭제

  late double _maxZoomLevel; // 카메라 줌 가능한 맥시멈 레벨
  late double _minZoomLevel; // 카메라 줌 가능한 미니멈 레벨
  double _zoomLevel = 1;

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
      // enableAudio: false, // 애뮬레이터 에러로 소리없이 녹화
    );

    await _cameraController.initialize();

    // await _cameraController.prepareForVideoRecording(); // iOS : 녹화 준비

    // ## Challenge
    _maxZoomLevel = await _cameraController.getMaxZoomLevel();
    _minZoomLevel = await _cameraController.getMinZoomLevel();

    _flashMode = _cameraController.value.flashMode; // 카메라가 가진 값으로 초기화함

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (!_noCamera) {
      initPermission();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }

    // 유저가 app에서 벗어나면 알려줌
    WidgetsBinding.instance.addObserver(this);

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

  /// 녹화 시작
  Future<void> _startRecording(TapDownDetails details) async {
    // 이미 녹화중이라면 리턴
    if (_cameraController.value.isRecordingVideo) {
      return;
    }

    // 녹화
    await _cameraController.startVideoRecording();

    // 애니메이션
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  /// 녹화 중지
  Future<void> _stopRecording() async {
    // 녹화상태 아니면 리턴
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    // 녹화 중지
    final video = await _cameraController.stopVideoRecording();

    // 사진
    // final picture = _cameraController.takePicture();

    // print(video.name);
    // print(video.path);

    // preview 이동
    if (!mounted) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  /// 갤러리에 접근해서 비디오 가져오기
  Future<void> _onPickVideoPressed() async {
    // 접근 요청
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery, // 앨범에서 가져오기
      // source: ImageSource.camera, // 기기 카메라 사용 가능!
    );

    // 아무것도 선택하지 않았다면
    if (video == null) {
      return;
    }

    // print(video);

    // preview 이동
    if (!mounted) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  /// 앱 상태 변경 알림
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print(state);

    if (_noCamera) {
      return;
    }

    // 권한이 없어서 inactive라면 return
    if (!_hasPermission || _deniedPermission) {
      // !_cameraController.value.isInitialzed
      return;
    }

    // 앱 꺼지면 dispose
    if (state == AppLifecycleState.inactive) {
      // 초기화 안하면 진행안함
      if (!_cameraController.value.isInitialized) {
        return;
      }
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // 다시 앱 켜지면 init
      initCamera();
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();

    // 카메라 없거나 권한 거부했으면 dispose 제외
    if (!_noCamera && !_deniedPermission) {
      _cameraController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
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
                  // 카메라 있고 controller 초기화됬으면
                  if (!_noCamera && _cameraController.value.isInitialized)
                    CameraPreview(_cameraController),

                  // 닫기
                  const Positioned(
                    top: Sizes.size40,
                    left: Sizes.size20,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),

                  if (!_noCamera)
                    // 플래시 버튼영역
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

                          // ## Challenge 1 - flash button widget처리
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

                  // 하단 버튼영역(녹화,갤러리)
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: Sizes.size40,
                    child: Row(
                      children: [
                        // 빈 공간처럼, 요소
                        const Spacer(),
                        // 녹화버튼
                        GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          // ## Challenge
                          onVerticalDragUpdate: (details) {
                            // 수직 위아래 드래그 변경 감지
                            // print(details);
                            final dy = details.delta.dy;
                            final dyAbs = dy.abs();
                            final isZoomIn = dy < 0; // dy가 마이너스면 줌인, 플러스면 줌아웃

                            if (isZoomIn) {
                              var level = _zoomLevel + dyAbs;
                              // 현재 레벨이 최대레벨보다 크면 안함
                              if (level < _maxZoomLevel) {
                                _zoomLevel = level;
                              }
                            } else {
                              var level = _zoomLevel - dyAbs;
                              if (level > _minZoomLevel) {
                                _zoomLevel = level;
                              }
                            }

                            _cameraController.setZoomLevel(_zoomLevel);
                            setState(() {});
                          },
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
                        ),

                        // 갤러리버튼
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
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
    );
  }
}
