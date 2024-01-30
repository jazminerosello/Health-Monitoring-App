
class FirestoreEntry {
  bool none;
  bool fever;
  bool feelingFeverish;
  bool musclePain;
  bool cough;
  bool colds;
  bool soreThroat;
  bool difficultyBreathing;
  bool diarrhea;
  bool lossOfTaste;
  bool lossOfSmell;
  bool recentContact;

  String entryDate;
  String entryId;

  FirestoreEntry(
      {required this.none,
      required this.fever,
      required this.feelingFeverish,
      required this.musclePain,
      required this.cough,
      required this.colds,
      required this.soreThroat,
      required this.difficultyBreathing,
      required this.diarrhea,
      required this.lossOfTaste,
      required this.lossOfSmell,
      required this.recentContact,
      required this.entryDate,
      required this.entryId});

  factory FirestoreEntry.fromJson(Map<String, dynamic> json) {
    return FirestoreEntry(
        none: json['none'],
        fever: json['fever'],
        feelingFeverish: json['feelingFeverish'],
        musclePain: json['musclePain'],
        cough: json['cough'],
        colds: json['colds'],
        soreThroat: json['soreThroat'],
        difficultyBreathing: json['difficultyBreathing'],
        diarrhea: json['diarrhea'],
        lossOfTaste: json['lossOfTaste'],
        lossOfSmell: json['lossOfSmell'],
        recentContact: json['recentContact'],
        entryDate: json['entryDate'],
        entryId: json['entryId']);
  }

  Map<String, dynamic> toJson() => {
        'none': none,
        'fever': fever,
        'feelingFeverish': feelingFeverish,
        'musclePain': musclePain,
        'cough': cough,
        'colds': colds,
        'soreThroat': soreThroat,
        'difficultyBreathing': difficultyBreathing,
        'diarrhea': diarrhea,
        'lossOfTaste': lossOfTaste,
        'lossOfSmell': lossOfSmell,
        'recentContact': recentContact,
        'entryDate': entryDate,
        'entryId': entryId
      };
}
