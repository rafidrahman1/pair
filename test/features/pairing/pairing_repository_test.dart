import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pair/features/pairing/data/datasources/pairing_remote_datasource.dart';
import 'package:pair/features/pairing/data/repositories/pairing_repository_impl.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late PairingRepositoryImpl repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = PairingRepositoryImpl(
      PairingRemoteDataSource(firestore),
    );
  });

  group('PairingRepository', () {
    test('generatePairCode creates a valid code for unpaired user', () async {
      await firestore.collection('users').doc('user1').set({
        'uid': 'user1',
        'displayName': 'Alice',
        'email': 'alice@test.com',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      final result = await repository.generatePairCode('user1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (code) {
          expect(code.code, matches(RegExp(r'^[A-Z]{4}-\d{4}$')));
          expect(code.used, false);
          expect(code.ownerId, 'user1');
        },
      );
    });

    test('joinWithCode fails for invalid code', () async {
      await firestore.collection('users').doc('user2').set({
        'uid': 'user2',
        'displayName': 'Bob',
        'email': 'bob@test.com',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      final result = await repository.joinWithCode(
        code: 'INVALID',
        joinerId: 'user2',
      );

      expect(result.isLeft(), true);
    });
  });
}
