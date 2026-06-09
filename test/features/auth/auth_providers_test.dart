import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/result/result.dart';
import 'package:pair/features/auth/domain/entities/user_entity.dart';
import 'package:pair/features/auth/domain/repositories/auth_repository.dart';
import 'package:pair/features/auth/presentation/providers/auth_providers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  final testUser = UserEntity(
    uid: 'test-uid',
    displayName: 'Test User',
    email: 'test@example.com',
    photoUrl: '',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  test('AuthController signInWithGoogle updates state on success', () async {
    when(() => mockRepository.signInWithGoogle())
        .thenAnswer((_) async => success(testUser));
    when(() => mockRepository.getCurrentUser())
        .thenAnswer((_) async => success(testUser));
    when(() => mockRepository.watchAuthState())
        .thenAnswer((_) => Stream.value(testUser));

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(authControllerProvider.notifier);
    await controller.signInWithGoogle();

    final state = container.read(authControllerProvider);
    expect(state.hasValue, true);
    expect(state.value?.uid, 'test-uid');
  });

  test('AuthController signInWithGoogle sets error on failure', () async {
    when(() => mockRepository.signInWithGoogle()).thenAnswer(
      (_) async => failure(const AuthFailure('Sign in failed')),
    );
    when(() => mockRepository.getCurrentUser())
        .thenAnswer((_) async => failure(const AuthFailure('Not authenticated')));
    when(() => mockRepository.watchAuthState())
        .thenAnswer((_) => Stream.value(null));

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(authControllerProvider.notifier);
    await controller.signInWithGoogle();

    final state = container.read(authControllerProvider);
    expect(state.hasError, true);
  });
}
