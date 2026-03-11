import '../../../core/models/word_model.dart';

class MockDictionaryData {
  static const List<WordModel> words = [
    WordModel(id: 'w1', urdu: 'شکریہ', english: 'Thank you', category: 'Greetings'),
    WordModel(id: 'w2', urdu: 'سلام', english: 'Hello', category: 'Greetings'),
    WordModel(id: 'w3', urdu: 'خدا حافظ', english: 'Goodbye', category: 'Greetings'),
    WordModel(id: 'w4', urdu: 'معاف کیجیے', english: 'Sorry', category: 'Greetings'),

    WordModel(id: 'w5', urdu: 'ہاں', english: 'Yes', category: 'Common'),
    WordModel(id: 'w6', urdu: 'نہیں', english: 'No', category: 'Common'),
    WordModel(id: 'w7', urdu: 'پانی', english: 'Water', category: 'Daily'),
    WordModel(id: 'w8', urdu: 'کھانا', english: 'Food', category: 'Daily'),

    // Simple “phrase” examples
    WordModel(id: 'p1', urdu: 'آپ کیسے ہیں؟', english: 'How are you?', category: 'Phrases'),
    WordModel(id: 'p2', urdu: 'میرا نام…', english: 'My name is…', category: 'Phrases'),
  ];

  static List<String> categories(List<WordModel> list) {
    final set = <String>{};
    for (final w in list) set.add(w.category);
    final cats = set.toList()..sort();
    return ['All', ...cats];
  }
}
