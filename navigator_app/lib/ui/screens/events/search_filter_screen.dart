import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final selectedDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 1000));

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<Event> _searchResults = [];

  final List<String> _categories = [
    'All',
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

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(searchQueryProvider);
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDateRange = ref.watch(selectedDateRangeProvider);
    final priceRange = ref.watch(priceRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Events'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        _performSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                    _performSearch();
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category Filter
                      FilterChip(
                        label: Text(selectedCategory ?? 'Category'),
                        selected: selectedCategory != null,
                        onSelected: (selected) {
                          _showCategoryFilter();
                        },
                        avatar: const Icon(Icons.category),
                      ),
                      const SizedBox(width: 8),
                      
                      // Date Filter
                      FilterChip(
                        label: Text(selectedDateRange != null 
                            ? '${selectedDateRange.start.day}/${selectedDateRange.start.month} - ${selectedDateRange.end.day}/${selectedDateRange.end.month}'
                            : 'Date'),
                        selected: selectedDateRange != null,
                        onSelected: (selected) {
                          _showDateFilter();
                        },
                        avatar: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(width: 8),
                      
                      // Price Filter
                      FilterChip(
                        label: Text(priceRange.start == 0 && priceRange.end == 1000
                            ? 'Price'
                            : '\$${priceRange.start.toInt()} - \$${priceRange.end.toInt()}'),
                        selected: priceRange.start > 0 || priceRange.end < 1000,
                        onSelected: (selected) {
                          _showPriceFilter();
                        },
                        avatar: const Icon(Icons.attach_money),
                      ),
                      const SizedBox(width: 8),
                      
                      // Clear All Filters
                      if (selectedCategory != null || selectedDateRange != null || 
                          priceRange.start > 0 || priceRange.end < 1000)
                        ActionChip(
                          label: const Text('Clear Filters'),
                          avatar: const Icon(Icons.clear_all),
                          onPressed: () {
                            ref.read(selectedCategoryProvider.notifier).state = null;
                            ref.read(selectedDateRangeProvider.notifier).state = null;
                            ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 1000);
                            _performSearch();
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? const Center(child: Text('No events found'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final event = _searchResults[index];
                          return _buildEventCard(context, event);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.push('/event-details/${event.id}');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: event.imageURL.isNotEmpty
                  ? Image.network(
                      event.imageURL,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 48),
                          ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 48),
                    ),
            ),
            
            // Event Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.category, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          event.category,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.address,
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              event.averageRating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Text('(${event.reviewsCount})'),
                          ],
                        ),
                        Text(
                          event.price > 0 ? '\$${event.price.toStringAsFixed(2)}' : 'FREE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: event.price > 0 ? Theme.of(context).primaryColor : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected = ref.read(selectedCategoryProvider) == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      Navigator.pop(context);
                      ref.read(selectedCategoryProvider.notifier).state = 
                          selected ? category : null;
                      _performSearch();
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateFilter() async {
    final initialDateRange = ref.read(selectedDateRangeProvider) ?? 
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 30)),
        );
    
    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDateRange != null) {
      ref.read(selectedDateRangeProvider.notifier).state = pickedDateRange;
      _performSearch();
    }
  }

  void _showPriceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final currentRange = ref.read(priceRangeProvider);
          
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Price',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                RangeSlider(
                  values: currentRange,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  labels: RangeLabels(
                    '\$${currentRange.start.toInt()}',
                    '\$${currentRange.end.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      ref.read(priceRangeProvider.notifier).state = values;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${currentRange.start.toInt()}'),
                    Text('\$${currentRange.end.toInt()}'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _performSearch();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final query = ref.read(searchQueryProvider);
      final category = ref.read(selectedCategoryProvider);
      final dateRange = ref.read(selectedDateRangeProvider);
      final priceRange = ref.read(priceRangeProvider);
      
      // Build search parameters
      final searchParams = <String, dynamic>{};
      
      if (query.isNotEmpty) {
        searchParams['query'] = query;
      }
      
      if (category != null && category != 'All') {
        searchParams['category'] = category;
      }
      
      if (dateRange != null) {
        searchParams['startDate'] = dateRange.start;
        searchParams['endDate'] = dateRange.end;
      }
      
      if (priceRange.start > 0 || priceRange.end < 1000) {
        searchParams['minPrice'] = priceRange.start;
        searchParams['maxPrice'] = priceRange.end;
      }
      
      // Perform search using the event repository
      final results = await ref.read(eventRepositoryProvider).searchEvents();
      
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _searchResults = [];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching events: $e')),
        );
      }
    }
  }
}
