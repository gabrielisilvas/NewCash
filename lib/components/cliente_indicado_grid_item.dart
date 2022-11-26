import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/wallet.dart';
import 'package:shop/models/cliente_indicado.dart';
import 'package:shop/utils/app_routes.dart';

class ClienteIndicadoGridItem extends StatelessWidget {
  const ClienteIndicadoGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clienteIndicado =
        Provider.of<ClienteIndicado>(context, listen: false);
    final wallet = Provider.of<Wallet>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            clienteIndicado.name,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          child: Image.network(
            clienteIndicado.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.clienteIndicadoDetail,
              arguments: clienteIndicado,
            );
          },
        ),
      ),
    );
  }
}
