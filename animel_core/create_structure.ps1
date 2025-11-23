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
