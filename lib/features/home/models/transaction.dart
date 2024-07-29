class Transaction {
  final String name;
  final String detail;
  final double amount;
  final bool isCredit;
  final String icon;

  Transaction({
    required this.name,
    required this.detail,
    required this.amount,
    required this.isCredit,
    required this.icon,
  });
}
