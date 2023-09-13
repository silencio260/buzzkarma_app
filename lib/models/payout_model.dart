class Payout {
  String id;
  String status;
  String paymentEmail;
  int amount;
  int points;
  bool approved;
  bool rejected;
  DateTime date;

  Payout({
    this.id,
    this.status,
    this.paymentEmail,
    this.amount,
    this.points,
    this.approved,
    this.rejected,
    this.date,
  });
}
