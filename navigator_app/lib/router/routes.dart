class Routes {
  // Named Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String explore = '/explore';
  static const String exploreDetails = 'details/:eventId';
  static const String exploreSearch = 'search';
  static const String exploreFilter = 'filter';
  static const String settings = '/settings';
  static const String events = '/events';
  static const String profile = '/profile';
  static const String admin = '/admin';
  static const String adminCreate = 'create';
  static const String adminEdit = 'edit/:eventId';
  static const String eventList = '/event';
  static const String loading = '/loading';

  // Named route identifiers
  static const String eventDetailsName = 'eventDetails';
  static const String createEventName = 'createEvent';
  static const String editEventName = 'editEvent';
}
