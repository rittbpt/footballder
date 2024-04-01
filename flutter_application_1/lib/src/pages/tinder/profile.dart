class Profile {
  const Profile({
    required this.matchName,
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.photoLink,
    required this.available,
    required this.matchId,
  });
  final String matchName;
  final String stadiumName;
  final String date;
  final String time;
  final String photoLink;
  final int available;
  final int matchId;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      matchName: json['matchName'] ?? '',
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photoLink: json['photo'] ?? '',
      available: json['available'] != null
          ? int.tryParse(json['available'].toString()) ?? 0
          : 0,
      matchId: json['MatchId'] != null
          ? int.tryParse(json['MatchId'].toString()) ?? 0
          : 0,
    );
  }
}
