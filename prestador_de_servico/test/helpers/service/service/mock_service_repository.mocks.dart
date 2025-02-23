// Mocks generated by Mockito 5.4.4 from annotations
// in prestador_de_servico/test/helpers/service/service/mock_service_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:prestador_de_servico/app/models/service/service.dart' as _i6;
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart'
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

/// A class which mocks [ServiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockServiceRepository extends _i1.Mock implements _i3.ServiceRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>> getAll() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getAll,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getAll,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>> getByServiceCategoryId(
          {required String? serviceCategoryId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getByServiceCategoryId,
          [],
          {#serviceCategoryId: serviceCategoryId},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getByServiceCategoryId,
            [],
            {#serviceCategoryId: serviceCategoryId},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getByServiceCategoryId,
            [],
            {#serviceCategoryId: serviceCategoryId},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Service>> getById(
          {required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getById,
          [],
          {#id: id},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Service>>.value(
            _FakeEither_0<_i5.Failure, _i6.Service>(
          this,
          Invocation.method(
            #getById,
            [],
            {#id: id},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Service>>.value(
                _FakeEither_0<_i5.Failure, _i6.Service>(
          this,
          Invocation.method(
            #getById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Service>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>> getNameContained(
          {required String? name}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getNameContained,
          [],
          {#name: name},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getNameContained,
            [],
            {#name: name},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getNameContained,
            [],
            {#name: name},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>> getUnsync(
          {required DateTime? dateLastSync}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUnsync,
          [],
          {#dateLastSync: dateLastSync},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getUnsync,
            [],
            {#dateLastSync: dateLastSync},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Service>>(
          this,
          Invocation.method(
            #getUnsync,
            [],
            {#dateLastSync: dateLastSync},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Service>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> insert(
          {required _i6.Service? service}) =>
      (super.noSuchMethod(
        Invocation.method(
          #insert,
          [],
          {#service: service},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #insert,
            [],
            {#service: service},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, String>>.value(
                _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #insert,
            [],
            {#service: service},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> update(
          {required _i6.Service? service}) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [],
          {#service: service},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #update,
            [],
            {#service: service},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #update,
            [],
            {#service: service},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> deleteById(
          {required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteById,
          [],
          {#id: id},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteById,
            [],
            {#id: id},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> deleteByCategoryId(
          String? serviceCategoryId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteByCategoryId,
          [serviceCategoryId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteByCategoryId,
            [serviceCategoryId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteByCategoryId,
            [serviceCategoryId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> existsById({required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #existsById,
          [],
          {#id: id},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #existsById,
            [],
            {#id: id},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #existsById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);
}
