class AppConstants {
  AppConstants._();

  static const String appName = 'Pair';

  /// Discreet label shown in the UI instead of explicit health terms.
  static const String healthCodeWord = 'Phoenix';

  static const Duration pairCodeExpiration = Duration(minutes: 10);
  static const Duration foregroundLocationInterval = Duration(seconds: 30);
  static const double proximityNotifyMeters = 1000;
  static const Duration typingIndicatorTimeout = Duration(seconds: 3);
  static const Duration presenceHeartbeatInterval = Duration(seconds: 30);

  static const int chatPageSize = 30;

  static const String usersCollection = 'users';
  static const String pairsCollection = 'pairs';
  static const String pairCodesCollection = 'pairCodes';
  static const String locationsSubcollection = 'locations';
  static const String messagesSubcollection = 'messages';
  static const String presenceSubcollection = 'presence';
  static const String typingSubcollection = 'typing';
  static const String readStatusSubcollection = 'readStatus';
  static const String groceryItemsSubcollection = 'groceryItems';
  static const String periodDataSubcollection = 'periodData';

  static const Duration periodSyncInterval = Duration(hours: 1);
  static const int periodLookbackDays = 90;
}
