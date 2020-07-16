class Language {

  Language(this.id, this.name, this.flag, this.languageCode);

  final int id;
  final String name;
  final String flag;
  final String languageCode;

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇬🇧',  'en'),
      Language(2, "Hindi", '🇮🇳', 'hi')
    ];
  }

}