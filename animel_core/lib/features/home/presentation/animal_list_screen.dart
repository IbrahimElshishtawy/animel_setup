import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../logic/animal_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  ImageProvider _resolveImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    return AssetImage(imageUrl);
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<AnimalBloc>().add(FetchAnimals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rare Animals for Sale'),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0), // Home-based
      body: BlocBuilder<AnimalBloc, AnimalState>(
        builder: (context, state) {
          if (state is AnimalLoading) {
            return const LoadingWidget();
          } else if (state is AnimalLoaded) {
            if (state.animals.isEmpty) {
              return const EmptyStateWidget(
                title: 'No rare animals available',
                message: 'Stay tuned for new additions.',
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.animals.length,
              itemBuilder: (context, index) {
                final animal = state.animals[index];
                return GestureDetector(
                  onTap: () => context.push('/animal-details', extra: animal),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              image: DecorationImage(
                                image: _resolveImage(animal.imageUrls.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                animal.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                animal.breed,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${animal.price}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AnimalError) {
            return ErrorStateWidget(message: state.message, onRetry: _fetch);
          }
          return const Center(child: Text('Start exploring rare animals!'));
        },
      ),
    );
  }
}
