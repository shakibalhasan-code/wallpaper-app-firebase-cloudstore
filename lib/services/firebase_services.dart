import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_cloudstorage/models/image_model.dart';

class FirebaseServicesImages {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<ImageData>> pickAndUploadImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final fileName = 'profile_${DateTime.now().microsecondsSinceEpoch}.jpg';

      try {
        // Upload image to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(fileName)
            .putFile(file);

        // Get image download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save image URL to Firestore
        await FirebaseFirestore.instance
            .collection('profile')
            .doc('user_id')
            .update({
          'images': FieldValue.arrayUnion([{'imageUrl': downloadUrl, 'imageName': fileName}])
        });

        // Fetch the updated list of images
        return await getImages();
      } catch (e) {
        print('Error uploading image: $e');
        return [];
      }
    }
    return [];
  }

  Future<List<ImageData>> getImages() async {
    try {
      DocumentSnapshot userImagesDoc = await FirebaseFirestore.instance
          .collection('profile')
          .doc('user_id')
          .get();

      print('Document data: ${userImagesDoc.data()}'); // Debugging information

      if (userImagesDoc.exists) {
        Map<String, dynamic> data = userImagesDoc.data() as Map<String, dynamic>;
        if (data['images'] != null) {
          List<ImageData> images = (data['images'] as List)
              .map((imageData) => ImageData.fromMap(imageData))
              .toList();
          return images;
        }
      }
      return [];
    } catch (e) {
      print('Error getting images: $e');
      return [];
    }
  }

}
