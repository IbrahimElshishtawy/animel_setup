import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/widgets/bottom_nav_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/address_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(onProfileTap: () => context.go('/profile')),
                    const SizedBox(height: 18),
                    const AddressField(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, 'Explore Services', null),
                    const SizedBox(height: 12),
                    _buildServicesGrid(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, 'Recently Added', () => context.push('/animal-list')),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildRecentAnimalsSliver(context),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All'),
          ),
      ],
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildServiceCard(context, 'Buy Animals', MdiIcons.paw, Colors.orange, '/animal-list'),
        _buildServiceCard(context, 'Adoption', MdiIcons.heart, Colors.red, '/adopt'),
        _buildServiceCard(context, 'Supplies', MdiIcons.store, Colors.blue, '/shop'),
        _buildServiceCard(context, 'Map View', MdiIcons.mapMarker, Colors.green, '/map'),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnimalsSliver(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildMockAnimalCard(context);
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildMockAnimalCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage('assets/image/image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Persian Cat', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$500', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
