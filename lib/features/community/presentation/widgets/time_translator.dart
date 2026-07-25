String translateTimeAgo(String englishTime) {
  final regex = RegExp(r'(\d+)\s+(second|minute|hour|day|week|month|year)s?\s+ago');
  final match = regex.firstMatch(englishTime);

  if (englishTime.trim().toLowerCase() == 'just now') {
    return 'الآن';
  }

  if (match == null) return englishTime; // إذا ما قدر يفهم الصيغة، يرجع النص متل ما هو

  final number = int.parse(match.group(1)!);
  final unit = match.group(2)!;

  final Map<String, Map<String, String>> translations = {
    'second': {'one': 'ثانية', 'two': 'ثانيتين', 'few': 'ثواني', 'many': 'ثانية'},
    'minute': {'one': 'دقيقة', 'two': 'دقيقتين', 'few': 'دقائق', 'many': 'دقيقة'},
    'hour':   {'one': 'ساعة', 'two': 'ساعتين', 'few': 'ساعات', 'many': 'ساعة'},
    'day':    {'one': 'يوم', 'two': 'يومين', 'few': 'أيام', 'many': 'يوم'},
    'week':   {'one': 'أسبوع', 'two': 'أسبوعين', 'few': 'أسابيع', 'many': 'أسبوع'},
    'month':  {'one': 'شهر', 'two': 'شهرين', 'few': 'أشهر', 'many': 'شهر'},
    'year':   {'one': 'سنة', 'two': 'سنتين', 'few': 'سنوات', 'many': 'سنة'},
  };

  final unitMap = translations[unit]!;

  String unitWord;
  if (number == 1) {
    unitWord = unitMap['one']!;
    return 'منذ $unitWord';
  } else if (number == 2) {
    unitWord = unitMap['two']!;
    return 'منذ $unitWord';
  } else if (number >= 3 && number <= 10) {
    unitWord = unitMap['few']!;
    return 'منذ $number $unitWord';
  } else {
    unitWord = unitMap['many']!;
    return 'منذ $number $unitWord';
  }
}