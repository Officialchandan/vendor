import 'dart:ui';

class Application {
  static Application application = Application.internal();

  factory Application() {
    return application;
  }
  Application.internal();

  final List<String> supportedLanguages = [
    "English",
    "Hindi",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "hi",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));
  //function to be invoked when changing the language
  LocaleChangeCallback? onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
