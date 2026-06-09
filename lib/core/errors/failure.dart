import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message);
}

final class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class PairingFailure extends Failure {
  const PairingFailure(super.message);
}

final class NotificationFailure extends Failure {
  const NotificationFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
