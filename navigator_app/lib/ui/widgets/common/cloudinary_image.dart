import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:navigator_app/data/services/cloudinary_service.dart';

class CloudinaryImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  
  const CloudinaryImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 300,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Extract public ID from URL
    final cloudinaryService = CloudinaryService();
    final publicId = cloudinaryService.publicIdFromUrl(imageUrl);
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CldImageWidget(
        publicId: publicId,
        width: width,
        height: height,
        fit: fit,
        transformation: Transformation()
          ..resize(Resize.fill()
            ..width(width.toInt())
            ..height(height.toInt())
          ),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(Icons.error, color: Colors.red),
          );
        },
        // loadingBuilder: (context) {
        //   return Container(
        //     width: width,
        //     height: height,
        //     color: Colors.grey[200],
        //     child: Center(child: CircularProgressIndicator()),
        //   );
        // },
      ),
    );
  }
}
