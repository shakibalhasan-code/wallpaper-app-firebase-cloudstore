import 'package:firebase_cloudstorage/models/image_model.dart';
import 'package:firebase_cloudstorage/services/download_services.dart';
import 'package:firebase_cloudstorage/services/firebase_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   //the actual id will be add in future from auth current user
  final String userId = "user_id";
  final FirebaseServicesImages firebaseServices = FirebaseServicesImages();
  late Future<List<ImageData>> _imageDataFuture;
  final FileDownloaderServices _fileDownloaderServices = FileDownloaderServices();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();

  }
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      _imageDataFuture = firebaseServices.getImages();
    });
  }

  Future<void> _pickAndUploadImage() async {
    await firebaseServices.pickAndUploadImage();
    setState(() {
      _imageDataFuture = firebaseServices.getImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Gallery',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: _pickAndUploadImage,
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<List<ImageData>>(
        future: _imageDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found.'));
          } else {
            List<ImageData> images = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 5, // Spacing between columns
                mainAxisSpacing: 5, // Spacing between rows
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                ImageData image = images[index];
                return GestureDetector(
                  onLongPress: (){
                    _fileDownloaderServices.downloadFile(image.imageUrl, image.imageName,context);
                  },
                  child: GridTile(
                    child: Image.network(
                      image.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(image.imageName),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
