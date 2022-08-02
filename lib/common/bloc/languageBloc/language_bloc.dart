import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_event.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_state.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageEvent>((event, emit) async {
      if (event is LanguageUpdateEvent) {
        emit(LanguageUpdatingState());
        final locale = await SharedPreferencesUtil.setLocale(event.locale);
        emit(LanguageUpdatedState(locale: locale));
      }
      if (event is LanguageFetchEvent) {
        emit(LanguageFetchingState());
        final locale = await SharedPreferencesUtil.getLocale();
        emit(LanguageFetchedState(locale: locale));
      }
    });
  }
}
