class ServiceImage {
  int id;
  String image;

  ServiceImage({required this.id, required this.image});

  String get _formatId => '$id'.padLeft(4, '0');
  String get imageName => 'image_$_formatId';
}