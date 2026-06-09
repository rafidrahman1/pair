import 'package:equatable/equatable.dart';

class PairEntity extends Equatable {
  const PairEntity({
    required this.id,
    required this.memberIds,
    required this.createdAt,
  });

  final String id;
  final List<String> memberIds;
  final DateTime createdAt;

  String spouseId(String currentUserId) {
    return memberIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  @override
  List<Object?> get props => [id, memberIds, createdAt];
}
