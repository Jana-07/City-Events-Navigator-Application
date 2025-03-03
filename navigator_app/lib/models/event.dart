class Event {
  const Event({required this.name, required this.address, required this.date,required this.image});

  final String name;
  //TODO, make hybrid address calss model
  final String address;
  final DateTime date;
  final String image; // Add this line
}
