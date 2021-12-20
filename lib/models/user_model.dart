class User {
  String id;
  String name;
  int points;
  int allTimepoints;
  List activityHistory; //array
  String email;
  String referralCode;
  String country;
  String countyCode;
  List referrals;
  bool playStoreReview;

  User({
    this.id,
    this.name,
    this.points,
    this.email,
    this.country,
    this.referralCode,
    this.activityHistory,
    this.allTimepoints,
    this.playStoreReview,
    this.referrals,
    this.countyCode,
  });
}
