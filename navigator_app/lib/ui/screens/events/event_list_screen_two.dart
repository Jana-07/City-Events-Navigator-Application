import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/widgets/events/events_list.dart';
import 'package:navigator_app/ui/widgets/events/filteres_button.dart';

// Provider to store the current filter state
final currentFilterProvider = StateProvider<String>((ref) => 'all');
final currentSortByProvider = StateProvider<String>((ref) => 'date');

class EventListScreenTwo extends ConsumerStatefulWidget {
  const EventListScreenTwo({
    super.key, 
    required this.title, 
    this.initialFilter = 'all',
    this.initialSortBy = 'date',
  });

  final String title;
  final String initialFilter;
  final String initialSortBy;

  @override
  ConsumerState<EventListScreenTwo> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreenTwo> {
  late String _currentFilter;
  late String _currentSortBy;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _currentSortBy = widget.initialSortBy;
    
    // Initialize the providers with the initial values
    Future.microtask(() {
      ref.read(currentFilterProvider.notifier).state = _currentFilter;
      ref.read(currentSortByProvider.notifier).state = _currentSortBy;
    });
  }

  void _openFilterScreen() async {
    // Navigate to the filter screen and wait for result
    final result = await context.push(Routes.filters);
    
    // If result is not null, update the filter
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result.containsKey('filter')) {
          _currentFilter = result['filter'];
          ref.read(currentFilterProvider.notifier).state = _currentFilter;
        }
        
        if (result.containsKey('sortBy')) {
          _currentSortBy = result['sortBy'];
          ref.read(currentSortByProvider.notifier).state = _currentSortBy;
        }
      });
    }
  }

  void _updateFilter(String newFilter) {
    setState(() {
      _currentFilter = newFilter;
      ref.read(currentFilterProvider.notifier).state = newFilter;
    });
  }

  void _updateSortBy(String newSortBy) {
    setState(() {
      _currentSortBy = newSortBy;
      ref.read(currentSortByProvider.notifier).state = newSortBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Watch the filter providers to rebuild when they change
    final filter = ref.watch(currentFilterProvider);
    final sortBy = ref.watch(currentSortByProvider);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            context.pop();
          }
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                _buildSortDropdown(),
                Spacer(),
                _buildFilterButton(),
              ],
            ),
          ),
          _buildFilterChips(),
          Flexible(
            child: EventsList(
              filter: filter,
              sortBy: sortBy,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _currentSortBy,
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _updateSortBy(newValue);
        }
      },
      hint: Text('Sort by'),
      style: Theme.of(context).textTheme.bodyMedium,
      items: <String>['date', 'rating', 'name']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text((value.capitalize()),),
        );
      }).toList(),
    );
  }

  Widget _buildFilterButton() {
    return FiltersButtonTwo(
      onPressed: _openFilterScreen,
    );
  }

  Widget _buildFilterChips() {
    final theme = Theme.of(context);
    // List of available filters
    final filters = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Upcoming', 'value': 'upcoming'},
      {'label': 'Past', 'value': 'past'},
      {'label': 'Popular', 'value': 'popular'},
      {'label': 'Favorites', 'value': 'favorite'},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _currentFilter == filter['value'];
          
          return FilterChip(
            label: Text(filter['label']!),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                _updateFilter(filter['value']!);
              }
            },
            backgroundColor: Colors.grey[200],
            selectedColor: theme.primaryColor.withOpacity(0.2),
            checkmarkColor: theme.primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? theme.primaryColor : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
