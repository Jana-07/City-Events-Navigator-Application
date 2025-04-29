import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/data/models/event.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:navigator_app/ui/controllers/event_controller.dart';

class MapScreenTwo extends ConsumerStatefulWidget {
  const MapScreenTwo({super.key});

  @override
  ConsumerState<MapScreenTwo> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreenTwo> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String _selectedCategory = '';
  Event? _selectedEvent;
  final Map<String, BitmapDescriptor> _categoryIcons = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryIcons();
  }

  // Load custom icons for each category
  Future<void> _loadCategoryIcons() async {
    setState(() {
      _isLoading = true;
    });

    // Define the categories and their corresponding icons
    final Map<String, IconData> categoryIconMap = {
      'Sports': Icons.sports_basketball,
      'Festivals': Icons.music_note,
      'Food': Icons.restaurant,
      'Art': Icons.palette,
      'Conference': Icons.people,
      'Education': Icons.school,
      'Others': Icons.more_horiz,
    };

    // Create custom bitmap descriptors for each category
    for (var entry in categoryIconMap.entries) {
      final BitmapDescriptor icon = await _createCustomMarkerBitmap(
        entry.value,
        _getCategoryColor(entry.key),
      );
      _categoryIcons[entry.key] = icon;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Create custom marker bitmap from icon
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      IconData iconData, Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = const Size(48, 48);
    final radius = 24.0;
    final textPainter = TextPainter();

    // Draw circle background
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius - 1, borderPaint);

    // Draw icon
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 24,
        fontFamily: iconData.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );

    // Convert to image
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Sports':
        return Colors.red;
      case 'Festivals':
        return Colors.purple;
      case 'Food':
        return Colors.green;
      case 'Art':
        return Colors.orange;
      case 'Conference':
        return Colors.blue;
      case 'Education':
        return Colors.teal;
      case 'Others':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  void _initMarkers(List<Event> events) {
    Set<Marker> newMarkers = {};

    for (var event in events) {
      // Skip events without valid location data
      if (event.location.latitude == 0 && event.location.longitude == 0) {
        continue;
      }

      final category = event.category;
      final BitmapDescriptor icon = _categoryIcons[category] ??
          BitmapDescriptor.defaultMarkerWithHue(_getCategoryHue(category));

      newMarkers.add(
        Marker(
          markerId: MarkerId(event.id),
          position: LatLng(event.location.latitude, event.location.longitude),
          icon: icon,
          onTap: () {
            setState(() {
              _selectedEvent = event;
            });

            // Center the map on the selected event
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(event.location.latitude, event.location.longitude),
              ),
            );
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

      // Get events from the controller
      final eventsAsync =
          ref.read(eventsControllerProvider(filter: 'all', sortBy: 'date'));

      eventsAsync.whenData((events) {
        _markers.clear();
        for (var event in events) {
          // Skip events without valid location data
          if (event.location.latitude == 0 && event.location.longitude == 0) {
            continue;
          }

          if (_selectedCategory.isEmpty ||
              event.category == _selectedCategory) {
            final BitmapDescriptor icon = _categoryIcons[event.category] ??
                BitmapDescriptor.defaultMarkerWithHue(
                    _getCategoryHue(event.category));

            _markers.add(
              Marker(
                markerId: MarkerId(event.id),
                position:
                    LatLng(event.location.latitude, event.location.longitude),
                icon: icon,
                onTap: () {
                  setState(() {
                    _selectedEvent = event;
                  });

                  // Center the map on the selected event
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(event.location.latitude, event.location.longitude),
                    ),
                  );
                },
              ),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch events from the controller
    final eventsAsync =
        ref.watch(eventsControllerProvider(filter: 'all', sortBy: 'date'));

    // Update markers when events change
    eventsAsync.whenData((events) {
      if (!_isLoading && _categoryIcons.isNotEmpty) {
        _initMarkers(events);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Show loading indicator while custom icons are being loaded
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(26.3609, 43.975), // Initial center position
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
                          context.pushNamed(
                            Routes.createEventName,
                            extra: tappedPoint,
                          );
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
              child: EventCard(
                event: _selectedEvent!,
                onClose: () {
                  setState(() {
                    _selectedEvent = null;
                  });
                },
              ),
            ),

          // Event list when category is selected
          if (_selectedCategory.isNotEmpty)
            eventsAsync.when(
              data: (events) {
                final filteredEvents = events
                    .where((e) => e.category == _selectedCategory)
                    .toList();

                return Positioned(
                  bottom: _selectedEvent != null ? 140 : 20,
                  left: 20,
                  right: 20,
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        final formattedDate =
                            DateFormat('MMM dd, yyyy - h:mm a')
                                .format(event.startDate);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedEvent = event;
                            });

                            // Center the map on the selected event
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLng(
                                LatLng(event.location.latitude,
                                    event.location.longitude),
                              ),
                            );
                          },
                          child: Container(
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
                                  formattedDate,
                                  style: TextStyle(
                                      color: Colors.indigo, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined),
                                    Expanded(
                                      child: Text(
                                        event.address,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onClose;

  const EventCard({
    super.key,
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy - h:mm a').format(event.startDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.address,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(event.category),
                backgroundColor: Colors.blue.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.blue),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to event details
                  context.pushNamed(
                    Routes.eventDetailsName,
                    pathParameters: {'id': event.id},
                  );
                },
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
