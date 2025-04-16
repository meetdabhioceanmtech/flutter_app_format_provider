import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/data/core/build_context.dart';
import 'package:flutter_project/presentation/app_localizations.dart';

extension StringExtension on String {
  String intelliTrim() {
    return length > 15 ? '${substring(0, 15)}...' : this;
  }

  // String translate(context) {
  //   String? requiredLabel = AppLocalizations.of(context ?? buildContext)?.translate(this);

  //   if (requiredLabel?.isNotEmpty ?? false) {
  //     return requiredLabel!;
  //   }
  //   return AppLocalizations.of(context ?? buildContext)?.defaultTranslate(this) ?? '';
  // }

  String translate(BuildContext? context) {
    String label = (AppLocalizations.of(context ?? buildContext)?.translate(this) ??
            AppLocalizations.of(context ?? buildContext)?.defaultTranslate(this) ??
            '')
        .replaceAll("\\n", "\n")
        .replaceAll("==", "\n");

    return label.isNotEmpty
        ? label
        : (AppLocalizations.of(context ?? buildContext)?.defaultTranslate(this) ?? '')
            .replaceAll("\\n", "\n")
            .replaceAll("==", "\n");
  }

  String countryTrim() {
    return length > 20 ? '${substring(0, 20)}...' : this;
  }

  String toCamelcase() {
    return toLowerCase().replaceAllMapped(RegExp(r'\b\w'), (match) => match.group(0)!.toUpperCase());
    // return length > 1 ? substring(0, 1).toUpperCase() + substring(1, length) : this;
  }

  Color toColor() {
    try {
      var hexColor = replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      }
      return const Color(0xFFFFFFFF);
    } on Exception {
      return const Color(0xFFFFFFFF);
    }
  }

  double toDoubleFromCurrencyFormat() {
    String cleanedString = replaceAll(',', '');
    return double.tryParse(cleanedString) ?? 0;
  }

  String boldTag() {
    return "<b>${toString()}</b>".replaceAll(".", "");
  }

  String removeHTMLTag() {
    return toString()
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("<br />", "")
        .replaceAll("&nbsp;", " ")
        .replaceAll("&amp;", "&")
        .replaceAll("</p>", "")
        .replaceAll(".", "");
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension CurrencyFormatter on num {
  String formatCurrency({int? decimalDigits}) {
    final formatCurrency = NumberFormat.currency(symbol: '₹', locale: 'en_IN', decimalDigits: decimalDigits ?? 0);
    return formatCurrency.format(this);
  }
}
