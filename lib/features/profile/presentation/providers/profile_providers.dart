import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';

final spouseUserProvider = FutureProvider<UserEntity?>((ref) async {
  final user = ref.watch(currentUserStreamProvider).valueOrNull;
  final pair = ref.watch(currentPairProvider).valueOrNull;

  if (user == null || pair == null) return null;

  final spouseId = pair.spouseId(user.uid);
  if (spouseId.isEmpty) return null;

  final spouseDoc = await ref
      .read(authRemoteDataSourceProvider)
      .getUserDocument(spouseId);

  return spouseDoc?.toEntity();
});
