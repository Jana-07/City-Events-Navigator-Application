import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/router/routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Map<String, dynamic>> _events = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String _selectedCategory = '';
  Map<String, dynamic>? _selectedEvent;
  Future<void> fetchEventsFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tappedLocations')
        .orderBy('timestamp', descending: true)
        .get();

    // Clear the list before adding new data to avoid duplication
    _events.clear();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      _events.add({
        'id': doc.id,
        'category': data['category'] ?? 'Unknown',
        'position': LatLng(data['latitude'], data['longitude']),
        'name': data['name'] ?? 'Unknown',
        'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
        'description': data['description'] ?? 'Unknown',
        'isFavorite': data['isFavorite'] ?? 'false',
      });
    }
    setState(() {
      _markers.clear();
      _initMarkers(); // properly update markers after fetching
    });
  }

  @override
  void initState() {
    super.initState();

    fetchEventsFromFirebase();
  }

  void _initMarkers() {
    Set<Marker> newMarkers = {};

    for (var event in _events) {
      final category = event['category'];
      final icon = [category] ?? BitmapDescriptor.defaultMarker;

      newMarkers.add(
        Marker(
          markerId: MarkerId(event['id']),
          position: event['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getCategoryHue(event['category']),
          ),
          onTap: () {
            debugPrint("Tapped on event: ${event['category']}");
          },
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  double _getCategoryHue(String category) {
    switch (category) {
      case 'Sports':
        return BitmapDescriptor.hueRed;
      case 'Festivals':
        return BitmapDescriptor.hueViolet;
      case 'Food':
        return BitmapDescriptor.hueGreen;
      case 'Art':
        return BitmapDescriptor.hueOrange;
      case 'Conference':
        return BitmapDescriptor.hueAzure;
      case 'Education':
        return BitmapDescriptor.hueGreen;
      case 'Others':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueRose;
    }
  }

  void _filterMarkers(String category) {
    setState(() {
      _selectedCategory = (_selectedCategory == category) ? '' : category;
      _markers.clear();
      for (var event in _events) {
        if (_selectedCategory.isEmpty ||
            event['category'] == _selectedCategory) {
          _markers.add(
            Marker(
              markerId: MarkerId(event['id']),
              position: event['position'],
              icon: BitmapDescriptor.defaultMarkerWithHue(
                _getCategoryHue(event['category']),
              ),
              onTap: () {
                debugPrint("Tapped on event: ${event['name']}");
              },
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.3292, 43.9818), // Initial center position.
              zoom: 14,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            onTap: (LatLng tappedPoint) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add New Event'),
                    content: Text(
                        'Do you want to add a new event in this location?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.pushNamed(Routes.createEventName);
                        },
                        child: const Text('Create Event'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Search bar
          SafeArea(
            minimum: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onSubmitted: (value) {
                            // Handle search
                          },
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.my_location, color: Colors.green),
                        onPressed: () {
                          // Center map on user location
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        icon: Icons.sports_basketball,
                        label: 'Sports',
                        color: Colors.red,
                        isSelected: _selectedCategory == 'Sports',
                        onTap: () => _filterMarkers('Sports'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.music_note,
                        label: 'Festivals',
                        color: Colors.purple,
                        isSelected: _selectedCategory == 'Festivals',
                        onTap: () => _filterMarkers('Festivals'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.restaurant,
                        label: 'Food',
                        color: Colors.green,
                        isSelected: _selectedCategory == 'Food',
                        onTap: () => _filterMarkers('Food'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.palette,
                        label: 'Art',
                        color: Colors.orange,
                        isSelected: _selectedCategory == 'Art',
                        onTap: () => _filterMarkers('Art'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.people,
                        label: 'Conference',
                        color: Colors.blue,
                        isSelected: _selectedCategory == 'Conference',
                        onTap: () => _filterMarkers('Conference'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.school,
                        label: 'Education',
                        color: Colors.green,
                        isSelected: _selectedCategory == 'Education',
                        onTap: () => _filterMarkers('Education'),
                      ),
                      const SizedBox(width: 10),
                      CategoryChip(
                        icon: Icons.more_horiz,
                        label: 'Others',
                        color: Colors.red,
                        isSelected: _selectedCategory == 'Others',
                        onTap: () => _filterMarkers('Others'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Event card at bottom - only show when an event is selected
          if (_selectedEvent != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: EventDetailsCard(
                event: _selectedEvent!,
                isPreview: true,
                onClose: () {
                  setState(() {
                    _selectedEvent = null;
                  });
                },
              ),
            ),

          if (_selectedCategory.isNotEmpty)
            Positioned(
              bottom: _selectedEvent != null ? 140 : 20,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _events
                      .where((e) => e['category'] == _selectedCategory)
                      .length,
                  itemBuilder: (context, index) {
                    final filteredEvents = _events
                        .where((e) => e['category'] == _selectedCategory)
                        .toList();
                    final event = filteredEvents[index];
                    final DateTime? timestamp = event['timestamp'];
                    final formattedDate = timestamp != null
                        ? DateFormat('MMM dd, yyyy - h:mm a').format(timestamp)
                        : 'No Date';

                    return Stack(
                      children: [
                        // Main event card
                        Container(
                          width: 310,
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$formattedDate',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event['name'] ?? 'No Name'}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  Text(
                                    '${event['description'] ?? 'No Description'}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Spacer(),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     _mapController?.animateCamera(
                              //       CameraUpdate.newLatLng(event['position']),
                              //     );
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Colors.green,
                              //     padding: const EdgeInsets.symmetric(horizontal: 20),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //   ),
                              //   child: const Text(
                              //     'View on Map',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        // ❤️ Heart Icon (top right)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () async {
                              final docId = event['id'];
                              final isFavorite = event['isFavorite'] ?? false;

                              try {
                                await FirebaseFirestore.instance
                                    .collection('tappedLocations')
                                    .doc(docId)
                                    .update({'isFavorite': !isFavorite});

                                // Update local list too for instant UI update
                                setState(() {
                                  final index = _events
                                      .indexWhere((e) => e['id'] == docId);
                                  if (index != -1) {
                                    _events[index]['isFavorite'] = !isFavorite;
                                  }
                                });
                              } catch (e) {
                                print("Error updating favorite: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Failed to update favorite status")),
                                );
                              }
                            },
                            child: Icon(
                              (event['isFavorite'] ?? false)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    setState(() {
      _selectedEvent = event;
    });
  }
}

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isPreview;
  final VoidCallback? onClose;

  const EventDetailsCard({
    super.key,
    required this.event,
    this.isPreview = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('E, MMM d • h:mm a');
    final formattedDate = dateFormat.format(event['date']);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Event image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    event['image'] ?? 'assets/images/placeholder.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['title'] ?? 'Event',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event['location'] ?? 'Location not specified',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Favorite button
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.green),
                  onPressed: () {
                    // Toggle favorite
                  },
                ),
                // Close button if provided
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
              ],
            ),
          ),
          if (!isPreview)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to event details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
