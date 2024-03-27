import 'package:shared_preferences/shared_preferences.dart';

/// 데이터 유지(persist, 프로그램보다 오래 살림), 데이터 조회(읽기)
/// 단순히 읽고 저장하는 것만 함
class VideoPlaybackConfigRepository {
  static const String _muted = "muted";
  static const String _autoplay = "autoplay";

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  /// mute 여부 로컬저장소에 저장
  Future<void> setMuted(bool val) async {
    _preferences.setBool(_muted, val);
  }

  /// autoplay 여부 저장
  Future<void> setAutoplay(bool val) async {
    _preferences.setBool(_autoplay, val);
  }

  /// mute 여부 읽기
  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  /// autoplay 여부 읽기
  bool isAutoplay() => _preferences.getBool(_autoplay) ?? false;
}
