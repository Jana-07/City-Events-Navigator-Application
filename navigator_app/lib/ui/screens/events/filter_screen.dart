import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/category_data.dart';
import 'package:navigator_app/data/models/saudi_city.dart';
import 'package:navigator_app/providers/filter_provider.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  Set<String> _selectedCategories = {};
  String? _selectedDate;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCity;
  RangeValues _priceRange = const RangeValues(0, 50);

  // Map the UI selections to filter values used by the EventsController
  //String _getCategoryFilter() {
  // You can customize this mapping based on your needs
  // switch (_selectedCategory) {
  //   case 'Sports':
  //     return 'sports';
  //   case 'Festivals':
  //     return 'festivals';
  //   case 'Art':
  //     return 'art';
  //   case 'Conference':
  //     return 'conference';
  //   case 'Food':
  //     return 'food';
  //   default:
  //     return 'all';
  // }
  //}

  String _getDateFilter() {
    // Map UI date selection to filter values
    switch (_selectedDate) {
      case 'Today':
        return 'today';
      case 'Tomorrow':
        return 'tomorrow';
      case 'This week':
        return 'this_week';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Filters',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            context.pop(); // Pop without result
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Filter',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  _buildCategorySelector(),
                  const SizedBox(height: 24),
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildLocationSelector(),
                  const SizedBox(height: 24),
                  //_buildPriceRangeSelector(),
                  const Spacer(),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.all(6.0),
              child: _buildCategoryButton(category.name, category.icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    final isSelected = _selectedCategories.contains(category);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(category);
          } else {
            _selectedCategories.add(category);
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time & Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateButton('Today',
                  isSelected: _selectedDate == 'Today'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateButton('Tomorrow',
                  isSelected: _selectedDate == 'Tomorrow'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateButton('This week',
                  isSelected: _selectedDate == 'This week'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCalendarButton(),
      ],
    );
  }

  Widget _buildDateButton(String text, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!isSelected) {
            _selectedDate = text;
            DateTime now = DateTime.now();
            DateTime todayStart = _startOfDay(now);
            DateTime todayEnd = _endOfDay(now);

            switch (_selectedDate) {
              case 'Today':
                _startDate = todayStart;
                _endDate = todayEnd;
              case 'Tomorrow':
                DateTime tomorrow = now.add(const Duration(days: 1));
                _startDate = _startOfDay(tomorrow);
                _endDate = _endOfDay(tomorrow);
              case 'This week':
                int currentWeekday = now.weekday; // Monday = 1, Sunday = 7
                int daysFromSunday = currentWeekday % 7; // Sunday = 0
                _startDate =
                    _startOfDay(now.subtract(Duration(days: daysFromSunday)));
                _endDate = _endOfDay(_startDate!.add(const Duration(days: 6)));
            }
          } else {
            _selectedDate = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateRangeFromVars(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'Choose date range'; // Placeholder text
    }
    // Format the start and end dates (e.g., YYYY-MM-DD)
    final startDateStr = start.toLocal().toString().split(' ')[0];
    final endDateStr = end.toLocal().toString().split(' ')[0];
    return '$startDateStr - $endDateStr'; // Display the selected range
  }

  Widget _buildCalendarButton() {
    return GestureDetector(
      onTap: () async {
        // Determine the initial range for the picker
        DateTimeRange initialRange = DateTimeRange(
          start: _startDate ?? DateTime.now(),
          end: _endDate ?? DateTime.now().add(const Duration(days: 7)),
        );
        // Ensure start is not after end for the initial range
        if (initialRange.start.isAfter(initialRange.end)) {
          initialRange = DateTimeRange(
            start: initialRange.start,
            end: initialRange.start
                .add(const Duration(days: 1)), // Adjust end if invalid
          );
        }

        final DateTimeRange? picked = await showDateRangePicker(
          context: context, // Make sure context is available
          initialDateRange: initialRange,
          firstDate: DateTime(2020), // Adjust as needed
          lastDate: DateTime.now()
              .add(const Duration(days: 365 * 5)), // Adjust as needed
          helpText: 'Events In Date Range',
          saveText: 'Done',
        );

        // Check if a range was picked
        if (picked != null) {
          setState(() {
            _selectedDate = null;
          });
          // Check if the picked range is different from the current one
          if (picked.start != _startDate || picked.end != _endDate) {
            setState(() {
              // Make sure setState is available
              _startDate = picked.start;
              _endDate = picked.end;
              // Now _startDate and _endDate hold the selected dates
              print('Selected Start Date: $_startDate');
              print('Selected End Date: $_endDate');
            });
          }
        }
      },
      // This part keeps the visual structure of your original button
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                // Use the helper function that reads from _startDate and _endDate
                _formatDateRangeFromVars(_startDate, _endDate),
                style: TextStyle(
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'City',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            String? tempSelectedCity = _selectedCity;

            final result = await showDialog<String>(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  title: const Text('Select City'),
                  content: SizedBox(
                    height: 400,
                    width: double.maxFinite,
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: saudiCities.length,
                        itemBuilder: (context, index) {
                          final city = saudiCities[index];
                          return RadioListTile<String>(
                            title: Text(city.name),
                            value: city.name,
                            groupValue: tempSelectedCity,
                            onChanged: (value) {
                              setState(() {
                                tempSelectedCity = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(tempSelectedCity),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );

            if (result != null) {
              setState(() {
                _selectedCity = result;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.location_on, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Text(
                  _selectedCity ?? 'Select City',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select price range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${_priceRange.start.toInt()}-\$${_priceRange.end.toInt()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  7,
                  (index) => Container(
                    width: 4,
                    height: index % 2 == 0 ? 16 : 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.white,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
              ),
              child: RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200,
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Reset filters
              setState(() {
                _selectedCategories = {};
                _selectedDate = null;
                _selectedCity = null;
                _priceRange = const RangeValues(0, 100);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: const Text(
              'RESET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_selectedDate != null) {
                DateTime now = DateTime.now();
                DateTime todayStart = _startOfDay(now);
                DateTime todayEnd = _endOfDay(now);

                switch (_selectedDate) {
                  case 'Today':
                    _startDate = todayStart;
                    _endDate = todayEnd;
                  case 'Tomorrow':
                    DateTime tomorrow = now.add(const Duration(days: 1));
                    _startDate = _startOfDay(tomorrow);
                    _endDate = _endOfDay(tomorrow);
                  case 'This Week':
                    int currentWeekday = now.weekday; // Monday = 1, Sunday = 7
                    _startDate = _startOfDay(
                        now.subtract(Duration(days: currentWeekday - 1)));
                    _endDate =
                        _endOfDay(_startDate!.add(const Duration(days: 6)));
                }
              }
              final newFilter = EventFilter(
                categories: _selectedCategories.isEmpty
                    ? null
                    : List.from(_selectedCategories),
                city: _selectedCity,
                //maxPrice: _priceRange.end,
                //minPrice: _priceRange.start,
                startDate: _startDate,
                endDate: _endDate,
              );
              ref.read(eventFiltersProvider('all').notifier).applyFilters(newFilter);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'APPLY',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
