// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:intl_multiple_translations/intl_multiple_translations.dart';

// Some translations.
import 'l10n/messages1.dart' as messages1;
import 'l10n/messages2.dart' as messages2;

Future<void> main() async {
  // One translation may be loaded earlier.
  await messages1.initializeMessages('es');
  // Use the package.
  initializeMultipleTranslations();
  // Load additional translations as usual.
  await messages2.initializeMessages('es');
  // Don't forget to set the locale.
  Intl.defaultLocale = 'es';
  // Translate messages as usual.
  print(Intl.message('Message 1', name: 'message1'));
  print(Intl.message('Message 2', name: 'message2'));
}
