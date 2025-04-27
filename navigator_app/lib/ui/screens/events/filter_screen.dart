import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedCategory = 'Sports';
  String _selectedDate = 'Tomorrow';
  String _selectedLocation = 'New York, USA';
  RangeValues _priceRange = const RangeValues(20, 120);

  // Map the UI selections to filter values used by the EventsController
  String _getCategoryFilter() {
    // You can customize this mapping based on your needs
    switch (_selectedCategory) {
      case 'Sports':
        return 'sports';
      case 'Festivals':
        return 'festivals';
      case 'Art':
        return 'art';
      case 'Conference':
        return 'conference';
      case 'Food':
        return 'food';
      default:
        return 'all';
    }
  }

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
          'Event Booking App- EventHub',
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
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCategorySelector(),
                  const SizedBox(height: 24),
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildLocationSelector(),
                  const SizedBox(height: 24),
                  _buildPriceRangeSelector(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryButton('Sports', Icons.sports_basketball, Colors.green),
            _buildCategoryButton('Festivals', Icons.music_note, Colors.grey),
            _buildCategoryButton('Art', Icons.palette, Colors.green),
            _buildCategoryButton('Conference', Icons.people, Colors.grey),
            _buildCategoryButton('Food', Icons.restaurant, Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String category, IconData icon, Color color) {
    final isSelected = _selectedCategory == category;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[200],
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
              child: _buildDateButton('Today', isSelected: _selectedDate == 'Today'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateButton('Tomorrow', isSelected: _selectedDate == 'Tomorrow'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateButton('This week', isSelected: _selectedDate == 'This week'),
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
          _selectedDate = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
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

  Widget _buildCalendarButton() {
    return GestureDetector(
      onTap: () {
        // Show calendar picker
      },
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
            Text(
              'Choose from calender',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
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
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // Show location picker
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
                  _selectedLocation,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Reset filters
              setState(() {
                _selectedCategory = 'Sports';
                _selectedDate = 'Tomorrow';
                _selectedLocation = 'New York, USA';
                _priceRange = const RangeValues(20, 120);
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
              // Create filter result map to return to the previous screen
              final filterResult = {
                'filter': _getCategoryFilter(), // Map category to filter value
                'sortBy': 'date', // Default sort
                'category': _selectedCategory,
                'date': _getDateFilter(),
                'location': _selectedLocation,
                'priceRange': {
                  'start': _priceRange.start,
                  'end': _priceRange.end,
                },
              };
              
              // Return filter result to the previous screen
              context.pop(filterResult);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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
