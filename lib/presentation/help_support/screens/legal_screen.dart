// ignore_for_file: use_build_context_synchronously

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/help_support/controllers/help_support_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class LegalScreen extends StatefulWidget {
  final String type; // privacy or terms

  const LegalScreen({super.key, required this.type});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HelpSupportProvider>().loadLegal(widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        showBottom: true,
        widget.type == "privacy" ? "privacyPolicy".tr : "termsConditions".tr,
      ),
      body: Consumer<HelpSupportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: LoadingWidget(size: 40));
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final data = provider.legalModel?.data;

          if (data == null) {
            return const Center(child: Text("No Data"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Html(
                  data: data.content ?? "",
                  style: {"body": Style(fontWeight: FontWeight.normal)},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
