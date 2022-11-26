import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/cliente_indicado_grid.dart';
import 'package:shop/models/wallet.dart';
import 'package:shop/models/cliente_indicado_list.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all,
}

class ClienteIndicadosOverviewPage extends StatefulWidget {
  const ClienteIndicadosOverviewPage({Key? key}) : super(key: key);

  @override
  State<ClienteIndicadosOverviewPage> createState() =>
      _ClienteIndicadosOverviewPageState();
}

class _ClienteIndicadosOverviewPageState
    extends State<ClienteIndicadosOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ClienteIndicadoList>(
      context,
      listen: false,
    ).loadClienteIndicados().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas indicações'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Wallet>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.wallet);
              },
              icon: const Icon(Icons.wallet),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ClienteIndicadoGrid(_showFavoriteOnly),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.clienteIndicadoForm);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
