class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'dcq4awvap';
  static const String uploadPreset = 'event_images';
  static const String userUploadPreset = 'user_profile_image';
  static const String profileFolder = '';
  static const String eventFolder = 'events';
  static const String apiKey = '';
  static const String apiSecret = '';

  static String uploadUrl() => 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  
  // Folder structure for events
  static String eventImagePath(String eventId)  => 'events/$eventId';
  // Folder structure for user profile pictures
  static String profileImagePath(String userId)  => 'usersProfileImage/$userId';
}