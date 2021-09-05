class Payout {
  String id;
  String status;
  int amount;
  int points;
  bool approved;
  bool rejected;
  DateTime date;

  Payout({
    this.id,
    this.status,
    this.amount,
    this.points,
    this.approved,
    this.rejected,
    this.date,
  });
}
