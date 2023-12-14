class BookingExpense {
  int? id;
  int bookingId;
  String expenseType;
  double amount;

  BookingExpense({
    this.id,
    required this.bookingId,
    required this.expenseType,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return{
      "ID": id,
      "bookingId": bookingId,
      "expenseType": expenseType,
      "amount": amount,
    };
  }
}
