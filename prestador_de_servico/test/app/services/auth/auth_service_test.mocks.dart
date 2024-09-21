// Mocks generated by Mockito 5.4.4 from annotations
// in prestador_de_servico/test/app/services/auth/auth_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:prestador_de_servico/app/services/auth/auth_service.dart'
    as _i3;
import 'package:prestador_de_servico/app/states/login/login_state.dart' as _i2;

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

class _FakeLoginState_0 extends _i1.SmartFake implements _i2.LoginState {
  _FakeLoginState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  @override
  _i4.Future<_i2.LoginState> doLoginWithEmailPassword({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #doLoginWithEmailPassword,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.LoginState>.value(_FakeLoginState_0(
          this,
          Invocation.method(
            #doLoginWithEmailPassword,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.LoginState>.value(_FakeLoginState_0(
          this,
          Invocation.method(
            #doLoginWithEmailPassword,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.LoginState>);

  @override
  String teste() => (super.noSuchMethod(
        Invocation.method(
          #teste,
          [],
        ),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.method(
            #teste,
            [],
          ),
        ),
        returnValueForMissingStub: _i5.dummyValue<String>(
          this,
          Invocation.method(
            #teste,
            [],
          ),
        ),
      ) as String);
}
