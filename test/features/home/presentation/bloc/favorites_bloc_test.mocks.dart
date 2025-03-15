// Mocks generated by Mockito 5.4.4 from annotations
// in pinapp_challenge/test/features/home/presentation/bloc/favorites_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pinapp_challenge/features/home/domain/repositories/i_favorite_repository.dart'
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

/// A class which mocks [IFavoriteRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFavoriteRepository extends _i1.Mock
    implements _i2.IFavoriteRepository {
  @override
  _i3.Future<void> add({required int? id}) => (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
          {#id: id},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> remove({required int? id}) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
          {#id: id},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> isFavorite({required int? id}) => (super.noSuchMethod(
        Invocation.method(
          #isFavorite,
          [],
          {#id: id},
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<Set<int>> getFavorites() => (super.noSuchMethod(
        Invocation.method(
          #getFavorites,
          [],
        ),
        returnValue: _i3.Future<Set<int>>.value(<int>{}),
        returnValueForMissingStub: _i3.Future<Set<int>>.value(<int>{}),
      ) as _i3.Future<Set<int>>);
}
