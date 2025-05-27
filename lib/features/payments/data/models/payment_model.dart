// ./lib/features/payments/data/models/payment_model.dart
class PaymentDetails {
  final String billId;
  final String title;
  final String description;
  final double amount;
  final String paymentStatus;
  final DateTime createdAt;

  PaymentDetails({
    required this.billId,
    required this.title,
    required this.description,
    required this.amount,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      billId: json['billId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'title': title,
      'description': description,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
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