// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../logic/animal_bloc.dart';

import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/fade_in_animation.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../widgets/home_header.dart';
import '../widgets/address_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<AnimalBloc>().add(const FetchAnimals());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: HomeHeader(
                        onProfileTap: () => context.go('/profile'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: const AddressField(),
                    ),
                    const SizedBox(height: 32),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: _buildSectionHeader(
                        context,
                        'Explore Services',
                        null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 400),
                      child: _buildServicesGrid(context),
                    ),
                    const SizedBox(height: 32),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 500),
                      child: _buildSectionHeader(
                        context,
                        'Recently Added',
                        () => context.push('/animal-list'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildRecentAnimalsSliver(context),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback? onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'See All',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildServiceCard(
          context,
          'Buy Animals',
          MdiIcons.paw,
          Colors.orange,
          '/animal-list',
        ),
        _buildServiceCard(
          context,
          'Adoption',
          MdiIcons.heart,
          Colors.red,
          '/adopt',
        ),
        _buildServiceCard(
          context,
          'Supplies',
          MdiIcons.store,
          Colors.blue,
          '/shop',
        ),
        _buildServiceCard(
          context,
          'Map View',
          MdiIcons.mapMarker,
          Colors.green,
          '/map',
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push(route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnimalsSliver(BuildContext context) {
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        if (state is AnimalLoading) {
          return const SliverToBoxAdapter(child: LoadingWidget());
        } else if (state is AnimalLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final animal = state.animals[index];
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 600 + (index * 100)),
                    child: GestureDetector(
                      onTap: () =>
                          context.push('/animal-details', extra: animal),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage('assets/image/image.png'),
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
                                    '\$${animal.price}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: state.animals.length > 4 ? 4 : state.animals.length,
              ),
            ),
          );
        } else if (state is AnimalError) {
          return SliverToBoxAdapter(
            child: ErrorStateWidget(message: state.message, onRetry: _fetch),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
