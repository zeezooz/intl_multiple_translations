import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

Future<bool> initializeMessages(String? localeName) async {
  final String? availableLocale = Intl.verifiedLocale(
    localeName,
    messages.containsKey,
    onFailure: (_) => null,
  );
  if (availableLocale == null) {
    return Future<bool>.value(false);
  }
  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(
    availableLocale,
    (String localeName) => messages[localeName],
  );
  return Future<bool>.value(true);
}

final Map<String, MessageLookupByLibrary> messages =
    <String, MessageLookupByLibrary>{
  'en': MessageLookupEn(),
  'es': MessageLookupEs(),
};

class MessageLookupEn extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, Function> messages = <String, Function>{
    'message1': MessageLookupByLibrary.simpleMessage(
      'Message 1 in English.',
    ),
    'common': MessageLookupByLibrary.simpleMessage(
      'Common message in English from messages1.',
    ),
  };
}

class MessageLookupEs extends MessageLookupByLibrary {
  @override
  String get localeName => 'es';

  @override
  final Map<String, Function> messages = <String, Function>{
    'message1': MessageLookupByLibrary.simpleMessage(
      'Message 1 in Spanish.',
    ),
    'common': MessageLookupByLibrary.simpleMessage(
      'Common message in Spanish from messages1.',
    ),
  };
}
