import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:navigator_app/core/constant/cloudinary_config.dart';

class CloudinaryService {
  // Upload a single image to Cloudinary
  Future<Map<String, dynamic>> uploadImage(File imageFile, String folder)  async {
    final url = Uri.parse(CloudinaryConfig.uploadUrl());
    
    // Create multipart request
    final request = http.MultipartRequest('POST', url) 
      ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
      ..fields['folder'] = folder;
    
    // Get file extension
    final fileExtension = path.extension(imageFile.path).replaceAll('.', '');
    
    // Add file to request
    final fileStream = http.ByteStream(imageFile.openRead());
    final fileLength = await imageFile.length();
    
    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: path.basename(imageFile.path) ,
      contentType: MediaType('image', fileExtension),
    );
    
    request.files.add(multipartFile);
    
    try {
      // Send request
      final response = await request.send();
      
      // Get response
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      
      // Parse response
      final parsedResponse = jsonDecode(responseString);
      
      if (response.statusCode == 200) {
        return parsedResponse;
      } else {
        throw Exception('Failed to upload image: ${parsedResponse['error']['message']}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
  
  // Upload multiple images to Cloudinary
  Future<List<Map<String, dynamic>>> uploadMultipleImages(
    List<File> imageFiles, 
    String folder
  ) async {
    final results = <Map<String, dynamic>>[];
    
    for (final file in imageFiles) {
      final result = await uploadImage(file, folder);
      results.add(result);
    }
    
    return results;
  }
  
  // Extract public ID from Cloudinary URL
  String publicIdFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    
    // Find the index after 'upload' (which might include version)
    int startIndex = 0;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i].contains('upload')) {
        startIndex = i + 1;
        break;
      }
    }
    
    // Join the remaining path segments to form the public ID
    return pathSegments.sublist(startIndex).join('/');
  }
}
