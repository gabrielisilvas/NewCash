import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/cliente_indicado_item.dart';
import 'package:shop/models/cliente_indicado_list.dart';
import 'package:shop/utils/app_routes.dart';

class ClienteIndicadosPage extends StatelessWidget {
  const ClienteIndicadosPage({Key? key}) : super(key: key);

  Future<void> _refreshClienteIndicados(BuildContext context) {
    return Provider.of<ClienteIndicadoList>(
      context,
      listen: false,
    ).loadClienteIndicados();
  }

  @override
  Widget build(BuildContext context) {
    final ClienteIndicadoList clienteIndicados = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar indicações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.clienteIndicadoForm);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshClienteIndicados(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: clienteIndicados.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ClienteIndicadoItem(clienteIndicados.items[i]),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
