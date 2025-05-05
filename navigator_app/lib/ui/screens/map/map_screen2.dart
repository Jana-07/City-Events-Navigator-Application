import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/data/repositories/event_repository.dart'; // Assuming this exists
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart'; // Assuming this contains getEventByIdProvider
import 'package:navigator_app/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/data/models/event.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:navigator_app/ui/controllers/event_controller.dart';

class MapScreenTwo extends ConsumerStatefulWidget {
  const MapScreenTwo({
    super.key,
    this.eventId = '',
  });
  final String? eventId;

  @override
  ConsumerState<MapScreenTwo> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreenTwo> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String _selectedCategory = '';
  Event? _selectedEvent;
  final Map<String, BitmapDescriptor> _categoryIcons = {};
  bool _isLoading = true; // Used for loading icons
  bool _isFetchingEvent = false; // Used specifically for fetching event by ID

  @override
  void initState() {
    super.initState();
    _loadCategoryIcons().then((_) {
      // After icons are loaded (or attempted), check for eventId
      if (widget.eventId != null && widget.eventId!.isNotEmpty) {
        // Use addPostFrameCallback to ensure the first frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            // Check if the widget is still mounted
            _fetchAndSelectEventById(widget.eventId!);
          }
        });
      }
    });
  }

  // Load custom icons for each category
  Future<void> _loadCategoryIcons() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, IconData> categoryIconMap = {
      'Sport': Icons.sports_basketball,
      'Festival': Icons.music_note,
      'Food': Icons.restaurant,
      'Art': Icons.palette,
      'Conference': Icons.people,
      'Education': Icons.school,
      'Other': Icons.more_horiz,
    };

    try {
      for (var entry in categoryIconMap.entries) {
        final BitmapDescriptor icon = await _createCustomMarkerBitmap(
          entry.value,
          _getCategoryColor(entry.key),
        );
        _categoryIcons[entry.key] = icon;
      }
    } catch (e) {
      print("Error loading category icons: $e");
      // Handle icon loading error if necessary
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch and select event by ID
  Future<void> _fetchAndSelectEventById(String eventId) async {
    if (!mounted) return; // Don't proceed if widget is disposed
    setState(() {
      _isFetchingEvent = true; // Indicate loading specific event
    });

    try {
      final event = await ref.read(getEventByIdProvider(eventId).future);

      if (mounted) {
        // Check again if mounted after await
        setState(() {
          _selectedEvent = event;
          _isFetchingEvent = false;

          // Center the map on the selected event if location is valid
          if (event != null) {
            if (_mapController != null &&
                event.location.latitude != 0 &&
                event.location.longitude != 0) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(event.location.latitude, event.location.longitude),
                  15, // Zoom level can be adjusted
                ),
              );
            }
          }
        });
      }
    } catch (e) {
      print("Error fetching event by ID '$eventId': $e");
      if (mounted) {
        setState(() {
          _isFetchingEvent = false;
        });
        // Optionally show an error message to the user (e.g., using a SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load event details.')),
        );
      }
    }
  }

  // Create custom marker bitmap from icon
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      IconData iconData, Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = const Size(80, 80);
    final radius = 35.0; // Slightly smaller radius
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

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
        Offset(size.width / 2, size.height / 2), radius, borderPaint);

    // Draw icon
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 35, // Adjust icon size
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
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

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to create bitmap descriptor");
    }
    final buffer = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  Color _getCategoryColor(String category) {
    // Ensure consistent category key usage (e.g., 'Sport' vs 'Sports')
    switch (category) {
      case 'Sport':
        return Colors.red;
      case 'Festival':
        return Colors.purple;
      case 'Food':
        return Colors.green;
      case 'Art':
        return Colors.orange;
      case 'Conference':
        return Colors.blue;
      case 'Education':
        return Colors.teal;
      case 'Other':
        return Colors.grey;
      default:
        return Colors.red; // Default color
    }
  }

  void _initMarkers(List<Event> events) {
    if (!mounted || _categoryIcons.isEmpty)
      return; // Don't run if disposed or icons not ready

    Set<Marker> newMarkers = {};
    Event? eventToPotentiallySelect;

    for (var event in events) {
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
            if (mounted) {
              setState(() {
                _selectedEvent = event;
              });
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(event.location.latitude, event.location.longitude),
                ),
              );
            }
          },
        ),
      );

      // Check if this event matches the initial eventId and we haven't selected it yet
      if (widget.eventId == event.id &&
          _selectedEvent == null &&
          !_isFetchingEvent) {
        eventToPotentiallySelect = event;
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        // If an event matching eventId was found in the list and not yet selected,
        // select it now. This handles cases where the event is already in the 'all' list.
        if (eventToPotentiallySelect != null) {
          _selectedEvent = eventToPotentiallySelect;
          // Optionally center map if needed and not already done by fetch logic
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(eventToPotentiallySelect.location.latitude,
                    eventToPotentiallySelect.location.longitude),
                15,
              ),
            );
          }
        }
      });
    }
  }

  // Get default hue (fallback if custom icon fails)
  double _getCategoryHue(String category) {
    switch (category) {
      case 'Sport':
        return BitmapDescriptor.hueRed;
      case 'Festival':
        return BitmapDescriptor.hueViolet;
      case 'Food':
        return BitmapDescriptor.hueGreen;
      case 'Art':
        return BitmapDescriptor.hueOrange;
      case 'Conference':
        return BitmapDescriptor.hueAzure;
      case 'Education':
        return BitmapDescriptor.hueCyan; // Changed from green for distinction
      case 'Other':
        return BitmapDescriptor.hueMagenta;
      default:
        return BitmapDescriptor.hueRose;
    }
  }

  void _filterMarkers(String category) {
    if (!mounted) return;

    setState(() {
      _selectedCategory = (_selectedCategory == category) ? '' : category;
      _selectedEvent = null; // Clear selection when changing filter

      final eventsAsync = ref.read(eventsControllerProvider('all'));

      eventsAsync.whenData((events) {
        if (!mounted || _categoryIcons.isEmpty) return;

        Set<Marker> filteredMarkers = {};
        for (var event in events) {
          if (event.location.latitude == 0 && event.location.longitude == 0) {
            continue;
          }

          if (_selectedCategory.isEmpty ||
              event.category == _selectedCategory) {
            final BitmapDescriptor icon = _categoryIcons[event.category] ??
                BitmapDescriptor.defaultMarkerWithHue(
                    _getCategoryHue(event.category));

            filteredMarkers.add(
              Marker(
                markerId: MarkerId(event.id),
                position:
                    LatLng(event.location.latitude, event.location.longitude),
                icon: icon,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _selectedEvent = event;
                    });
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                            event.location.latitude, event.location.longitude),
                      ),
                    );
                  }
                },
              ),
            );
          }
        }
        // Update markers directly within whenData callback if possible,
        // or schedule update after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _markers = filteredMarkers;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the list of all events to populate markers initially
    final eventsAsync = ref.watch(eventsControllerProvider('all'));

    // Update markers when the full event list changes (and icons are ready)
    ref.listen<AsyncValue<List<Event>>>(eventsControllerProvider('all'),
        (_, next) {
      next.whenData((events) {
        if (!_isLoading && _categoryIcons.isNotEmpty) {
          _initMarkers(events);
        }
      });
    });

    // Removed the problematic block that was here:
    // if (widget.eventId != null && widget.eventId!.isNotEmpty) { ... }

    return Scaffold(
      body: Stack(
        children: [
          // Show loading indicator while icons are loading OR specific event is fetching
          if (_isLoading || _isFetchingEvent)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Map - Show only when icons are loaded and not fetching specific event
          if (!_isLoading && !_isFetchingEvent)
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                    26.3609, 43.975), // TODO: Adjust initial center if needed
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                if (mounted) {
                  setState(() {
                    _mapController = controller;
                  });
                  // If an event was selected during init, ensure map centers on it
                  if (_selectedEvent != null &&
                      _selectedEvent!.location.latitude != 0) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(_selectedEvent!.location.latitude,
                            _selectedEvent!.location.longitude),
                        15,
                      ),
                    );
                  }
                }
              },
              onTap: (LatLng tappedPoint) {
                if (_selectedEvent != null) {
                  // If an event card is shown, tapping map closes it
                  setState(() {
                    _selectedEvent = null;
                  });
                } else {
                  // Otherwise, allow creating a new event
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
                }
              },
            ),

          // UI Elements (Search, Chips) - Positioned above the map
          SafeArea(
            minimum: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Search Bar Container
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
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          // onSubmitted: (value) { // TODO: Implement search },
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.my_location, color: Colors.green),
                        onPressed: () {
                          // TODO: Implement centering map on user location
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Category Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Example Chip (Repeat for all categories)
                      CategoryChip(
                        icon: Icons.sports_basketball,
                        label: 'Sport',
                        color: _getCategoryColor('Sport'),
                        isSelected: _selectedCategory == 'Sport',
                        onTap: () => _filterMarkers('Sport'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.music_note,
                        label: 'Festival',
                        color: _getCategoryColor('Festival'),
                        isSelected: _selectedCategory == 'Festival',
                        onTap: () => _filterMarkers('Festival'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.restaurant,
                        label: 'Food',
                        color: _getCategoryColor('Food'),
                        isSelected: _selectedCategory == 'Food',
                        onTap: () => _filterMarkers('Food'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.palette,
                        label:
                            'Art', // Label matches key used in map/color func
                        color: _getCategoryColor('Art'),
                        isSelected: _selectedCategory == 'Art',
                        onTap: () => _filterMarkers('Art'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.people,
                        label: 'Conference',
                        color: _getCategoryColor('Conference'),
                        isSelected: _selectedCategory == 'Conference',
                        onTap: () => _filterMarkers('Conference'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.school,
                        label: 'Education',
                        color: _getCategoryColor('Education'),
                        isSelected: _selectedCategory == 'Education',
                        onTap: () => _filterMarkers('Education'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        icon: Icons.more_horiz,
                        label:
                            'Other', // Label matches key used in map/color func
                        color: _getCategoryColor('Other'),
                        isSelected: _selectedCategory == 'Other',
                        onTap: () => _filterMarkers('Other'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Event card at bottom - show when an event is selected
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

          // Event list when category is selected (Optional - keep or remove based on UX)
          // This might conflict with the single selected event card, review UX.
          if (_selectedCategory.isNotEmpty &&
              _selectedEvent ==
                  null) // Only show if no specific event is selected
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
                            height: 120,
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
                                  overflow: TextOverflow.ellipsis,
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

// Helper Widget for Category Chips
class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : color,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for Event Card (Assuming structure)
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
                    pathParameters: {'eventId': event.id},
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