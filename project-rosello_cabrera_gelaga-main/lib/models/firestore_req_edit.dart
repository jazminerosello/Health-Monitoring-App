class FirestoreRequestEdit {
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
  String entryId;
  String entryDate;
  String entryOwner;
  String action;
  String dateRequested;
  String dateApproved;

  FirestoreRequestEdit(
      {required this.none,
      required this.entryOwner,
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
      required this.entryId,
      required this.entryDate,
      required this.action,
      required this.dateRequested,
      required this.dateApproved});

  factory FirestoreRequestEdit.fromJson(Map<String, dynamic> json) {
    return FirestoreRequestEdit(
        none: json['none'],
        entryOwner: json['entryOwner'],
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
        entryId: json['entryId'],
        entryDate: json['entryDate'],
        action: json['action'],
        dateRequested: json['dateRequested'],
        dateApproved: json['dateApproved']);
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
        'entryId': entryId,
        'entryDate': entryDate,
        'action': action,
        'dateRequested': dateRequested,
        'dateApproved': dateApproved,
        'entryOwner': entryOwner,
      };
}
