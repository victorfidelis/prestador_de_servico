// Mocks generated by Mockito 5.4.4 from annotations
// in prestador_de_servico/test/helpers/sync/mock_sync_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:prestador_de_servico/app/models/sync/sync.dart' as _i6;
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart'
    as _i3;
import 'package:prestador_de_servico/app/shared/utils/either/either.dart' as _i2;
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SyncRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSyncRepository extends _i1.Mock implements _i3.SyncRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Sync>> get() => (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Sync>>.value(
            _FakeEither_0<_i5.Failure, _i6.Sync>(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Sync>>.value(
                _FakeEither_0<_i5.Failure, _i6.Sync>(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Sync>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> exists() => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #exists,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #exists,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> insert(
          {required _i6.Sync? sync}) =>
      (super.noSuchMethod(
        Invocation.method(
          #insert,
          [],
          {#sync: sync},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #insert,
            [],
            {#sync: sync},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #insert,
            [],
            {#sync: sync},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updateServiceCategory(
          {required DateTime? syncDate}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateServiceCategory,
          [],
          {#syncDate: syncDate},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateServiceCategory,
            [],
            {#syncDate: syncDate},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateServiceCategory,
            [],
            {#syncDate: syncDate},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updateService(
          {required DateTime? syncDate}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateService,
          [],
          {#syncDate: syncDate},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateService,
            [],
            {#syncDate: syncDate},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateService,
            [],
            {#syncDate: syncDate},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updatePayment(
          {required DateTime? syncDate}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePayment,
          [],
          {#syncDate: syncDate},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updatePayment,
            [],
            {#syncDate: syncDate},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updatePayment,
            [],
            {#syncDate: syncDate},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updateServiceDay(
          {required DateTime? syncDate}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateServiceDay,
          [],
          {#syncDate: syncDate},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateServiceDay,
            [],
            {#syncDate: syncDate},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateServiceDay,
            [],
            {#syncDate: syncDate},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);
}
