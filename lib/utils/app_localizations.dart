import 'dart:convert';
import 'package:basketball_stats/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

String tr(String key, {List<String>? args, BuildContext? context}) {
  BuildContext? ctx = context ?? navigatorKey.currentContext;
  if (ctx != null) {
    return AppLocalizations.of(ctx)!.translate(key, args);
  }
  return key; // Fallback if context is not available
}

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    String jsonString = await rootBundle.loadString(
      'assets/lang/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  String translate(String key, [List<String>? args]) {
    String text = _localizedStrings[key] ?? key;

    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        text = text.replaceFirst('{}', args[i]);
      }
    }

    return text;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'uk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
