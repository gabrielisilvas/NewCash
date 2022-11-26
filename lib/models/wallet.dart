import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/models/wallet_item.dart';
import 'package:shop/models/cliente_indicado.dart';

class Wallet with ChangeNotifier {
  Map<String, WalletItem> _items = {};

  Map<String, WalletItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(ClienteIndicado clienteIndicado) {
    if (_items.containsKey(clienteIndicado.id)) {
      _items.update(
        clienteIndicado.id,
        (existingItem) => WalletItem(
          id: existingItem.id,
          clienteIndicadoId: existingItem.clienteIndicadoId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        clienteIndicado.id,
        () => WalletItem(
          id: Random().nextDouble().toString(),
          clienteIndicadoId: clienteIndicado.id,
          name: clienteIndicado.name,
          quantity: 1,
          price: clienteIndicado.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String clienteIndicadoId) {
    _items.remove(clienteIndicadoId);
    notifyListeners();
  }

  void removeSingleItem(String clienteIndicadoId) {
    if (!_items.containsKey(clienteIndicadoId)) {
      return;
    }

    if (_items[clienteIndicadoId]?.quantity == 1) {
      _items.remove(clienteIndicadoId);
    } else {
      _items.update(
        clienteIndicadoId,
        (existingItem) => WalletItem(
          id: existingItem.id,
          clienteIndicadoId: existingItem.clienteIndicadoId,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
