import 'package:clean_todo_tdd/erros/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCaseWithParam<Type, Params> {
  const UseCaseWithParam();

  Either<Failure, Type> call(Params params);
}

abstract class UseCaseWithoutParam<Type> {
  const UseCaseWithoutParam();

  Future<Either<Failure, Type>> call();
}
