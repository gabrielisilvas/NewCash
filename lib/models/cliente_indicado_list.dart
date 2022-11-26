import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/cliente_indicado.dart';
import 'package:shop/utils/constants.dart';

class ClienteIndicadoList with ChangeNotifier {
  final String _token;
  final String _userId;
  final String _admin;
  List<ClienteIndicado> _items = [];

  List<ClienteIndicado> get items => [..._items];
  List<ClienteIndicado> get favoriteItems =>
      _items.where((cli) => cli.isFavorite).toList();

  ClienteIndicadoList(
      [this._token = '',
      this._userId = '',
      this._items = const [],
      this._admin = 'LDwp70a8yYWzR0BhfyKSJL3tHtr2']);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadClienteIndicados() async {
    _items.clear();

    final response = await http.get(
      Uri.parse(
          '${Constants.clienteIndicadoBaseUrl}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.userFavoritesUrl}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((clienteIndicadoId, clienteIndicadoData) {
      final isFavorite = favData[clienteIndicadoId] ?? false;
      _items.add(
        ClienteIndicado(
          id: clienteIndicadoId,
          name: clienteIndicadoData['name'],
          endereco: clienteIndicadoData['endereco'],
          price: clienteIndicadoData['price'],
          imageUrl: clienteIndicadoData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveClienteIndicado(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final clienteIndicado = ClienteIndicado(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      endereco: data['endereco'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateClienteIndicado(clienteIndicado);
    } else {
      return addClienteIndicado(clienteIndicado);
    }
  }

  Future<void> addClienteIndicado(ClienteIndicado clienteIndicado) async {
    final response = await http.post(
      Uri.parse(
          '${Constants.clienteIndicadoBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": clienteIndicado.name,
          "endereco": clienteIndicado.endereco,
          "price": clienteIndicado.price,
          "imageUrl": clienteIndicado.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(ClienteIndicado(
      id: id,
      name: clienteIndicado.name,
      endereco: clienteIndicado.endereco,
      price: clienteIndicado.price,
      imageUrl: clienteIndicado.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateClienteIndicado(ClienteIndicado clienteIndicado) async {
    int index = _items.indexWhere((p) => p.id == clienteIndicado.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.clienteIndicadoBaseUrl}/${clienteIndicado.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": clienteIndicado.name,
            "endereco": clienteIndicado.endereco,
            "price": clienteIndicado.price,
            "imageUrl": clienteIndicado.imageUrl,
          },
        ),
      );

      _items[index] = clienteIndicado;
      notifyListeners();
    }
  }

  Future<void> removeClienteIndicado(ClienteIndicado clienteIndicado) async {
    int index = _items.indexWhere((p) => p.id == clienteIndicado.id);

    if (index >= 0) {
      final clienteIndicado = _items[index];
      _items.remove(clienteIndicado);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.clienteIndicadoBaseUrl}/${clienteIndicado.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, clienteIndicado);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir a indicação.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
