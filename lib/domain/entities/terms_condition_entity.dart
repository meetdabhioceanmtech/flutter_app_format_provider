import 'package:equatable/equatable.dart';

class TermsConditionEntity extends Equatable {
  final String title;
  final String description;

  const TermsConditionEntity({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [
        title,
        description,
      ];
}
