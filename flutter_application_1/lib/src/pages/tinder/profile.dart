class Profile {
  const Profile({
    required this.matchName,
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.photoLink,
  });
  final String matchName;
  final String stadiumName;
  final String date;
  final String time;
  final String photoLink;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      matchName: json['matchName'] ?? '',
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photoLink: json['photo'] ?? '',
    );
  }
}