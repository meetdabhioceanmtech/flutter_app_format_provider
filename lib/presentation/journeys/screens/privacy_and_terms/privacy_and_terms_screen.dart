// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extention/string_extension.dart';
import 'package:flutter_project/domain/repositories/api_repositorie.dart';
import 'package:flutter_project/domain/usecases/api_usecase.dart';
import 'package:flutter_project/presentation/provider/loading/loading_provider.dart';
import 'package:flutter_project/presentation/provider/terms_condition/terms_condition_provider.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';
import 'package:flutter_project/presentation/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;

enum TypeScreen { PRIVACY_CONDITION, TERMS_CONDITION }

class PrivacyAndTermsScreen extends StatefulWidget {
  final TypeScreen typeScreen;

  const PrivacyAndTermsScreen({super.key, required this.typeScreen});

  @override
  State<PrivacyAndTermsScreen> createState() => _PrivacyAndTermsScreenState();
}

class _PrivacyAndTermsScreenState extends State<PrivacyAndTermsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TermsConditionProvider>(
      create: (_) => TermsConditionProvider(
        loadingProvider: context.read<LoadingProvider>(),
        apiUsecase: ApiUsecase(dataRepositories: context.read<ApiDataRepositories>()),
      )..fetchTermsCondition(typeScreen: widget.typeScreen),
      child: _PrivacyAndTermsView(typeScreen: widget.typeScreen),
    );
  }
}

class _PrivacyAndTermsView extends StatelessWidget {
  final TypeScreen typeScreen;

  const _PrivacyAndTermsView({required this.typeScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appConstants.grayBackgroundColor,
      appBar: customAppBar(
        context: context,
        title: typeScreen == TypeScreen.PRIVACY_CONDITION
            ? TranslationConstants.privacy_policy.translate(context)
            : TranslationConstants.terms_condition.translate(context),
      ),
      body: Consumer<TermsConditionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return CommonWidget.loadingIos();
          } else if (provider.errorMessage != null) {
            return CommonWidget.dataNotFound(
              context: context,
              heading: TranslationConstants.something_went_wrong.translate(context),
              subHeading: provider.errorMessage!,
              buttonLabel: TranslationConstants.try_again.translate(context),
              onTap: () => provider.fetchTermsCondition(typeScreen: typeScreen),
            );
          } else if (provider.termsData != null) {
            dom.Document document = htmlparser.parse(provider.termsData!.description);

            return Html.fromDom(document: document);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
