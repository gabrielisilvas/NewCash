import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/wallet.dart';
import 'package:shop/models/wallet_item.dart';

class WalletItemWidget extends StatelessWidget {
  final WalletItem walletItem;

  const WalletItemWidget(this.walletItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(walletItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tem Certeza?'),
            content: const Text('Quer remover a indicação'),
            actions: [
              TextButton(
                child: const Text('Não'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Wallet>(
          context,
          listen: false,
        ).removeItem(walletItem.clienteIndicadoId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${walletItem.price}'),
                ),
              ),
            ),
            title: Text(walletItem.name),
            subtitle:
                Text('Total: R\$ ${walletItem.price * walletItem.quantity}'),
            trailing: Text('${walletItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
