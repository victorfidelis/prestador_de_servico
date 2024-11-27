import 'package:prestador_de_servico/app/shared/either/either.dart';

extension EitherExtensions<L, R> on Either<L, R> {
  bool get isLeft => left != null;
  bool get isRight => right != null;

  T fold<T>(T Function(L) onLeft, T Function(R) onRigth) {
    if (isLeft) {
      return onLeft(left as L);
    } else {
      return onRigth(right as R);
    }
  }
}
