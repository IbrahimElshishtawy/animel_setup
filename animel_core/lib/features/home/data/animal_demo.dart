class AnimalDemo {
  final String name;
  final String imageUrl;
  final String location;
  final String timeAgo;
  final String? status;

  const AnimalDemo({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.timeAgo,
    this.status,
  });
}
