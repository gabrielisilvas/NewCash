import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/wallet.dart';
import 'package:shop/models/wallet_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          clienteIndicados:
              (orderData['clienteIndicado'] as List<dynamic>).map((item) {
            return WalletItem(
              id: item['id'],
              clienteIndicadoId: item['clienteIndicadoId'],
              name: item['name'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });

    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Wallet wallet) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': wallet.totalAmount,
          'date': date.toIso8601String(),
          'clienteIndicado': wallet.items.values
              .map(
                (walletItem) => {
                  'id': walletItem.id,
                  'clienteIndicadoId': walletItem.clienteIndicadoId,
                  'name': walletItem.name,
                  'quantity': walletItem.quantity,
                  'price': walletItem.price,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: wallet.totalAmount,
        date: date,
        clienteIndicados: wallet.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
