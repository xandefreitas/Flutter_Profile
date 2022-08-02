import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageUpdatingState extends LanguageState {}

class LanguageUpdatedState extends LanguageState {
  final Locale locale;

  const LanguageUpdatedState({required this.locale});

  @override
  List<Object> get props => [locale];
}

class LanguageFetchingState extends LanguageState {}

class LanguageFetchedState extends LanguageState {
  final Locale locale;

  const LanguageFetchedState({required this.locale});

  @override
  List<Object> get props => [locale];
}
