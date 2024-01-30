class FirestoreRequest {
  String entryId;
  String action;
  String dateRequested;
  String dateApproved;
  String entryOwner;

  FirestoreRequest(
      {required this.dateRequested,
      required this.dateApproved,
      required this.entryId,
      required this.action,
      required this.entryOwner});

  factory FirestoreRequest.fromJson(Map<String, dynamic> json) {
    return FirestoreRequest(
        entryId: json['entryId'],
        action: json['action'],
        dateRequested: json['dateRequested'],
        dateApproved: json['dateApproved'],
        entryOwner: json['entryOwner']);
  }

  Map<String, dynamic> toJson() => {
        'entryId': entryId,
        'action': action,
        'dateRequested': dateRequested,
        'dateApproved': dateApproved,
        'entryOwner': entryOwner
      };
}
