import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/wallet_item.dart';
import 'package:shop/models/wallet.dart';
import 'package:shop/models/order_list.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Wallet wallet = Provider.of(context);
    final items = wallet.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu saldo'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${wallet.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  WalletButton(wallet: wallet),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => WalletItemWidget(items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletButton extends StatefulWidget {
  const WalletButton({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  final Wallet wallet;

  @override
  State<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.wallet.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).addOrder(widget.wallet);

                    widget.wallet.clear();
                    setState(() => _isLoading = false);
                  },
            child: const Text('RESGATAR'),
          );
  }
}
