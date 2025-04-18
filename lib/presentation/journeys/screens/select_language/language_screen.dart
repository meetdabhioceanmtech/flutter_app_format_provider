import 'package:flutter/material.dart';
import 'package:flutter_project/presentation/provider/app_provider/app_language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';
import 'package:flutter_project/presentation/widgets/common_widget.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<AppLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(
          'select_language',
          defaultValue: 'Select Language',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: languageProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : languageProvider.errorMessage != null
              ? Center(child: Text(languageProvider.errorMessage!))
              : languageLoadedView(context: context),
    );
  }

  Widget languageLoadedView({required BuildContext context}) {
    return Consumer<AppLanguageProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: provider.getLabel('search', defaultValue: 'Search'),
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
                text: provider.getLabel('submit', defaultValue: 'Submit'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                onTap: () async {
                  await provider.setLocallyLanguage(index: provider.selectIndex);
                  // Navigate back after selecting language
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget languageContainer({
    required AppLanguageProvider provider,
    required int index,
    required AppLanguageEntity appLanguageEntity,
  }) {
    final bool isSelected = provider.selectIndex == index;

    return GestureDetector(
      onTap: () {
        provider.selectIndex = index;
        provider.notifyListeners();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
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

class TranslatedText extends StatelessWidget {
  final String translationKey;
  final String defaultValue;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TranslatedText(
    this.translationKey, {
    super.key,
    this.defaultValue = '',
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppLanguageProvider>(context);
    return Text(
      provider.getLabel(translationKey, defaultValue: defaultValue),
      style: style,
      textAlign: textAlign,
    );
  }
}
