import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../logic/adoption_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';

class AdoptionListScreen extends StatefulWidget {
  const AdoptionListScreen({super.key});

  @override
  State<AdoptionListScreen> createState() => _AdoptionListScreenState();
}

class _AdoptionListScreenState extends State<AdoptionListScreen> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<AdoptionBloc>().add(FetchAdoptionAnimals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopt a Friend'),
        centerTitle: true,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          if (state is AdoptionLoading) {
            return const LoadingWidget();
          } else if (state is AdoptionLoaded) {
            if (state.animals.isEmpty) {
              return const EmptyStateWidget(
                title: 'No animals for adoption',
                message: 'Check back later for new friends!',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.animals.length,
              itemBuilder: (context, index) {
                final animal = state.animals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/image/image.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(animal.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('${animal.breed} • ${animal.age}\n${animal.location}', style: const TextStyle(height: 1.3)),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/adoption-details', extra: animal),
                  ),
                );
              },
            );
          } else if (state is AdoptionError) {
            return ErrorStateWidget(message: state.message, onRetry: _fetch);
          }
          return const Center(child: Text('Find your perfect companion!'));
        },
      ),
    );
  }
}
