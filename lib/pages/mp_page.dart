import 'package:eventra_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class MpPage extends StatefulWidget{
  static const String routename = "MpPage";
  final bool isAdmin;
  final int userId;
  final String? url;

  const MpPage({super.key, this.url, required this.isAdmin, required this.userId});

  @override
  _MpPageState createState() => _MpPageState();
}

class _MpPageState extends State<MpPage> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchCustomTab(context);
    });
  }

  void _launchCustomTab(BuildContext context) async {
    try {
      await launchUrl(
        Uri.parse("${widget.url}"),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Theme.of(context).primaryColor,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
        ),
      );
    } catch (e) {
      // En caso de que ocurra algún error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir la página: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Center(
          child: Text(
            'Redirigiendo al formulario de Mercado Pago...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
      )
    );
  }
}