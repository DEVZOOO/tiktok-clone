/// 유저 프로필
class UserProfileModel {
  /// unique PK
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.hasAvatar,
  });

  /// constructor : 빈 유저 모델
  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        birthday = "",
        hasAvatar = false;

  /// constructor : from json to Model
  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        birthday = json["birthday"],
        hasAvatar = json["hasAvatar"];

  // convert json
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "birthday": birthday,
      "hasAvatar": hasAvatar,
    };
  }

  /// 현재 객체에 새로운 값 덮어쓰기
  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    bool? hasAvatar,
  }) =>
      UserProfileModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        link: link ?? this.link,
        birthday: birthday ?? this.birthday,
        hasAvatar: hasAvatar ?? this.hasAvatar,
      );
}
