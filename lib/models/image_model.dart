class ImageData {
  final String imageUrl;
  final String imageName;

  ImageData({required this.imageUrl, required this.imageName});

  factory ImageData.fromMap(Map<String, dynamic> data) {
    return ImageData(
      imageUrl: data['imageUrl'] ?? '',
      imageName: data['imageName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'imageName': imageName,
    };
  }
}
