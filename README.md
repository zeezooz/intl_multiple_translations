Allows [intl](https://pub.dev/packages/intl) to load more than one translation for each locale.

It keeps an already loaded translation if the intl message lookup mechanism was
initialized with a
[`CompositeMessageLookup`](https://pub.dev/documentation/intl/latest/message_lookup_by_library/CompositeMessageLookup-class.html)
subclass (as [intl_translation](https://pub.dev/packages/intl_translation) and
[intl_utils](https://pub.dev/packages/intl_utils) do).

## Usage

Call `initializeMultipleTranslations()` before loading another translation for
the same locale.

You can do this before loading any translation, for example, in the main
function:

```dart
import 'package:intl_multiple_translations/intl_multiple_translations.dart';

Future<void> main() async {
  initializeMultipleTranslations();
  await initializeMessages('es');
  await initializeMoreMessages('es');
  ...
}
```

or before loading additional translations, for example, in a package:

```dart
import 'package:intl_multiple_translations/intl_multiple_translations.dart';

Future<bool> initializePackageMessages(String localeName) {
  initializeMultipleTranslations();
  return initializeMessages(localeName);
}
```
