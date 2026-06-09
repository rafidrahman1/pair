class AppConstants {
  AppConstants._();

  static const String appName = 'Pair';

  static const Duration pairCodeExpiration = Duration(minutes: 10);
  static const Duration foregroundLocationInterval = Duration(seconds: 30);
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
}
