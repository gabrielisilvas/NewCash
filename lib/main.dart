import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cliente_indicado_list.dart';
import 'package:shop/models/wallet.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cliente_indicado_detail_page.dart';
import 'package:shop/pages/cliente_indicado_form_page.dart';
import 'package:shop/pages/cliente_indicado_page.dart';
import 'package:shop/pages/wallet_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ClienteIndicadoList>(
          create: (_) => ClienteIndicadoList(),
          update: (ctx, auth, previous) {
            return ClienteIndicadoList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Wallet(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.black,
            secondary: Colors.red,
          ),
          fontFamily: 'Lato',
        ),
        // home: const ClienteIndicadosOverviewPage(),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.clienteIndicadoDetail: (ctx) =>
              const ClienteIndicadoDetailPage(),
          AppRoutes.wallet: (ctx) => const WalletPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.clienteIndicado: (ctx) => const ClienteIndicadosPage(),
          AppRoutes.clienteIndicadoForm: (ctx) =>
              const ClienteIndicadoFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
