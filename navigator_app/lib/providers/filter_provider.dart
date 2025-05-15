import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

@Riverpod(keepAlive: true)
class EventFilters extends _$EventFilters {
  // The build method returns the initial state
  @override
  EventFilter build(String listId) {
    // Return the initial default filter state
    return const EventFilter(categories: []);
  }

  // Helper to reset all filters except search query
  EventFilter _resetFiltersExceptSearch() {
    return EventFilter(
      searchQuery: state.searchQuery, // Keep current search query
      categories: [], // Reset categories
      city: null,
      startDate: null,
      endDate: null,
      minPrice: null,
      maxPrice: null,
      creatorId: null,
      sortBy: 'date', // Reset sort
      descending: false,
    );
  }

  // Helper to reset only the search query
  EventFilter _resetSearchQuery() {
    return state.copyWith(searchQuery: null);
  }

  void setCategories(List<String>? newCategories) {
    final categoriesToSet = (newCategories == null || newCategories.isEmpty) ? null : List<String>.from(newCategories);
    // If setting categories, clear search query
    state = _resetSearchQuery().copyWith(categories: categoriesToSet);
  }

  void toggleCategory(String category) {
    final currentCategories = List<String>.from(state.categories ?? []);
    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    final categoriesToSet = currentCategories.isEmpty ? null : currentCategories;
    // If toggling categories, clear search query
    state = _resetSearchQuery().copyWith(categories: categoriesToSet);
  }

  void updateCity(String? city) {
    // If setting city, clear search query
    state = _resetSearchQuery().copyWith(city: () => city);
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    // If setting date range, clear search query
    state = _resetSearchQuery().copyWith(startDate: () => start, endDate: () => end);
  }
  
  void updatePriceRange(double? min, double? max) {
    // If setting price range, clear search query
    state = _resetSearchQuery().copyWith(minPrice: () => min, maxPrice: () => max);
  }

  void setSearchQuery(String? query) {
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      // If setting a non-empty search query, reset all other filters
      state = _resetFiltersExceptSearch().copyWith(searchQuery: trimmedQuery);
    } else {
      // If clearing the search query, just update it (other filters remain as they were)
      state = state.copyWith(searchQuery: null);
    }
  }
  
  void setSort(String sortBy, bool descending) {
     // Sorting can apply to both search and filter results, so don't reset others
     state = state.copyWith(sortBy: sortBy, descending: descending);
  }

  // Method to apply a whole new filter set (useful for 'Apply' button)
  void applyFilters(EventFilter newFilter) {
    // If the new filter set has a search query, ensure other filters are reset
    if (newFilter.searchQuery != null && newFilter.searchQuery!.isNotEmpty) {
       state = EventFilter(
         searchQuery: newFilter.searchQuery,
         categories: [],
         city: null,
         startDate: null,
         endDate: null,
         minPrice: null,
         maxPrice: null,
         creatorId: null,
         sortBy: newFilter.sortBy, // Keep sort from new filter
         descending: newFilter.descending,
       );
    } else {
       // If no search query, apply the new filter set as is (search query will be null)
       state = newFilter.copyWith(searchQuery: null);
    }
  }

  void resetFilters() {
    // Reset to initial state, including clearing search query
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
    this.sortBy = 'date', // Default sort
    this.descending = false,
  });

  // Helper getter to check if any filter other than search/sort is active
  bool get hasActiveFilters => 
      (categories != null && categories!.isNotEmpty) ||
      (city != null && city!.isNotEmpty) ||
      startDate != null ||
      endDate != null ||
      minPrice != null ||
      maxPrice != null ||
      creatorId != null;

  // --- Removed conflicting filter checks as they are handled by mutual exclusivity ---
  // bool get hasMultipleCategories => categories != null && categories!.length > 1;
  // bool get hasConflictingFiltersForMultiCategory => 
  //     (startDate != null || endDate != null || minPrice != null || maxPrice != null);

  EventFilter copyWith({
    String? searchQuery, // Keep nullable for clearing
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
      // Handle potential null assignment for searchQuery
      searchQuery: searchQuery, 
      categories: categories ?? this.categories,
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

