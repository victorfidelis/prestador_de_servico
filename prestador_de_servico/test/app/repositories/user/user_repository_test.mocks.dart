// Mocks generated by Mockito 5.4.4 from annotations
// in prestador_de_servico/test/app/repositories/user/user_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:prestador_de_servico/app/models/user/user.dart' as _i4;
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart'
    as _i2;

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

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i2.UserRepository {
  @override
  _i3.Future<String?> add({required _i4.User? user}) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
          {#user: user},
        ),
        returnValue: _i3.Future<String?>.value(),
        returnValueForMissingStub: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<_i4.User?> getById({required String? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getById,
          [],
          {#id: id},
        ),
        returnValue: _i3.Future<_i4.User?>.value(),
        returnValueForMissingStub: _i3.Future<_i4.User?>.value(),
      ) as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> getByEmail({required String? email}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getByEmail,
          [],
          {#email: email},
        ),
        returnValue: _i3.Future<_i4.User?>.value(),
        returnValueForMissingStub: _i3.Future<_i4.User?>.value(),
      ) as _i3.Future<_i4.User?>);

  @override
  _i3.Future<bool> deleteById({required String? id}) => (super.noSuchMethod(
        Invocation.method(
          #deleteById,
          [],
          {#id: id},
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> update({required _i4.User? user}) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [],
          {#user: user},
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
