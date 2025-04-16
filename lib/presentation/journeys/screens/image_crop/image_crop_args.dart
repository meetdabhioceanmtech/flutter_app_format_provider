import 'package:equatable/equatable.dart';

class ImageCropArgs extends Equatable {
  final String imagePathOrURL;
  final double? aspectRatio; 

  const ImageCropArgs({
    required this.imagePathOrURL,
    this.aspectRatio,
  });

  @override
  List<Object?> get props => [imagePathOrURL, aspectRatio];
}
