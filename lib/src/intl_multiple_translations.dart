import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

/// Initialize the message lookup mechanism with multiple translations
/// per locale. Reuse already loaded translations.
void initializeMultipleTranslations() {
  if (messageLookup is! MultipleCompositeMessageLookup) {
    final MessageLookup oldMessageLookup = messageLookup;
    // Reset messageLookup from intl_helpers.dart so it can be replaced
    // if it's already initialized.
    if (messageLookup is! UninitializedLocaleData) {
      messageLookup =
          UninitializedLocaleData<void>('initializeMessages(<locale>)', null);
    }
    initializeInternalMessageLookup(
      () => MultipleCompositeMessageLookup(oldMessageLookup),
    );
  }
}

/// This is a message lookup mechanism that supports multiple translations
/// per locale.
class MultipleCompositeMessageLookup extends CompositeMessageLookup {
  /// A constructor that reuses the translation from [messageLookup].
  MultipleCompositeMessageLookup(MessageLookup messageLookup) {
    if (messageLookup is UninitializedLocaleData) return;
    if (messageLookup is! CompositeMessageLookup) {
      throw UnsupportedError('Unsupported messageLookup type: '
          '${messageLookup.runtimeType} is not a subclass of '
          'CompositeMessageLookup.');
    }
    availableMessages = <String, MessageLookupByLibrary>{
      for (final MapEntry<String, MessageLookupByLibrary> entry
          in messageLookup.availableMessages.entries)
        entry.key: ExtendableMessageLookupByLibrary(entry.value),
    };
  }

  /// [findLocale] will be called and the result merged with the existing
  /// translations for [localeName].
  @override
  void addLocale(String localeName, Function findLocale) {
    final String canonical = Intl.canonicalizedLocale(localeName);
    final MessageLookupByLibrary? newLocale =
        // ignore: avoid_dynamic_calls
        findLocale(canonical) as MessageLookupByLibrary?;
    if (newLocale == null) return;
    final MessageLookupByLibrary? locale = availableMessages[canonical];
    if (locale == null) {
      return super.addLocale(localeName, (String canonical) {
        return ExtendableMessageLookupByLibrary(newLocale);
      });
    }
    if (locale is! ExtendableMessageLookupByLibrary) {
      throw UnsupportedError('Unsupported availableMessages value type: '
          '${locale.runtimeType} is not a subclass of '
          'ExtendableMessageLookupByLibrary.');
    }
    locale.extend(newLocale);
  }
}

/// A class for messages lookup that can be extended with messages from
/// another translation.
class ExtendableMessageLookupByLibrary extends MessageLookupByLibrary {
  /// Create an instance with messages from [locale].
  ExtendableMessageLookupByLibrary(MessageLookupByLibrary locale)
      : localeName = locale.localeName {
    extend(locale);
  }

  /// Add messages from [locale].
  void extend(MessageLookupByLibrary locale) {
    for (final MapEntry<String, dynamic> entry in locale.messages.entries) {
      messages[entry.key] = <dynamic>[locale, entry.value];
    }
  }

  @override
  String? evaluateMessage(dynamic translation, List<dynamic> args) {
    // ignore: avoid_dynamic_calls
    return translation[0].evaluateMessage(translation[1], args) as String?;
  }

  /// Locale name , e.g. 'en_US'
  @override
  final String localeName;

  /// Map a message to a list of the original locale and the original message
  /// value. The locale is used to evaluate the value in [evaluateMessage].
  @override
  final Map<String, dynamic> messages = <String, dynamic>{};
}
