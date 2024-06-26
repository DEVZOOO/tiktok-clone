import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

/// ViewModel
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  /// 데이터 조회하는 repository와 데이터 객체 model을 가지고 있어야 함
// class PlaybackConfigViewModel extends ChangeNotifier {

  /// repository
  final VideoPlaybackConfigRepository _repository;

  /// model
  // late final PlaybackConfigModel _model;

  PlaybackConfigViewModel(this._repository);

  // ============================================================

  // getter - model에 직접 접근 불가
  /*
  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;
  */

  // 데이터 수정하는 메소드 외부(view) 공개

  /// 음소거 여부 업데이트
  void setMuted(bool val) {
    // 1. 로컬저장소에 저장
    _repository.setMuted(val);
    // 2. model 수정
    // _model.muted = val;
    state = PlaybackConfigModel(
      muted: val, // 새로운 값
      autoplay: state.autoplay, // 기존값
    );
    // 3. listener에게 변경 알림
    // notifyListeners();
  }

  /// 자동재생 여부 업데이트
  void setAutoplay(bool val) {
    _repository.setAutoplay(val);

    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: val, // 새로운 값
    );
    // _model.autoplay = val;

    // notifyListeners();
  }

  @override
  PlaybackConfigModel build() {
    // 초기화데이터
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  // () => PlaybackConfigViewModel(),
  () =>
      throw UnimplementedError(), // shared_preferences await 해야하므로 에러처리하고 실제 에러발생(객체생성) 전에 main에서 override해줌
);
