import 'package:fpdart/fpdart.dart';
import 'package:pair/core/errors/failure.dart';

typedef Result<T> = Either<Failure, T>;

extension ResultX<T> on Result<T> {
  bool get isSuccess => isRight();

  T? get valueOrNull => fold((_) => null, (value) => value);

  Failure? get failureOrNull => fold((failure) => failure, (_) => null);
}

Result<T> success<T>(T value) => Right(value);

Result<T> failure<T>(Failure failure) => Left(failure);
