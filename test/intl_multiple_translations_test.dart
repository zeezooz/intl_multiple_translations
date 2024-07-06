import 'package:intl/intl.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:intl_multiple_translations/intl_multiple_translations.dart';
import 'package:test/test.dart';

import '../example/l10n/messages1.dart' as messages1;
import '../example/l10n/messages2.dart' as messages2;

void main() {
  setUp(() {
    messageLookup =
        UninitializedLocaleData<void>('initializeMessages(<locale>)', null);
  });

  group('Multiple translations.', () {
    test(
      'Should extend.',
      () async {
        initializeMultipleTranslations();
        await messages1.initializeMessages('es');
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('message1'),
            'Message 1 in Spanish.',
          );
          expect(
            Intl.message('message2'),
            'Message 2 in Spanish.',
          );
        });
      },
    );

    test(
      'Should override.',
      () async {
        initializeMultipleTranslations();
        await messages1.initializeMessages('es');
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages2.',
          );
        });
      },
    );

    test(
      'Should override after use.',
      () async {
        initializeMultipleTranslations();
        await messages1.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages1.',
          );
        });
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages2.',
          );
        });
      },
    );

    test(
      'Should extend an already initialized lookup.',
      () async {
        await messages1.initializeMessages('es');
        initializeMultipleTranslations();
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('message1'),
            'Message 1 in Spanish.',
          );
          expect(
            Intl.message('message2'),
            'Message 2 in Spanish.',
          );
        });
      },
    );

    test(
      'Should override an already initialized lookup.',
      () async {
        await messages1.initializeMessages('es');
        initializeMultipleTranslations();
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages2.',
          );
        });
      },
    );

    test(
      'Should override after using an already initialized lookup.',
      () async {
        await messages1.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages1.',
          );
        });
        initializeMultipleTranslations();
        await messages2.initializeMessages('es');
        Intl.withLocale('es', () {
          expect(
            Intl.message('common'),
            'Common message in Spanish from messages2.',
          );
        });
      },
    );

    test(
      'Should throw on unsupported messageLookup.',
      () async {
        initializeInternalMessageLookup(() => TestMessageLookup());
        expect(
          initializeMultipleTranslations,
          throwsUnsupportedError,
        );
      },
    );

    test(
      'Should throw on unsupported availableMessages.',
      () async {
        initializeMultipleTranslations();
        (messageLookup as MultipleCompositeMessageLookup)
            .availableMessages['es'] = messages1.MessageLookupEs();
        expect(
          () => messages2.initializeMessages('es'),
          throwsUnsupportedError,
        );
      },
    );
  });
}

class TestMessageLookup implements MessageLookup {
  @override
  void addLocale(String localeName, Function findLocale) {
    throw UnimplementedError();
  }

  @override
  String? lookupMessage(
    String? messageText,
    String? locale,
    String? name,
    List<Object>? args,
    String? meaning, {
    MessageIfAbsent? ifAbsent,
  }) {
    throw UnimplementedError();
  }
}
