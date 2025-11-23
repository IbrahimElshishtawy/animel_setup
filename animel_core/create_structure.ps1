# # Define root path (current directory)
# $root = Get-Location

# # Define folder structure
# $folders = @(
#     "lib",
#     "lib/core",
#     "lib/core/routing",
#     "lib/core/theme",
#     "lib/core/localization",
#     "lib/core/widgets",
#     "lib/core/services",

#     "lib/features",
#     "lib/features/splash/presentation",
#     "lib/features/onboarding/presentation",

#     "lib/features/auth/data",
#     "lib/features/auth/domain",
#     "lib/features/auth/presentation",

#     "lib/features/home/data",
#     "lib/features/home/domain",
#     "lib/features/home/presentation",

#     "lib/features/search/presentation",

#     "lib/features/report/data",
#     "lib/features/report/domain",
#     "lib/features/report/presentation",

#     "lib/features/profile/data",
#     "lib/features/profile/domain",
#     "lib/features/profile/presentation",

#     "lib/features/adoption/presentation",
#     "lib/features/donation/presentation"
# )

# # Create directories
# foreach ($folder in $folders) {
#     $path = Join-Path $root $folder
#     if (-Not (Test-Path $path)) {
#         New-Item -ItemType Directory -Path $path | Out-Null
#         Write-Host "Created: $path"
#     } else {
#         Write-Host "Already exists: $path"
#     }
# }

# # Create basic files
# $files = @{
#     "lib/app.dart" = ""
#     "lib/main.dart" = ""
#     "lib/core/routing/app_router.dart" = ""
#     "lib/core/theme/app_theme.dart" = ""
#     "lib/core/localization/l10n.dart" = ""
#     "lib/core/services/api_client.dart" = ""
#     "lib/core/services/auth_service.dart" = ""
#     "lib/core/services/storage_service.dart" = ""

#     "lib/core/widgets/app_button.dart" = ""
#     "lib/core/widgets/app_text_field.dart" = ""
#     "lib/core/widgets/bottom_nav_bar.dart" = ""

#     # Auth Screens
#     "lib/features/auth/presentation/login_screen.dart" = ""
#     "lib/features/auth/presentation/register_screen.dart" = ""
#     "lib/features/auth/presentation/verify_email_screen.dart" = ""

#     # Home Screens
#     "lib/features/home/presentation/home_screen.dart" = ""
#     "lib/features/home/presentation/animal_details_screen.dart" = ""

#     # Search
#     "lib/features/search/presentation/search_screen.dart" = ""

#     # Report
#     "lib/features/report/presentation/report_step1_screen.dart" = ""
#     "lib/features/report/presentation/report_step2_screen.dart" = ""

#     # Profile
#     "lib/features/profile/presentation/profile_screen.dart" = ""
#     "lib/features/profile/presentation/my_account_screen.dart" = ""
#     "lib/features/profile/presentation/edit_account_screen.dart" = ""
#     "lib/features/profile/presentation/my_pets_screen.dart" = ""
#     "lib/features/profile/presentation/add_pet_step1_screen.dart" = ""
#     "lib/features/profile/presentation/add_pet_step2_screen.dart" = ""

#     # Adoption
#     "lib/features/adoption/presentation/adopt_list_screen.dart" = ""

#     # Donation
#     "lib/features/donation/presentation/donation_screen.dart" = ""
# }

# # Create empty dart files
# foreach ($file in $files.Keys) {
#     $path = Join-Path $root $file
#     if (-Not (Test-Path $path)) {
#         New-Item -ItemType File -Path $path | Out-Null
#         Write-Host "Created file: $path"
#     } else {
#         Write-Host "Already exists: $path"
#     }
# }

# Write-Host "`nAll folders and files created successfully!"
# Root path
$root = Join-Path (Get-Location) "lib/core/widgets"

# Ensure widgets folder exists
if (-Not (Test-Path $root)) {
    New-Item -ItemType Directory -Path $root | Out-Null
    Write-Host "Created widgets directory."
}

# Dictionary of files with their content
$files = @{
    "section_title.dart" = @"
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
"@

    "category_chip.dart" = @"
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? Theme.of(context).primaryColor.withOpacity(0.15)
              : const Color(0xFFF4F2F6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: selected
                ? Theme.of(context).primaryColor
                : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
"@

    "animal_card.dart" = @"
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;
  final String time;
  final VoidCallback onTap;
  final String status;

  const AnimalCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.time,
    required this.status,
    required this.onTap,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'lost':
        return const Color(0xFFE57373);
      case 'found':
        return const Color(0xFF4FC3F7);
      case 'adopt':
        return const Color(0xFF81C784);
      case 'home':
        return const Color(0xFFA1887F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.06),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: _statusColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
"@

    "app_divider.dart" = @"
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double height;

  const AppDivider({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Divider(
        color: Colors.grey.shade300,
        thickness: 1,
      ),
    );
  }
}
"@

    "loading_widget.dart" = @"
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: const TextStyle(fontSize: 15))
          ]
        ],
      ),
    );
  }
}
"@

    "empty_state_widget.dart" = @"
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
"@

    "custom_app_bar.dart" = @"
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool center;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.center = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: center,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: actions,
    );
  }
}
"@

    "avatar_circle.dart" = @"
import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  final String imageUrl;
  final double size;
  final VoidCallback? onTap;

  const AvatarCircle({
    super.key,
    required this.imageUrl,
    this.size = 42,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(imageUrl),
    );

    if (onTap == null) return avatar;

    return GestureDetector(
      onTap: onTap,
      child: avatar,
    );
  }
}
"@
}

# Create each file with content
foreach ($file in $files.Keys) {
    $path = Join-Path $root $file
    Set-Content -Path $path -Value $files[$file] -Encoding UTF8
    Write-Host "Created: $file"
}

Write-Host "`nAll widget files created successfully!"
