import 'package:flutter/material.dart';
import 'package:flutter_project/common/constants/translation_constants.dart';
import 'package:flutter_project/common/extension/string_extension.dart';
import 'package:flutter_project/presentation/globals.dart';
import 'package:flutter_project/presentation/provider/app_provider/app_language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late AppLanguageProvider languageProvider;

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languageProvider.loadLanguagesFromAssets();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languageProvider.loader(false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appConstants.primary1Color,
        iconTheme: IconThemeData(color: appConstants.whiteBackgroundColor),
        title: Text(
          TranslationConstants.select_language.translate(context),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Consumer<AppLanguageProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading languages...'),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: TranslationConstants.search.translate(context),
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    provider.filterLanguageList(value);
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.languageEntity.length,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3.0,
                  ),
                  itemBuilder: (context, index) {
                    AppLanguageEntity appLanguageEntity = provider.languageEntity[index];
                    return languageContainer(
                      provider: provider,
                      index: index,
                      appLanguageEntity: appLanguageEntity,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                child: CommonWidget.commonButton(
                  alignment: Alignment.center,
                  borderRadius: 8,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  context: context,
                  text: TranslationConstants.submit.translate(context),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                  onTap: () async {
                    try {
                      await provider.setLocallyLanguage();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to set language: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget languageContainer({
    required AppLanguageProvider provider,
    required int index,
    required AppLanguageEntity appLanguageEntity,
  }) {
    final bool isSelected = provider.selectIndex == index;

    return GestureDetector(
      onTap: () => provider.selectLanguage(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                appLanguageEntity.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.check_circle, color: Colors.blue, size: 18),
              )
            else
              const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
