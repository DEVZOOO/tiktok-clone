/// 채팅방 정보
class ChatRoomModel {
  final String id;
  final String personA;
  final String personB;
  final String personAname;
  final String personBname;
  final int createdAt;

  ChatRoomModel({
    required this.id,
    required this.personA,
    required this.personB,
    required this.personAname,
    required this.personBname,
    required this.createdAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json, String chatId)
      : id = chatId,
        personA = json['personA'],
        personB = json['personB'],
        personAname = json['personAname'],
        personBname = json['personBname'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "personA": personA,
      "personB": personB,
      "personAname": personAname,
      "personBname": personBname,
      "createdAt": createdAt,
    };
  }
}
