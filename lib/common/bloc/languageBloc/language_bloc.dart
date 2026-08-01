import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/shared_preferences_util.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageEvent>((event, emit) async {
      switch (event) {
        case LanguageUpdateEvent():
          emit(LanguageUpdatingState());
          final locale = await SharedPreferencesUtil.setLocale(event.locale);
          emit(LanguageUpdatedState(locale: locale));
        case LanguageFetchEvent():
          emit(LanguageFetchingState());
          final locale = await SharedPreferencesUtil.getLocale();
          emit(LanguageFetchedState(locale: locale));
      }
    });
  }
}
