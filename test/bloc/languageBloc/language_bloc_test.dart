import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_event.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<LanguageBloc, LanguageState>(
    'emits [Fetching, Fetched] with the default locale when nothing is stored',
    build: LanguageBloc.new,
    act: (bloc) => bloc.add(LanguageFetchEvent()),
    expect: () => [LanguageFetchingState(), const LanguageFetchedState(locale: Locale('en'))],
  );

  blocTest<LanguageBloc, LanguageState>(
    'emits [Updating, Updated] and persists the new locale for subsequent fetches',
    build: LanguageBloc.new,
    act: (bloc) async {
      bloc.add(const LanguageUpdateEvent(locale: Locale('pt')));
      await Future<void>.delayed(Duration.zero);
      bloc.add(LanguageFetchEvent());
    },
    expect: () => [
      LanguageUpdatingState(),
      const LanguageUpdatedState(locale: Locale('pt')),
      LanguageFetchingState(),
      const LanguageFetchedState(locale: Locale('pt')),
    ],
  );
}
