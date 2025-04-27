import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateEditEventScreen extends ConsumerStatefulWidget {
  final String? eventId;

  const CreateEditEventScreen({
    this.eventId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateEditEventScreen> createState() => _CreateEditEventScreenState();
}

class _CreateEditEventScreenState extends ConsumerState<CreateEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _ticketURLController = TextEditingController();
  
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1, hours: 2));
  TimeOfDay _endTime = TimeOfDay.now();
  
  String _selectedCategory = 'Music';
  List<String> _selectedTags = [];
  List<String> _imageURLs = [];
  String _mainImageURL = '';
  
  bool _isLoading = false;
  bool _isEditing = false;
  final List<String> saudiCities = [
    'Riyadh', 'Jeddah', 'Mecca', 'Medina', 'Dammam',
    'Khobar', 'Taif', 'Tabuk', 'Abha', 'Najran',
    'Jubail', 'Yanbu', 'Hail', 'Buraidah', 'Khamis Mushait',
    'Al Bahah', 'Arar', 'Sakaka', 'Jizan', 'Dhahran',
    'Al Khafji', 'Al Qatif', 'Al Hofuf', 'Al Kharj', 'Unaizah'
  ];

  String? selectedCity;
  late GoogleMapController mapController;
  final Map<String, LatLng> cityCoordinates = {
    'Riyadh': const LatLng(24.7136, 46.6753),
    'Jeddah': const LatLng(21.5433, 39.1728),
    'Mecca': const LatLng(21.3891, 39.8579),
    'Medina': const LatLng(24.5247, 39.5692),
    'Dammam': const LatLng(26.3927, 49.9777),
    'Khobar': const LatLng(26.2172, 50.1971),
    'Taif': const LatLng(21.4373, 40.5127),
    'Tabuk': const LatLng(28.3835, 36.5662),
    'Abha': const LatLng(18.2465, 42.5117),
    'Najran': const LatLng(17.5656, 44.2289),
    'Jubail': const LatLng(27.0115, 49.6585),
    'Yanbu': const LatLng(24.0895, 38.0618),
    'Hail': const LatLng(27.5114, 41.7208),
    'Buraidah': const LatLng(26.3362, 43.9632),
    'Khamis Mushait': const LatLng(18.3093, 42.7664),
    'Al Bahah': const LatLng(20.0129, 41.4677),
    'Arar': const LatLng(30.9756, 41.0381),
    'Sakaka': const LatLng(29.9697, 40.2066),
    'Jizan': const LatLng(16.8894, 42.5706),
    'Dhahran': const LatLng(26.2361, 50.0393),
    'Al Khafji': const LatLng(28.4391, 48.4913),
    'Al Qatif': const LatLng(26.5765, 49.9982),
    'Al Hofuf': const LatLng(25.3769, 49.5826),
    'Al Kharj': const LatLng(24.1554, 47.3346),
    'Unaizah': const LatLng(26.0912, 43.9765),
  };

  // Default map type
  MapType _currentMapType = MapType.normal;
  
  // Added for custom location selection
  LatLng? _selectedLocation;
  final _locationTextController = TextEditingController();

  final List<String> _categories = [
    'Music',
    'Sports',
    'Food',
    'Art',
    'Technology',
    'Business',
    'Health',
    'Education',
    'Entertainment',
    'Travel',
  ];
  
  final List<String> _availableTags = [
    'Family Friendly',
    'Outdoor',
    'Indoor',
    'Free',
    'Premium',
    'Workshop',
    'Conference',
    'Concert',
    'Exhibition',
    'Festival',
    'Networking',
    'Party',
    'Seminar',
    'Tour',
    'Virtual',
  ];

  @override
  void initState() {
    super.initState();
    selectedCity = 'Riyadh'; // Set default city
    _selectedLocation = cityCoordinates['Riyadh']; // Initialize selected location
    _updateLocationText(); // Initialize location text
    _isEditing = widget.eventId != null;
    if (_isEditing) {
      _loadEventData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _ticketURLController.dispose();
    _locationTextController.dispose(); // Dispose the new controller
    super.dispose();
  }

  void _loadEventData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final event = await ref.read(eventRepositoryProvider).getEvent(widget.eventId!);
      
      if (event != null) {
        _titleController.text = event.title;
        _descriptionController.text = event.description;
        _addressController.text = event.address;
        _priceController.text = event.price.toString();
        _ticketURLController.text = event.ticketURL;
        
        _startDate = event.startDate;
        _startTime = TimeOfDay.fromDateTime(event.startDate);
        _endDate = event.endDate;
        _endTime = TimeOfDay.fromDateTime(event.endDate);
        
        _selectedCategory = event.category;
        _selectedTags = List<String>.from(event.tags);
        _imageURLs = List<String>.from(event.imageURLs);
        _mainImageURL = event.imageURL;
        
        // Set location if available
        if (event.location != null) {
          _selectedLocation = LatLng(event.location.latitude, event.location.longitude);
          _updateLocationText();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading event: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(authStateChangesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Event' : 'Create Event'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null || user.uid == 'guest') {
            return const Center(child: Text('Please sign in to create events'));
          }
          
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildDateTimeSection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildCategorySection(),
                  const SizedBox(height: 24),
                  _buildTagsSection(),
                  const SizedBox(height: 24),
                  _buildTicketSection(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => _saveEvent(user.uid),
                      child: Text(
                        _isEditing ? 'Update Event' : 'Create Event',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Images',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Add images to showcase your event (main image first)'),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageURLs.length + 1,
            itemBuilder: (context, index) {
              if (index == _imageURLs.length) {
                return _buildAddImageButton();
              }
              
              final imageUrl = _imageURLs[index];
              final isMainImage = index == 0;
              
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 160,
                        height: 120,
                        decoration: BoxDecoration(
                          border: isMainImage
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: Image.network(
                          imageUrl,
                          width: 160,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Container(
                                width: 160,
                                height: 120,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 48),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ),
                  if (isMainImage)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Main',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 160,
        height: 120,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Add Image'),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Event Title',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectStartDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(DateFormat('MMM d, yyyy').format(_startDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectStartTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_startTime.format(context)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectEndDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(DateFormat('MMM d, yyyy').format(_endDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectEndTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_endTime.format(context)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCityDropdown(),
        const SizedBox(height: 16),
        _buildMapPreview(),
        const SizedBox(height: 16),
        // Added location text field
        TextFormField(
          controller: _locationTextController,
          decoration: const InputDecoration(
            labelText: 'Selected Location',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
            hintText: 'Tap on the map to select a location',
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCity,
          hint: const Text('Select a city'),
          isExpanded: true,
          underline: Container(),
          dropdownColor: const Color(0xFFF1F4F8), // Match background color
          style: const TextStyle( // Add this style
            color: Colors.black, // Set text color to black
            fontSize: 14,
          ),
          items: saudiCities.map((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCity = newValue;
              // Update selected location when city changes
              if (newValue != null && cityCoordinates.containsKey(newValue)) {
                _selectedLocation = cityCoordinates[newValue];
                _updateLocationText();
              }
              _updateMapCamera();
            });
          },
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _selectedLocation ?? const LatLng(24.7136, 46.6753),
            zoom: 12,
          ),
          mapType: _currentMapType,
          markers: {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: _selectedLocation ?? const LatLng(24.7136, 46.6753),
              infoWindow: InfoWindow(title: selectedCity ?? 'Selected Location'),
            )
          },
          onMapCreated: (controller) {
            mapController = controller;
          },
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          // Add onTap handler for map
          onTap: (LatLng position) {
            setState(() {
              _selectedLocation = position;
              _updateLocationText();
              
              // Try to find the nearest city for reference
              _findNearestCity(position);
            });
          },
        ),
      ),
    );
  }
  
  // Find the nearest city to the tapped location
  void _findNearestCity(LatLng position) {
    double minDistance = double.infinity;
    String? nearestCity;
    
    cityCoordinates.forEach((city, coordinates) {
      final distance = _calculateDistance(position, coordinates);
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    });
    
    // Update selected city if a nearest one is found
    if (nearestCity != null) {
      setState(() {
        selectedCity = nearestCity;
      });
    }
  }
  
  // Simple distance calculation between two points
  double _calculateDistance(LatLng point1, LatLng point2) {
    final latDiff = point1.latitude - point2.latitude;
    final lngDiff = point1.longitude - point2.longitude;
    return (latDiff * latDiff) + (lngDiff * lngDiff); // Simplified distance formula
  }
  
  // Update the location text field
  void _updateLocationText() {
    if (_selectedLocation != null) {
      _locationTextController.text = 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
          'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}';
    } else {
      _locationTextController.text = '';
    }
  }
  
  void _updateMapCamera() {
    if (selectedCity != null && mapController != null) {
      final target = cityCoordinates[selectedCity] ?? const LatLng(24.7136, 46.6753);
      mapController.animateCamera(
        CameraUpdate.newLatLng(target),
      );
      
      // Update selected location
      setState(() {
        _selectedLocation = target;
        _updateLocationText();
      });
    }
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(),
          ),
          value: _selectedCategory,
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Select tags that describe your event'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTicketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price (USD)',
            border: OutlineInputBorder(),
            prefixText: '\$',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price (0 for free events)';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ticketURLController,
          decoration: const InputDecoration(
            labelText: 'Ticket URL (optional)',
            border: OutlineInputBorder(),
            hintText: 'https://',
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final File imageFile = File(image.path);
        final String fileName = 'events/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        
        final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        final UploadTask uploadTask = storageRef.putFile(imageFile);
        
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        
        setState(() {
          _imageURLs.add(downloadUrl);
          if (_imageURLs.length == 1) {
            _mainImageURL = downloadUrl;
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageURLs.removeAt(index);
      if (_imageURLs.isNotEmpty && index == 0) {
        _mainImageURL = _imageURLs[0];
      } else if (_imageURLs.isEmpty) {
        _mainImageURL = '';
      }
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(hours: 2));
        }
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        
        // If start and end dates are the same, ensure end time is after start time
        if (_startDate.year == _endDate.year && 
            _startDate.month == _endDate.month && 
            _startDate.day == _endDate.day) {
          final startTimeMinutes = _startTime.hour * 60 + _startTime.minute;
          final endTimeMinutes = _endTime.hour * 60 + _endTime.minute;
          
          if (endTimeMinutes <= startTimeMinutes) {
            _endTime = TimeOfDay(
              hour: (_startTime.hour + 2) % 24,
              minute: _startTime.minute,
            );
          }
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _saveEvent(String userId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_imageURLs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      
      final endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );
      
      final event = Event(
        id: _isEditing ? widget.eventId! : '',
        title: _titleController.text,
        description: _descriptionController.text,
        location: GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
        address: _addressController.text,
        startDate: startDateTime,
        endDate: endDateTime,
        category: _selectedCategory,
        tags: _selectedTags,
        price: double.tryParse(_priceController.text) ?? 0,
        ticketURL: _ticketURLController.text,
        imageURL: _mainImageURL,
        imageURLs: _imageURLs,
        creatorID: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        averageRating: 0,
        reviewsCount: 0,
      );
      
      if (_isEditing) {
        await ref.read(eventRepositoryProvider).saveEvent(event);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully')),
        );
      } else {
        await ref.read(eventRepositoryProvider).saveEvent(event);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
      }
      
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteEvent() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await ref.read(eventRepositoryProvider).deleteEvent(widget.eventId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
      
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
