import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:project2/features/admin_recipe_detail/data/api/admin_recipe_detail_api.dart';
import 'package:project2/features/admin_recipe_detail/presentation/bloc/admin_recipe_detail_bloc.dart';
import 'package:project2/features/admin_recipe_detail/presentation/pages/admin_recipe_detail_page.dart';
import 'package:project2/features/recipe_detail/data/api/recipe_detail_api.dart';
import 'package:project2/features/recipe_detail/presentation/bloc/recipe_detail_bloc.dart';
import 'package:project2/features/recipe_detail/presentation/pages/recipe_detail_page.dart';
import 'package:project2/features/shopping_cart/presentation/pages/shopping_list_page.dart';

import '../../../core/utils/token_storage.dart';
import 'api/fcm_token_api.dart';

const String _notificationChannelId = 'cooking_alerts_v2';
const MethodChannel _nativeChannel =
    MethodChannel('com.example.project2/notifications');

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

bool _localNotificationsReady = false;
bool _timeZonesReady = false;

void _ensureTimeZones() {
  if (_timeZonesReady) return;
  tz_data.initializeTimeZones();
  _timeZonesReady = true;
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

@pragma('vm:entry-point')
void onNotificationTapBackground(NotificationResponse response) {}

Future<void> _ensureLocalNotifications() async {
  if (_localNotificationsReady) return;

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _localNotifications.initialize(
    const InitializationSettings(android: androidSettings),
    onDidReceiveNotificationResponse: (response) {
      FcmService.openFromPayload(response.payload);
    },
    onDidReceiveBackgroundNotificationResponse: onNotificationTapBackground,
  );

  const channel = AndroidNotificationChannel(
    _notificationChannelId,
    'إشعارات التطبيق',
    description: 'إشعارات CookingApp',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  final android = _localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await android?.createNotificationChannel(channel);
  await android?.requestNotificationsPermission();
  await android?.requestExactAlarmsPermission();

  _localNotificationsReady = true;
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  await _ensureLocalNotifications();

  final type = message.data['type']?.toString();
  final rawTitle = message.notification?.title ??
      message.data['title']?.toString() ??
      '';
  final rawBody = message.notification?.body ??
      message.data['body']?.toString() ??
      message.data['message']?.toString() ??
      '';

  final title =
      _isGenericText(rawTitle) ? _titleFromType(type) : rawTitle;
  final body = _isGenericText(rawBody) ? _bodyFromType(type) : rawBody;

  await _localNotifications.show(
    message.messageId?.hashCode ?? message.hashCode,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        _notificationChannelId,
        'إشعارات التطبيق',
        channelDescription: 'إشعارات CookingApp',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    payload: jsonEncode(message.data),
  );

  try {
    await _nativeChannel.invokeMethod('cancelGenericNotifications');
  } catch (_) {}
}

bool _isGenericText(String text) {
  final normalized = text
      .trim()
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .toLowerCase();
  if (normalized.isEmpty) return true;
  return normalized.contains('اشعار جديد') ||
      normalized.contains('لديك اشعار') ||
      normalized.contains('وصلك اشعار') ||
      normalized.contains('new notification') ||
      normalized == 'notification';
}

String _titleFromType(String? type) {
  final typeLower = (type ?? '').toLowerCase();
  if (typeLower.contains('like')) return 'إعجاب جديد';
  if (typeLower.contains('comment')) return 'تعليق جديد';
  if (typeLower.contains('reject') ||
      typeLower.contains('declin') ||
      typeLower.contains('رفض')) {
    return 'تم رفض منشورك';
  }
  if (typeLower.contains('approv') ||
      typeLower.contains('accept') ||
      typeLower.contains('قبول')) {
    return 'تم قبول منشورك';
  }
  if (typeLower.contains('shopping')) return 'تذكير قائمة التسوق';
  if (typeLower.contains('recipe') || typeLower.contains('published')) {
    return 'وصفة جديدة';
  }
  return 'إشعار جديد';
}

String _bodyFromType(String? type) {
  final typeLower = (type ?? '').toLowerCase();
  if (typeLower.contains('like')) return 'شخص أعجب بمنشورك';
  if (typeLower.contains('comment')) return 'شخص علّق على منشورك';
  if (typeLower.contains('reject') ||
      typeLower.contains('declin') ||
      typeLower.contains('رفض')) {
    return 'الأدمن رفض منشورك';
  }
  if (typeLower.contains('approv') ||
      typeLower.contains('accept') ||
      typeLower.contains('قبول')) {
    return 'الأدمن قبل منشورك وصار ظاهر بالمجتمع';
  }
  if (typeLower.contains('shopping')) {
    return 'لسا ما اشتريت المكونات اللي بقائمة التسوق';
  }
  if (typeLower.contains('recipe') || typeLower.contains('published')) {
    return 'تم نشر وصفة جديدة';
  }
  return 'وصلك إشعار جديد';
}

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static bool _initialized = false;
  static RemoteMessage? _pendingMessage;
  static Map<String, dynamic>? _pendingData;
  static VoidCallback? onForegroundMessage;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _ensureLocalNotifications();

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _nativeChannel.setMethodCallHandler((call) async {
      if (call.method == 'onLaunchData' && call.arguments is Map) {
        openFromData(Map<String, dynamic>.from(call.arguments as Map));
      }
    });

    _messaging.onTokenRefresh.listen((token) async {
      if (await TokenStorage.isLoggedIn()) {
        await _sendToken(token);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      await _showLocalNotification(message);
      onForegroundMessage?.call();
    });

    FirebaseMessaging.onMessageOpenedApp.listen(openFromRemoteMessage);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _pendingMessage = initial;
    }

    final launchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      _pendingData =
          _decodePayload(launchDetails!.notificationResponse?.payload);
    }

    try {
      final nativeLaunch =
          await _nativeChannel.invokeMethod<Map<dynamic, dynamic>>('getLaunchData');
      if (nativeLaunch != null) {
        _pendingData = Map<String, dynamic>.from(nativeLaunch);
      }
    } catch (_) {}
  }

  static Future<void> registerToken() async {
    try {
      if (!await TokenStorage.isLoggedIn()) return;

      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final fcmToken = await _messaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      print("FCM TOKEN = $fcmToken");
      await _sendToken(fcmToken);
    } catch (e) {
      print("FCM register error: $e");
    }
  }

  static Future<void> openPendingNotification() async {
    final pending = _pendingMessage;
    if (pending != null) {
      _pendingMessage = null;
      openFromRemoteMessage(pending);
      return;
    }

    var pendingData = _pendingData;
    if (pendingData == null) {
      try {
        final nativeLaunch = await _nativeChannel
            .invokeMethod<Map<dynamic, dynamic>>('getLaunchData');
        if (nativeLaunch != null) {
          pendingData = Map<String, dynamic>.from(nativeLaunch);
        }
      } catch (_) {}
    }

    if (pendingData != null) {
      _pendingData = null;
      openFromData(pendingData);
    }
  }

  static void openFromRemoteMessage(RemoteMessage message) {
    openFromData(message.data);
  }

  static void openFromPayload(String? payload) {
    final data = _decodePayload(payload);
    if (data == null) return;
    openFromData(data);
  }

  static void openFromData(Map<String, dynamic> data) {
    final type = (data['type'] ?? '').toString();
    final postId = _parseInt(
      data['post_id'] ?? data['postId'] ?? data['postable_id'],
    );
    final recipeId = _parseInt(
      data['recipe_id'] ?? data['recipeId'],
    );

    openNotificationTarget(
      type: type,
      postId: postId,
      recipeId: recipeId,
    );
  }

  static void openNotificationTarget({
    String type = '',
    int? postId,
    int? recipeId,
  }) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    final typeLower = type.toLowerCase();
    if (typeLower.contains('shopping')) {
      nav.push(
        MaterialPageRoute(builder: (_) => const ShoppingListPage()),
      );
      return;
    }
    final isModeration = typeLower.contains('approv') ||
        typeLower.contains('reject') ||
        typeLower.contains('accept') ||
        typeLower.contains('declin');
    final wantsRecipe = !isModeration &&
        (typeLower.contains('recipe') || typeLower.contains('published'));

    if (recipeId != null &&
        recipeId > 0 &&
        (wantsRecipe || postId == null)) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminRecipeDetailBloc(AdminRecipeDetailApi()),
            child: AdminRecipeDetailPage(id: recipeId),
          ),
        ),
      );
      return;
    }

    if (postId != null && postId > 0) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RecipeDetailBloc(RecipeDetailApi()),
            child: RecipeDetailPage(id: postId),
          ),
        ),
      );
    }
  }

  static Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static Future<void> _sendToken(String fcmToken) async {
    try {
      await FcmTokenApi().updateFcmToken(fcmToken);
    } catch (e) {
      print("FCM send token error: $e");
    }
  }

  static int _shoppingReminderId(int itemId) => 910000 + itemId;

  static Future<void> scheduleShoppingReminder({
    required int itemId,
    required String ingredientName,
  }) async {
    try {
      await _ensureLocalNotifications();
      _ensureTimeZones();

      final name =
          ingredientName.trim().isEmpty ? 'هاد المكون' : ingredientName.trim();

      await _localNotifications.zonedSchedule(
        _shoppingReminderId(itemId),
        'تذكير قائمة التسوق',
        'لسا ما اشتريت $name',
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _notificationChannelId,
            'إشعارات التطبيق',
            channelDescription: 'إشعارات CookingApp',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode({'type': 'shopping', 'item_id': itemId}),
      );
    } catch (e) {
      print("Shopping reminder schedule error: $e");
    }
  }

  static Future<void> cancelShoppingReminders(List<int> itemIds) async {
    await _ensureLocalNotifications();
    for (final itemId in itemIds) {
      await _localNotifications.cancel(_shoppingReminderId(itemId));
    }
  }
}
