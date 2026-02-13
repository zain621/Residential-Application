/// Bill Model: Shared data model for bill screens.
class BillItem {
  const BillItem({
    required this.title,
    required this.billDate,
    required this.payBefore,
    required this.amount,
    required this.status,
    required this.showPayButton,
  });

  final String title;
  final String billDate;
  final String payBefore;
  final String amount;
  final String status;
  final bool showPayButton;
}
