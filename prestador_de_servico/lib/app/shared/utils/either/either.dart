class Either<L, R> {
  final L? left;
  final R? right;

  Either.left(this.left) : right = null;
  Either.right(this.right) : left = null;
}

// Unit é usado para representar um retorno vazio (void) de right em Either
class Unit {
  const Unit();
}
const unit = Unit();