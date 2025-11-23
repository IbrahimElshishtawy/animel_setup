import 'package:flutter/material.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final String name;
  final String status; // Lost / Found / Adopt / Already Home
  final String category;
  final String color;
  final String age;
  final String ownerName;
  final String ownerEmail;
  final String description;
  final String location;
  final String imageUrl;
  final double? reward;

  const AnimalDetailsScreen({
    super.key,
    required this.name,
    required this.status,
    required this.category,
    required this.color,
    required this.age,
    required this.ownerName,
    required this.ownerEmail,
    required this.description,
    required this.location,
    required this.imageUrl,
    this.reward,
  });

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'lost':
        return const Color(0xFFE57373);
      case 'found':
        return const Color(0xFF4FC3F7);
      case 'adopt':
        return const Color(0xFF81C784);
      case 'already home':
        return const Color(0xFF8D6E63);
      default:
        return const Color(0xFF4B1A45);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6ECF3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF4B1A45),
        title: const Text(
          'Animal details',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderImage(imageUrl: imageUrl),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TitleRow(
                            name: name,
                            status: status,
                            statusColor: _statusColor,
                            reward: reward,
                          ),
                          const SizedBox(height: 16),
                          _AttributesSection(
                            category: category,
                            color: color,
                            age: age,
                          ),
                          const SizedBox(height: 16),
                          _OwnerSection(name: ownerName, email: ownerEmail),
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Location',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Color(0xFF8C3A7B),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _MapPreview(address: location),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderImage extends StatefulWidget {
  final String imageUrl;
  const _HeaderImage({required this.imageUrl});

  @override
  State<_HeaderImage> createState() => _HeaderImageState();
}

class _HeaderImageState extends State<_HeaderImage> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final images = [widget.imageUrl, widget.imageUrl, widget.imageUrl];

    return Column(
      children: [
        SizedBox(
          height: 260,
          width: double.infinity,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => current = i),
            itemBuilder: (_, index) {
              return Image.network(images[index], fit: BoxFit.cover);
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (i) => Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == current
                    ? const Color(0xFF4B1A45)
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final double? reward;

  const _TitleRow({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: statusColor.withOpacity(0.12),
          ),
          child: Row(
            children: [
              Icon(Icons.pets, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (reward != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFFFF3E0),
            ),
            child: Text(
              'Reward :${reward!.toStringAsFixed(0)}\$',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFE67E22),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AttributesSection extends StatelessWidget {
  final String category;
  final String color;
  final String age;

  const _AttributesSection({
    required this.category,
    required this.color,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(
      fontSize: 13,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );
    TextStyle valueStyle = const TextStyle(fontSize: 13, color: Colors.black87);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Category: ', style: labelStyle),
            Text(category, style: valueStyle),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Color: ', style: labelStyle),
            Text(color, style: valueStyle),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text('Age: ', style: labelStyle),
            Text(age, style: valueStyle),
          ],
        ),
      ],
    );
  }
}

class _OwnerSection extends StatelessWidget {
  final String name;
  final String email;

  const _OwnerSection({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECF3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE4CBDD),
            child: Icon(Icons.person_outline, color: Color(0xFF4B1A45)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.email_outlined), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  final String address;
  const _MapPreview({required this.address});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 170,
        width: double.infinity,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Text(
          'Map preview\n(Static image or Google Map widget)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }
}
