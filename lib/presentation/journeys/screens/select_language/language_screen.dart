import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/languages.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/domain/repositories/api_repositorie.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/provider/app_provider/app_language_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/journeys/screens/select_language/language_widget.dart';
import 'package:flutter_project/presentation/provider/common_provider/loading_provider.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:flutter_project/presentation/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends LanguageWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguageProvider>(
      create: (_) => AppLanguageProvider(
        loadingProvider: context.read<LoadingProvider>(),
        apiUsecase: ApiUsecase(dataRepositories: context.read<ApiDataRepositories>()),
      )..loadInitialData(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final navigator = Navigator.of(context);
          var where = languages.where((element) => element.isDefault == 1).toList();
          if (where.isNotEmpty) {
            // Update app-level language settings
          }
          navigator.pop();
        },
        child: Scaffold(
          backgroundColor: appConstants.whiteBackgroundColor,
          appBar: customAppBar(
            context: context,
            title: TranslationConstants.language.translate(context),
            onTap: () {
              final navigator = Navigator.of(context);
              var where = languages.where((element) => element.isDefault == 1).toList();
              if (where.isNotEmpty) {
                // Update app-level language settings
              }
              navigator.pop();
            },
          ),
          body: Consumer<AppLanguageProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(child: CommonWidget.loadingIos());
              } else if (provider.errorMessage != null) {
                return CommonWidget.dataNotFound(
                  context: context,
                  onTap: () async => await provider.loadInitialData(),
                  actionButton: const SizedBox.shrink(),
                );
              } else {
                return languageLoadedView(context: context);
              }
            },
          ),
        ),
      ),
    );
  }
}
