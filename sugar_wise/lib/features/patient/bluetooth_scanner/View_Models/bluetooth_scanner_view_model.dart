import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

// 📡 الموديل الخاص بالجهاز
class BleDeviceModel {
  final BluetoothDevice device;
  final String name;
  int rssi;
  bool isConnected;
  bool isConnecting;

  BleDeviceModel({
    required this.device,
    required this.name,
    required this.rssi,
    this.isConnected = false,
    this.isConnecting = false,
  });

  IconData get signalIcon {
    if (rssi > -60) return Icons.signal_cellular_alt_rounded;
    if (rssi > -80) return Icons.signal_cellular_alt_2_bar_rounded;
    return Icons.signal_cellular_alt_1_bar_rounded;
  }

  Color get signalColor {
    if (rssi > -60) return Colors.green;
    if (rssi > -80) return Colors.orange;
    return Colors.redAccent;
  }

  String get signalText {
    if (rssi > -60) return "Strong Signal";
    if (rssi > -80) return "Medium Signal";
    return "Weak Signal";
  }
}

class BluetoothScannerViewModel extends ChangeNotifier {
  bool isScanning = false;
  List<BleDeviceModel> devices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  Future<void> startScanning(BuildContext context) async {
    // 💡 حماية إضافية: لا تقم ببدء بحث جديد إذا كان الرادار يعمل بالفعل
    if (FlutterBluePlus.isScanningNow) {
      debugPrint("⚠️ Scanner is already running.");
      return;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    if (!context.mounted) return;

    if (!statuses.values.every((status) => status.isGranted)) {
      _showToast(
        context,
        "Bluetooth and Location permissions are required!",
        isError: true,
      );
      return;
    }

    try {
      var state = await FlutterBluePlus.adapterState.first;
      if (!context.mounted) return;

      if (state != BluetoothAdapterState.on) {
        _showToast(context, "Please turn on Bluetooth!", isError: true);
        return;
      }
    } catch (e) {
      debugPrint("Adapter State Check Error: $e");
    }

    isScanning = true;
    devices.clear();
    notifyListeners();

    try {
      // بدء البحث
      debugPrint("🚀 Starting Bluetooth Scan...");
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      // 🔥 طباعة الخطأ الدقيق القادم من أندرويد لمعرفة السبب الحقيقي
      debugPrint("❌ Start Scan Error EXACT REASON: $e");

      if (!context.mounted) return;

      // عرض الخطأ للمستخدم بدلاً من الرسالة المبهمة
      _showToast(
        context,
        "Scan Error: ${e.toString().split(':').last}",
        isError: true,
      );
      isScanning = false;
      notifyListeners();
      return;
    }

    // الاستماع للأجهزة
    _scanSubscription?.cancel();
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String deviceName = r.device.platformName;

        // عرض الأجهزة المخفية بالماك أدرس للتأكد من عمل الرادار
        if (deviceName.isEmpty) {
          deviceName = "Unknown (${r.device.remoteId.str.substring(0, 8)})";
        }

        int safeRssi = -100;
        try {
          safeRssi = r.rssi;
        } catch (_) {}

        int existingIndex = devices.indexWhere(
          (d) => d.device.remoteId == r.device.remoteId,
        );
        if (existingIndex >= 0) {
          devices[existingIndex].rssi = safeRssi;
        } else {
          devices.add(
            BleDeviceModel(device: r.device, name: deviceName, rssi: safeRssi),
          );
        }
      }
      notifyListeners();
    });

    _isScanningSubscription?.cancel();
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
      if (isScanning != scanning) {
        isScanning = scanning;
        notifyListeners();
      }
    });
  } // 🔗 الاتصال الحقيقي بالجهاز

  // 🔗 الاتصال الحقيقي بالجهاز
  Future<void> connectToDevice(
    BuildContext context,
    BluetoothDevice device,
  ) async {
    var deviceIndex = devices.indexWhere(
      (d) => d.device.remoteId == device.remoteId,
    );
    if (deviceIndex == -1) return;

    if (isScanning) {
      await FlutterBluePlus.stopScan();
    }

    devices[deviceIndex].isConnecting = true;
    notifyListeners();

    try {
      await device.connect(
        timeout: const Duration(seconds: 10),
        mtu: null,
        autoConnect: false,
        license: License.free,
      );

      devices[deviceIndex].isConnecting = false;
      devices[deviceIndex].isConnected = true;

      if (!context.mounted) return;

      // 1. إظهار رسالة النجاح الخضراء
      _showToast(
        context,
        "Connected to ${device.platformName}!",
        isError: false,
      );

      notifyListeners();

      // 🔥 2. الانتظار نصف ثانية (ليقرأ المستخدم رسالة النجاح) ثم الانتقال للشاشة الرئيسية
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;

        // استخدمنا pushReplacement لكي لا يتمكن المستخدم من العودة لشاشة البلوتوث بزر الرجوع
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const PatientMain(), // 🚨 تأكد من عمل import لملف PatientMain في الأعلى
          ),
        );
      });
    } catch (e) {
      devices[deviceIndex].isConnecting = false;

      if (!context.mounted) return;
      _showToast(context, "Failed to connect: $e", isError: true);
      notifyListeners();
    }
  }

  // دالة مساعدة لظهور الرسائل
  void _showToast(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _isScanningSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
