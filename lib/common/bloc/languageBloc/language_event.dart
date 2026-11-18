import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageUpdateEvent extends LanguageEvent {
  final Locale locale;

  const LanguageUpdateEvent({required this.locale});

  @override
  List<Object> get props => [locale];
}

class LanguageFetchEvent extends LanguageEvent {}
