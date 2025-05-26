class PaymentDetails {
  final String studentName;
  final String studentLevel; // e.g., "3 ème année moyenne - m2"
  final String studentImageUrl;
  final double amountToPay;
  final double amountDeposited;
  final String paymentDeadline;
  final String studentId;

  PaymentDetails({
    required this.studentName,
    required this.studentLevel,
    required this.studentImageUrl,
    required this.amountToPay,
    required this.amountDeposited,
    required this.paymentDeadline,
    required this.studentId,
  });

  // Calculate remaining amount to pay
  double get remainingAmount => amountToPay - amountDeposited;

  // Check if payment is complete
  bool get isPaymentComplete => remainingAmount <= 0;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      studentName: json['studentName'] ?? '',
      studentLevel: json['studentLevel'] ?? '',
      studentImageUrl: json['studentImageUrl'] ?? '',
      amountToPay: (json['amountToPay'] ?? 0).toDouble(),
      amountDeposited: (json['amountDeposited'] ?? 0).toDouble(),
      paymentDeadline: json['paymentDeadline'] ?? '',
      studentId: json['studentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'studentLevel': studentLevel,
      'studentImageUrl': studentImageUrl,
      'amountToPay': amountToPay,
      'amountDeposited': amountDeposited,
      'paymentDeadline': paymentDeadline,
      'studentId': studentId,
    };
  }
}

// Model for individual transfer/wire transfer entries
class WireTransfer {
  final String senderRip; // RIP de expéditeur
  final String receiverRip; // RIP de Récepteur (l'école)
  final String expeditionDate;
  final double amount;
  final String transferId;

  WireTransfer({
    required this.senderRip,
    required this.receiverRip,
    required this.expeditionDate,
    required this.amount,
    required this.transferId,
  });

  factory WireTransfer.fromJson(Map<String, dynamic> json) {
    return WireTransfer(
      senderRip: json['senderRip'] ?? '',
      receiverRip: json['receiverRip'] ?? '',
      expeditionDate: json['expeditionDate'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transferId: json['transferId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderRip': senderRip,
      'receiverRip': receiverRip,
      'expeditionDate': expeditionDate,
      'amount': amount,
      'transferId': transferId,
    };
  }
}

// Complete payment information model
class PaymentInfo {
  final PaymentDetails paymentDetails;
  final List<WireTransfer> wireTransfers;

  PaymentInfo({
    required this.paymentDetails,
    required this.wireTransfers,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails'] ?? {}),
      wireTransfers: (json['wireTransfers'] as List<dynamic>?)
          ?.map((transfer) => WireTransfer.fromJson(transfer))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentDetails': paymentDetails.toJson(),
      'wireTransfers': wireTransfers.map((transfer) => transfer.toJson()).toList(),
    };
  }
}