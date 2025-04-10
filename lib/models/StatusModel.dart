class Status {
  final int lookupID;
  final String lookupName;
  final String lookupType;

  Status({required this.lookupID, required this.lookupName,required this.lookupType,});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      lookupID: json['lookupID'],
      lookupName: json['lookupName'],
      lookupType: json['lookupType'],

    );
  }

}
