import 'package:flutter/material.dart';
import 'package:shop/models/cliente_indicado.dart';

class ClienteIndicadoDetailPage extends StatelessWidget {
  const ClienteIndicadoDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClienteIndicado clienteIndicado =
        ModalRoute.of(context)!.settings.arguments as ClienteIndicado;
    return Scaffold(
      appBar: AppBar(
        title: Text(clienteIndicado.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                clienteIndicado.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Telefone: ${clienteIndicado.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                clienteIndicado.endereco,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
