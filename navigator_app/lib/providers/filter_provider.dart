import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

@riverpod
class EventFilters extends _$EventFilters {
  // The build method returns the initial state
  @override
  EventFilter build() {
    // Return the initial default filter state
    return const EventFilter(categories: []);
  }

   void setCategories(List<String>? newCategories) {
    // Ensure null or empty list are handled consistently if needed
    final categoriesToSet = (newCategories == null || newCategories.isEmpty) ? null : List<String>.from(newCategories);
    state = state.copyWith(categories: categoriesToSet);
  }

  void toggleCategory(String category) {
    final currentCategories = List<String>.from(state.categories ?? []);
    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    state = state.copyWith(categories: currentCategories.isEmpty ? null : currentCategories);
  }

  void updateCity(String? city) {
    state = state.copyWith(city: () => city);
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: () => start, endDate: () => end);
  }
  
  void updatePriceRange(double? min, double? max) {
    state = state.copyWith(minPrice: () => min, maxPrice: () => max);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }
  
  void setSort(String sortBy, bool descending) {
     state = state.copyWith(sortBy: sortBy, descending: descending);
  }

  // Method to apply a whole new filter set (useful for 'Apply' button)
  void applyFilters(EventFilter newFilter) {
    state = newFilter;
  }

  void resetFilters() {
    // Reset to initial state, ensuring categories is empty list or null as defined in build()
    state = const EventFilter(categories: []); 
  }
}


// Define a class to hold all filter parameters
@immutable
class EventFilter {
  final String? searchQuery;
  final List<String>? categories; 
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minPrice;
  final double? maxPrice;
  final String? creatorId;
  final String sortBy;
  final bool descending;

  const EventFilter({
    this.searchQuery,
    this.categories,
    this.city,
    this.startDate,
    this.endDate,
    this.minPrice,
    this.maxPrice,
    this.creatorId,
    this.sortBy = 'date',
    this.descending = false,
  });

  bool get hasMultipleCategories => categories != null && categories!.length > 1;
  bool get hasConflictingFiltersForMultiCategory => 
      (startDate != null || endDate != null || minPrice != null || maxPrice != null);

  EventFilter copyWith({
    String? searchQuery,
    List<String>? categories,
    ValueGetter<String?>? city,
    ValueGetter<DateTime?>? startDate,
    ValueGetter<DateTime?>? endDate,
    ValueGetter<double?>? minPrice,
    ValueGetter<double?>? maxPrice,
    ValueGetter<String?>? creatorId,
    String? sortBy,
    bool? descending,
  }) {
    return EventFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories, // Updated
      city: city != null ? city() : this.city,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      minPrice: minPrice != null ? minPrice() : this.minPrice,
      maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
      creatorId: creatorId != null ? creatorId() : this.creatorId,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventFilter &&
          runtimeType == other.runtimeType &&
          searchQuery == other.searchQuery &&
          listEquals(categories, other.categories) &&
          city == other.city &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          creatorId == other.creatorId &&
          sortBy == other.sortBy &&
          descending == other.descending;

  @override
  int get hashCode => Object.hash(
        searchQuery,
        categories == null ? null : Object.hashAll(categories!),
        city,
        startDate,
        endDate,
        minPrice,
        maxPrice,
        creatorId,
        sortBy,
        descending,
      );
}
