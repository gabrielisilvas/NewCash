import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cliente_indicado_grid_item.dart';
import 'package:shop/models/cliente_indicado.dart';
import 'package:shop/models/cliente_indicado_list.dart';

class ClienteIndicadoGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ClienteIndicadoGrid(this.showFavoriteOnly, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClienteIndicadoList>(context);
    final List<ClienteIndicado> loadedClientes =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedClientes.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedClientes[i],
        child: const ClienteIndicadoGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
