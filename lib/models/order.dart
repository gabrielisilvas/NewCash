import 'package:shop/models/wallet_item.dart';

class Order {
  final String id;
  final double total;
  final List<WalletItem> clienteIndicados;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.clienteIndicados,
    required this.date,
  });
}
