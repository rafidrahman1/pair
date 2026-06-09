import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pair/features/auth/data/models/user_model.dart';
import 'package:pair/features/chat/domain/entities/message_entity.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    required String senderId,
    required String text,
    @TimestampConverter() required DateTime createdAt,
    @ReadByConverter() @Default({}) Map<String, DateTime> readBy,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  factory MessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MessageModel.fromJson({...data, 'id': doc.id});
  }

  MessageEntity toEntity() => MessageEntity(
        id: id,
        senderId: senderId,
        text: text,
        createdAt: createdAt,
        readBy: readBy,
      );

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

class ReadByConverter
    implements JsonConverter<Map<String, DateTime>, Map<String, dynamic>?> {
  const ReadByConverter();

  @override
  Map<String, DateTime> fromJson(Map<String, dynamic>? json) {
    if (json == null) return {};
    return json.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate());
      }
      if (value is String) {
        return MapEntry(key, DateTime.parse(value));
      }
      return MapEntry(key, DateTime.now());
    });
  }

  @override
  Map<String, dynamic> toJson(Map<String, DateTime> object) {
    return object.map(
      (key, value) => MapEntry(key, Timestamp.fromDate(value)),
    );
  }
}
