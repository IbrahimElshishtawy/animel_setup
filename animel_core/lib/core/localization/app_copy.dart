import 'package:flutter/material.dart';

class AppCopy {
  AppCopy(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode.toLowerCase() == 'ar';

  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get explore => isArabic ? 'استكشاف' : 'Explore';
  String get add => isArabic ? 'إضافة' : 'Add';
  String get messages => isArabic ? 'الرسائل' : 'Messages';
  String get profile => isArabic ? 'الملف الشخصي' : 'Profile';
  String get search => isArabic ? 'بحث' : 'Search';
  String get shop => isArabic ? 'المتجر' : 'Shop';
  String get adopt => isArabic ? 'التبني' : 'Adopt';
  String get nearby => isArabic ? 'بالقرب منك' : 'Nearby';
  String get all => isArabic ? 'الكل' : 'All';
  String get tryAgain => isArabic ? 'حاول مرة أخرى' : 'Try again';
  String get resetSearch => isArabic ? 'إعادة البحث' : 'Reset search';
  String get loading => isArabic ? 'جار التحميل' : 'Loading';
  String get noResults => isArabic ? 'لا توجد نتائج' : 'No results';
  String get products => isArabic ? 'المنتجات' : 'Products';
  String get listings => isArabic ? 'الإعلانات' : 'Listings';
  String get helpers => isArabic ? 'الخدمات' : 'Helpers';
  String get reviews => isArabic ? 'التقييمات' : 'Reviews';
  String get about => isArabic ? 'حول' : 'About';
  String get description => isArabic ? 'الوصف' : 'Description';
  String get stock => isArabic ? 'المخزون' : 'Stock';
  String get type => isArabic ? 'النوع' : 'Type';
  String get general => isArabic ? 'عام' : 'General';
  String get addToCart => isArabic ? 'أضف إلى السلة' : 'Add to cart';
  String get addedToCart => isArabic ? 'تمت الإضافة إلى السلة' : 'Added to cart';
  String get animalConnect => isArabic ? 'أنيمل كونكت' : 'Animal Connect';
  String get splashSubtitle => isArabic
      ? 'رعاية واكتشاف وتبني الحيوانات بشكل عصري وموثوق.'
      : 'Premium animal care, discovery, rescue, and adoption.';
  String get searchExperienceTitle =>
      isArabic ? 'اكتشف كل ما في التطبيق' : 'Discover everything in the app';
  String get searchExperienceSubtitle => isArabic
      ? 'ابحث في الحيوانات والمنتجات والخدمات القريبة من شاشة واحدة احترافية.'
      : 'Search animals, products, and nearby helpers from one polished screen.';
  String get searchHint => isArabic
      ? 'ابحث عن منتجات أو حيوانات أو خدمات'
      : 'Search products, animals, or services';
  String get searchSubhint => isArabic
      ? 'طعام، إكسسوارات، تبني، خدمات قريبة'
      : 'Food, accessories, adoption, and nearby services';
  String get quickFilters => isArabic ? 'فلاتر سريعة' : 'Quick filters';
  String get trendingNow => isArabic ? 'الأكثر رواجًا' : 'Trending now';
  String get allResults => isArabic ? 'كل النتائج' : 'All results';
  String get noSearchResultsTitle =>
      isArabic ? 'لا توجد نتائج مطابقة' : 'Nothing matched your search';
  String get noSearchResultsMessage => isArabic
      ? 'جرّب كلمة مختلفة أو ارجع للفلاتر الشائعة لعرض كل المحتوى.'
      : 'Try another keyword or jump back to the popular filters to explore everything.';
  String get shopCollection => isArabic ? 'تجميعة المتجر' : 'Shop collection';
  String get adoptionSpotlight => isArabic ? 'تبني مميز' : 'Adoption spotlight';
  String get nearbyServices => isArabic ? 'خدمات قريبة' : 'Nearby services';
  String get searchProductsLabel =>
      isArabic ? 'منتجات وعروض احترافية' : 'Products and premium picks';
  String get searchAnimalsLabel =>
      isArabic ? 'حيوانات جاهزة للعرض' : 'Animals ready to explore';
  String get searchHelpersLabel =>
      isArabic ? 'مساعدون وخدمات موثوقة' : 'Trusted helpers and services';
  String get animalSuppliesTitle =>
      isArabic ? 'مستلزمات الحيوانات' : 'Animal Supplies';
  String get animalSuppliesSubtitle => isArabic
      ? 'منتجات مختارة للطعام والعناية واللعب بتجربة شراء أنيقة.'
      : 'Curated products for feeding, care, wellness, and play with a cleaner buying experience.';
  String get shopEssentials => isArabic ? 'أساسيات المتجر' : 'Shop essentials';
  String productsAvailable(int count) => isArabic
      ? '$count منتج متاح الآن'
      : '$count products available';
  String cartSummary(int itemCount, double total) => isArabic
      ? '$itemCount عناصر في السلة • ${total.toStringAsFixed(0)}\$ الإجمالي'
      : '$itemCount items in cart • \$${total.toStringAsFixed(0)} total';
  String get searchShopHint => isArabic
      ? 'ابحث عن طعام أو ألعاب أو مستلزمات'
      : 'Search food, toys, and essentials';
  String get loadingProducts => isArabic
      ? 'جار تجهيز توصيات المنتجات'
      : 'Preparing product recommendations';
  String get noProductsFound => isArabic
      ? 'لا توجد منتجات الآن'
      : 'No products found';
  String get noProductsFoundMessage => isArabic
      ? 'جرّب بحثًا مختلفًا أو غيّر التصنيف لعرض المزيد.'
      : 'Try another search or switch categories for more results.';
  String get everydayPetCare => isArabic
      ? 'للاستخدام اليومي في رعاية الحيوانات'
      : 'For everyday pet care';
  String bestFor(String animalType) => isArabic
      ? 'مناسب لـ $animalType'
      : 'Best for $animalType';
  String get addButton => isArabic ? 'أضف' : 'Add';
  String get suitableForEverydayCare => isArabic
      ? 'مناسب للاستخدام اليومي'
      : 'Suitable for everyday pet care';
  String recommendedFor(String animalType) => isArabic
      ? 'موصى به لـ $animalType'
      : 'Recommended for $animalType';
  String get productDescriptionEmpty => isArabic
      ? 'لا يوجد وصف لهذا المنتج بعد.'
      : 'This product has no description yet.';
  String get shopProfessionalCatalog => isArabic
      ? 'عرض احترافي لكل المنتجات'
      : 'A professional showcase for every product';
  String get shopProfessionalCatalogSubtitle => isArabic
      ? 'واجهة منظمة تساعد المستخدم على استعراض كل المنتجات بسرعة ووضوح.'
      : 'A clean catalog layout helps people browse every product quickly and clearly.';
  String get browseCategory => isArabic ? 'تصفح حسب الفئة' : 'Browse by category';
  String get browseCategorySubtitle => isArabic
      ? 'مسارات مختارة للتسوق والتبني والاكتشاف.'
      : 'Curated paths for shopping, adoption, and discovery.';
  String get featuredAnimals => isArabic ? 'حيوانات مميزة' : 'Featured Animals';
  String get featuredAnimalsSubtitle => isArabic
      ? 'إعلانات مختارة من بائعين موثوقين وتحديثات مميزة.'
      : 'Trending listings from trusted sellers and standout breeders.';
  String get seeAll => isArabic ? 'عرض الكل' : 'See all';
  String get foodAndSupplies => isArabic ? 'الطعام والمستلزمات' : 'Food & Supplies';
  String get foodAndSuppliesSubtitle => isArabic
      ? 'أساسيات يومية بعرض احترافي وإجراءات سريعة.'
      : 'Modern essentials with premium presentation and quick actions.';
  String get viewShop => isArabic ? 'عرض المتجر' : 'View shop';
  String get nearbyAnimalsTitle =>
      isArabic ? 'حيوانات قريبة' : 'Nearby Animals';
  String get nearbyAnimalsSubtitle => isArabic
      ? 'استكشاف محلي سريع مع معاينة مرئية أوضح.'
      : 'Quick local discovery with a map-first preview.';
  String get openMap => isArabic ? 'افتح الخريطة' : 'Open map';
  String get adoptionSpotlightTitle =>
      isArabic ? 'امنحهم منزلًا' : 'Give Them a Home';
  String get adoptionSpotlightSubtitle => isArabic
      ? 'قصص تبني موثوقة مع إجراءات سريعة.'
      : 'Warm, trustworthy adoption stories with quick actions.';
  String get adoptNow => isArabic ? 'تبنَّ الآن' : 'Adopt Now';
  String get rareAnimalsSubtitle => isArabic
      ? 'تصفح إعلانات الحيوانات بتصميم أوضح ومسح أسهل.'
      : 'Browse curated animal listings with cleaner cards, easier scanning, and richer detail previews.';
  String get premiumMarketplace => isArabic
      ? 'سوق احترافي مميز'
      : 'Premium marketplace';
  String listingsVisible(int count) => isArabic
      ? '$count إعلانًا ظاهرًا الآن'
      : '$count listings currently visible';
  String get searchBreedAgeLocation => isArabic
      ? 'ابحث حسب السلالة أو العمر أو الموقع.'
      : 'Search by breed, age, or nearby location.';
  String get preparingListings => isArabic
      ? 'جار تجهيز الإعلانات المختارة'
      : 'Preparing curated marketplace listings';
  String get noAnimalsFound => isArabic ? 'لم يتم العثور على حيوانات' : 'No animals found';
  String get noAnimalsFoundMessage => isArabic
      ? 'جرّب كلمة أخرى أو عد لاحقًا لمشاهدة إعلانات جديدة.'
      : 'Try another search term or check back later for fresh listings.';
  String get forSale => isArabic ? 'للبيع' : 'For sale';
  String get adoptionLabel => isArabic ? 'تبني' : 'Adoption';
  String get freeLabel => isArabic ? 'مجاني' : 'Free';
  String get adoptionListing => isArabic ? 'إعلان تبني' : 'Adoption listing';
  String get marketplaceListing =>
      isArabic ? 'إعلان في السوق' : 'Marketplace listing';
  String aboutAnimal(String name) =>
      isArabic ? 'حول $name' : 'About $name';
  String get noAnimalDescription => isArabic
      ? 'لم تتم إضافة وصف مفصل لهذا الإعلان بعد.'
      : 'This listing has not added a detailed description yet.';
  String get healthAndCare => isArabic ? 'الصحة والرعاية' : 'Health and care';
  String get noHealthNotes => isArabic
      ? 'لا توجد ملاحظات صحية بعد.'
      : 'No health notes added yet.';
  String get owner => isArabic ? 'المالك' : 'Owner';
  String get caretaker => isArabic ? 'المسؤول' : 'Caretaker';
  String get seller => isArabic ? 'البائع' : 'Seller';
  String get openChatOwner => isArabic
      ? 'افتح الدردشة للتواصل مع المالك.'
      : 'Open chat to continue with the owner.';
  String get contactCaretaker =>
      isArabic ? 'تواصل مع المسؤول' : 'Contact caretaker';
  String get contactSeller => isArabic ? 'تواصل مع البائع' : 'Contact seller';
  String get breed => isArabic ? 'السلالة' : 'Breed';
  String get size => isArabic ? 'الحجم' : 'Size';
  String get age => isArabic ? 'العمر' : 'Age';
  String get gender => isArabic ? 'النوع' : 'Gender';
  String get adoptFriendSubtitle => isArabic
      ? 'إعلانات تبني دافئة وموثوقة بتجربة تصفح أهدأ.'
      : 'Warm, trustworthy adoption listings with clearer context and calmer browsing.';
  String get adoptionReady => isArabic ? 'جاهز للتبني' : 'Adoption ready';
  String companionsWaiting(int count) => isArabic
      ? '$count رفيق بانتظار منزل'
      : '$count companions waiting';
  String get adoptionExploreHint => isArabic
      ? 'استعرض الحالة الصحية والشخصية والموقع قبل التواصل.'
      : 'Explore health status, personality, and location before reaching out.';
  String get searchAdoptionListings => isArabic
      ? 'ابحث في إعلانات التبني'
      : 'Search adoption listings';
  String get loadingAdoptionCompanions => isArabic
      ? 'جار تحميل الحيوانات الجاهزة للتبني'
      : 'Loading adoption-ready companions';
  String get noAdoptionListings => isArabic
      ? 'لا توجد إعلانات تبني حاليًا'
      : 'No adoption listings yet';
  String get noAdoptionListingsMessage => isArabic
      ? 'عد لاحقًا لرؤية رفقاء جدد.'
      : 'Check back soon for new companions.';
  String get nearbyCommunity => isArabic ? 'مجتمع قريب منك' : 'Nearby community';
  String get setLocationToDiscover => isArabic
      ? 'حدد موقعك لاكتشاف الأشخاص من حولك.'
      : 'Set your location to discover people around you.';
  String basedOn(String location) =>
      isArabic ? 'بناءً على $location' : 'Based on $location';
  String get communityHeroText => isArabic
      ? 'اعثر على المتبنين والمشترين وملاك الحيوانات القريبين دون فتح خريطة كاملة.'
      : 'Find adopters, buyers, and pet owners close to your area without opening a map.';
  String nearbyResults(int count) =>
      isArabic ? '$count نتائج قريبة' : '$count nearby results';
  String get mapHidden => isArabic ? 'الخريطة مخفية' : 'Map hidden';
  String get updateMyLocation =>
      isArabic ? 'تحديث موقعي' : 'Update my location';
  String get nearbyPeople => isArabic ? 'أشخاص قريبون' : 'Nearby people';
  String get locationNotAvailable =>
      isArabic ? 'الموقع غير متاح' : 'Location not available';
  String get availableNearbySupport => isArabic
      ? 'متاح قريبًا للدعم المجتمعي المتعلق بالحيوانات.'
      : 'Available nearby for pet-related community support.';
  String get startChat => isArabic ? 'ابدأ الدردشة' : 'Start chat';
  String get setLocationFirst =>
      isArabic ? 'حدد موقعك أولًا' : 'Set your location first';
  String get setLocationFirstMessage => isArabic
      ? 'يتم مطابقة المستخدمين القريبين حسب الموقع المكتوب في ملفك الشخصي.'
      : 'Nearby users are matched using the location written in your profile.';
  String get openProfileSettings =>
      isArabic ? 'افتح إعدادات الملف' : 'Open profile settings';
  String get couldNotLoadNearby =>
      isArabic ? 'تعذر تحميل الأشخاص القريبين' : 'Could not load nearby people';
  String get noNearbyUsers => isArabic ? 'لا يوجد مستخدمون قريبون' : 'No nearby users yet';
  String get noNearbyUsersAllMessage => isArabic
      ? 'لم يظهر مستخدمون يطابقون موقعك القريب بعد.'
      : 'No users with matching nearby locations appeared yet.';
  String get noNearbyUsersFilteredMessage => isArabic
      ? 'لا يوجد مستخدمون يطابقون الفلتر المحدد قرب منطقتك.'
      : 'No users matched the selected filter near your area.';
  String get showAllUsers => isArabic ? 'عرض كل المستخدمين' : 'Show all users';
  String get filterAll => isArabic ? 'الكل' : 'All';
  String get filterOwners => isArabic ? 'الملاك' : 'Owners';
  String get filterBuyers => isArabic ? 'المشترون' : 'Buyers';
  String get filterAdopters => isArabic ? 'المتبنون' : 'Adopters';
  String get myPets => isArabic ? 'حيواناتي' : 'My pets';
  String get ownerSpace => isArabic ? 'مساحة المالك' : 'Owner space';
  String get ownerSpaceTitle => isArabic
      ? 'نظّم كل حيوان في مكان واحد أنيق.'
      : 'Keep every companion organized in one polished place.';
  String get ownerSpaceSubtitle => isArabic
      ? 'أنشئ الملفات وحدّث التفاصيل وجهّز الإعلانات بسهولة.'
      : 'Build profiles, update details, and prepare adoption or sale listings without losing context.';
  String get addPetProfile => isArabic ? 'أضف ملف حيوان' : 'Add a pet profile';
  String petProfilesCount(int count) =>
      isArabic ? '$count ملفات حيوانات' : '$count pet profiles';
  String get myPetsSubtitle => isArabic
      ? 'نظرة أوضح على الحيوانات التي تديرها الآن.'
      : 'A cleaner snapshot of the pets you manage right now.';
  String get noPetProfiles => isArabic ? 'لا توجد ملفات حيوانات' : 'No pet profiles yet';
  String get noPetProfilesMessage => isArabic
      ? 'أنشئ أول ملف لحيوانك ليظهر هنا مع الصحة والموقع وتفاصيل الإعلان.'
      : 'Create your first pet profile so it appears here with its health, location, and listing details.';
  String get addFirstPet => isArabic ? 'أضف أول حيوان' : 'Add first pet';
  String get adoptionProfile => isArabic ? 'ملف تبني' : 'Adoption profile';
  String get openPetProfile => isArabic ? 'افتح ملف الحيوان' : 'Open pet profile';
  String get setPetProfile => isArabic ? 'إعداد ملف حيوان' : 'Set a pet profile';
  String get petProfileIntro => isArabic
      ? 'أنشئ ملفًا قويًا لحيوانك قبل البيع أو التبني أو التحديثات المستقبلية.'
      : 'Build a strong profile for your pet before listing, adoption, or future updates.';
  String get listingType => isArabic ? 'نوع الإعلان' : 'Listing type';
  String get dateOfBirth => isArabic ? 'تاريخ الميلاد' : 'Date of birth';
  String get pet => isArabic ? 'الحيوان' : 'Pet';
  String get color => isArabic ? 'اللون' : 'Color';
  String get behavior => isArabic ? 'السلوك' : 'Behavior';
  String get weightKg => isArabic ? 'الوزن (كجم)' : 'Weight (kg)';
  String get price => isArabic ? 'السعر' : 'Price';
  String get aboutSpecialMarks =>
      isArabic ? 'نبذة / علامات مميزة' : 'About / Special marks';
  String get favorites => isArabic ? 'المفضلات' : 'Favorites';
  String get animalPhotos => isArabic ? 'صور الحيوان' : 'Animal photos';
  String get choosePhotosHint => isArabic
      ? 'اختر حتى 4 صور، وستكون الأولى صورة الغلاف.'
      : 'Choose up to 4 photos from your phone. The first photo will be used as the cover.';
  String get save => isArabic ? 'حفظ' : 'Save';
  String get petNameValidation =>
      isArabic ? 'يرجى إدخال اسم الحيوان' : 'Please enter the pet name';
  String get petDobValidation => isArabic
      ? 'يرجى اختيار تاريخ الميلاد'
      : 'Please choose the date of birth';
  String get petLocationValidation => isArabic
      ? 'يرجى إدخال موقع الحيوان'
      : 'Please enter the pet location';
  String get petDescriptionValidation => isArabic
      ? 'يرجى إضافة وصف قصير لا يقل عن 10 أحرف'
      : 'Please add a short description with at least 10 characters';
  String get petPhotoValidation => isArabic
      ? 'يرجى اختيار صورة واحدة على الأقل'
      : 'Please select at least one photo for the animal';
  String get validPriceValidation => isArabic
      ? 'يرجى إدخال سعر صحيح'
      : 'Please enter a valid price';
  String photoLimitMessage(int count) => isArabic
      ? 'يمكنك إضافة $count صور فقط'
      : 'You can add up to $count photos only';
  String firstPhotosAdded(int count) => isArabic
      ? 'تمت إضافة أول $count صور فقط'
      : 'Only the first $count photos were added';
  String yearsLabel(int value) =>
      isArabic ? '$value سنوات' : '$value years';
  String yearLabel(int value) => isArabic ? '$value سنة' : '$value year';
  String monthsLabel(int value) =>
      isArabic ? '$value أشهر' : '$value months';
  String monthLabel(int value) => isArabic ? '$value شهر' : '$value month';
  String get lessThanOneMonth =>
      isArabic ? 'أقل من شهر' : 'Less than 1 month';
  String get chat => isArabic ? 'دردشة' : 'Chat';
  String get call => isArabic ? 'اتصال' : 'Call';
  String get map => isArabic ? 'الخريطة' : 'Map';
  String get directions => isArabic ? 'الاتجاهات' : 'Directions';
  String get defaultUserName => isArabic ? 'صديق' : 'friend';
  String discoverCompanion(String name) => isArabic
      ? 'اكتشف رفيقك القادم، $name'
      : 'Discover your next companion, $name';
  String get homeHeroSubtitle => isArabic
      ? 'اكتشف الحيوانات المميزة وفرص التبني ومستحضرات الرعاية الراقية في مكان واحد.'
      : 'Find rare animals, adoption, and premium supplies';
  String get homeSearchBarTitle => isArabic
      ? 'ابحث عن الحيوانات والطعام والخدمات...'
      : 'Search pets, food, sitters...';
  String get homeSearchBarSubtitle => isArabic
      ? 'إعلانات السوق والخدمات القريبة والمنتجات المختارة في شاشة واحدة'
      : 'Marketplace listings, nearby helpers, and curated essentials';
  String get bannerTrustedCompanionsTitle => isArabic
      ? 'رفقاء موثوقون لكل نوع من البيوت'
      : 'Trusted companions for every kind of home';
  String get bannerTrustedCompanionsSubtitle => isArabic
      ? 'إعلانات مميزة وقصص تبنٍ موثوقة وبائعون معتمدون داخل سوق هادئ وواضح.'
      : 'Premium listings, careful adoption stories, and verified sellers in one calm marketplace.';
  String get bannerTrustedCompanionsCta =>
      isArabic ? 'استكشف الحيوانات' : 'Explore pets';
  String get bannerUrgentAdoptionTitle => isArabic
      ? 'تبنٍ عاجل بعناية أكبر'
      : 'Urgent adoption, handled with more care';
  String get bannerUrgentAdoptionSubtitle => isArabic
      ? 'تعرّف على الحيوانات التي تحتاج منزلًا بسرعة وتواصل مع أشخاص موثوقين.'
      : 'Meet animals that need a home quickly and connect with people you can trust.';
  String get bannerUrgentAdoptionCta =>
      isArabic ? 'تبنَّ الآن' : 'Adopt now';
  String get bannerHelpersTitle => isArabic
      ? 'طعام وإكسسوارات ومساعدون بالقرب منك'
      : 'Food, accessories, and nearby helpers';
  String get bannerHelpersSubtitle => isArabic
      ? 'وفّر مستلزمات الرعاية اليومية واكتشف العناية والتنزه والجلسات القريبة منك.'
      : 'Stock up on everyday supplies and discover groomers, walkers, and sitters around you.';
  String get bannerHelpersCta =>
      isArabic ? 'عرض الأساسيات' : 'View essentials';
  String get petsCategory => isArabic ? 'الحيوانات' : 'Pets';
  String get adoptionCategory => isArabic ? 'التبني' : 'Adoption';
  String get foodCategory => isArabic ? 'الطعام' : 'Food';
  String get accessoriesCategory => isArabic ? 'الإكسسوارات' : 'Accessories';
  String get servicesCategory => isArabic ? 'الخدمات' : 'Services';
  String get featuredAnimalsRefreshing => isArabic
      ? 'نعرض اختيارات مميزة إلى أن يتم تحديث الإعلانات المباشرة.'
      : 'Showing curated picks while live featured listings refresh.';
  String get adoptionRefreshing => isArabic
      ? 'نعرض حالات تبنٍ مختارة إلى أن يتم تحديث الإعلانات المباشرة.'
      : 'Showing curated adoption spotlights while live adoption listings refresh.';
  String get discoverNearby => isArabic ? 'اكتشف القريب منك' : 'Discover nearby';
  String get discoverNearbySubtitle => isArabic
      ? 'افتح الخريطة لعرض إعلانات التبني والبيع القريبة منك.'
      : 'Open the map for local adoption and sale listings.';
  String get readyForAdoption =>
      isArabic ? 'جاهز للتبني' : 'Ready for adoption';
  String get pleaseSignInAgainToLoadNearby => isArabic
      ? 'يرجى تسجيل الدخول مرة أخرى لتحميل الأشخاص القريبين.'
      : 'Please sign in again to load nearby people.';
  String get locationNotSet => isArabic ? 'الموقع غير محدد' : 'Location not set';
  String get healthStatusLabel =>
      isArabic ? 'الحالة الصحية' : 'Health status';
  String get nameLabel => isArabic ? 'الاسم' : 'Name';
  String get forAdoptionOption =>
      isArabic ? 'للتبني' : 'For adoption';
  String get openPetProfileHint => isArabic
      ? 'افتح هذا الملف لمراجعة الصحة والموقع وبيانات التواصل.'
      : 'Open this profile to review health, location, and contact details.';
  String get selectPhotos =>
      isArabic ? 'اختر الصور' : 'Select photos';
  String get photosSelected =>
      isArabic ? 'تم اختيار الصور' : 'Photos selected';
  String photoSelectionSummary(int selected, int total) => isArabic
      ? '$selected / $total تم اختيارها من الهاتف'
      : '$selected / $total selected from your phone';
  String get fullLabel => isArabic ? 'مكتمل' : 'Full';
  String petFormOption(String value) {
    if (!isArabic) return value;
    return switch (value) {
      'Cat' => 'قط',
      'Dog' => 'كلب',
      'Bird' => 'طائر',
      'Other' => 'أخرى',
      'Mixed' => 'مختلط',
      'Persian' => 'شيرازي',
      'Siamese' => 'سيامي',
      'Golden Retriever' => 'جولدن ريتريفر',
      'German Shepherd' => 'جيرمن شيبرد',
      'Brown' => 'بني',
      'Black' => 'أسود',
      'White' => 'أبيض',
      'Gray' => 'رمادي',
      'Male' => 'ذكر',
      'Female' => 'أنثى',
      'Small' => 'صغير',
      'Medium' => 'متوسط',
      'Large' => 'كبير',
      'Calm' => 'هادئ',
      'Playful' => 'مرح',
      'Aggressive' => 'عدواني',
      'Shy' => 'خجول',
      'Healthy' => 'سليم',
      'Needs care' => 'يحتاج رعاية',
      'Recovering' => 'في مرحلة تعافٍ',
      'Special needs' => 'احتياجات خاصة',
      _ => value,
    };
  }

  String get adoptAFriend => isArabic
      ? 'ØªØ¨Ù†Ù‘Ù‰ ØµØ¯ÙŠÙ‚Ù‹Ø§'
      : 'Adopt a Friend';

  String get rareAnimalsForSale => isArabic
      ? 'Ø­ÙŠÙˆØ§Ù†Ø§Øª Ù†Ø§Ø¯Ø±Ø© Ù„Ù„Ø¨ÙŠØ¹'
      : 'Rare Animals for Sale';

  String get location => isArabic ? 'Ø§Ù„Ù…ÙˆÙ‚Ø¹' : 'Location';
}

extension AppCopyBuildContext on BuildContext {
  AppCopy get copy => AppCopy(Localizations.localeOf(this));
}
