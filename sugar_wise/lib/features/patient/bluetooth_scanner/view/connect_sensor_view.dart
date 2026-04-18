import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/View_Models/bluetooth_scanner_view_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

class ConnectSensorView extends StatefulWidget {
  const ConnectSensorView({super.key});

  @override
  State<ConnectSensorView> createState() => _ConnectSensorViewState();
}

class _ConnectSensorViewState extends State<ConnectSensorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  // 🔥 المتغير الجديد للتحكم في ظهور رسالة المساعدة
  bool _isHelpVisible = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BluetoothScannerViewModel>(
        context,
        listen: false,
      ).startScanning(context);
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BluetoothScannerViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1D2939);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "connect_sensor".tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 🔥 1. تغليف الشاشة لكي نلتقط أي نقرة في مكان فارغ ونخفي الرسالة
      body: GestureDetector(
        behavior: HitTestBehavior
            .translucent, // لضمان التقاط النقرات على المساحات الفارغة
        onTap: () {
          if (_isHelpVisible) {
            setState(() {
              _isHelpVisible = false;
            });
          }
        },
        child: RefreshIndicator(
          color: const Color(0xFF2F66D0),
          backgroundColor: Theme.of(context).cardColor,
          onRefresh: () async {
            await viewModel.startScanning(context);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientMainLayout(),
                      ),
                    );
                  },
                  child: Text('Demo Entry'),
                ),

                // أنيميشن النبضات
                SizedBox(
                  height: 200,
                  child: AnimatedBuilder(
                    animation: _rippleController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: RipplePainter(
                          animationValue: viewModel.isScanning
                              ? _rippleController.value
                              : 0.0,
                          color: const Color(0xFF2F66D0),
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F66D0),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2F66D0,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bluetooth,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  viewModel.isScanning
                      ? "searching_devices".tr()
                      : "search_complete".tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "make_sure_sensor_nearby".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // قائمة الأجهزة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "found_devices".tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (viewModel.isScanning)
                            Text(
                              "scanning".tr(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F66D0),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.devices.length,
                        itemBuilder: (context, index) {
                          return _buildDeviceCard(
                            context,
                            viewModel.devices[index],
                            viewModel,
                            isDark,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 3. الفوتر (المساعدة)
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 10),
                  child: Column(
                    children: [
                      // 🔥 2. مربع الشرح الذي يظهر فوق الكلمة بنعومة
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _isHelpVisible
                            ? Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                  left: 30,
                                  right: 30,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF2F66D0,
                                    ).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  // يمكنك استبدال هذا النص بمفتاح الترجمة لاحقاً إذا أردت
                                  "Make sure the sensor is fully charged, turned on, and within 3 meters. Keep it away from other Bluetooth devices to avoid interference.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(), // مساحة فارغة عندما يكون مخفياً
                      ),

                      // 🔥 3. الزر الذي يقلب حالة الظهور والاختفاء
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHelpVisible = !_isHelpVisible;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "cant_find_device".tr(),
                              style: const TextStyle(
                                color: Color(0xFF2F66D0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFF2F66D0),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ensure_bluetooth_enabled".tr(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    BuildContext context,
    BleDeviceModel device,
    BluetoothScannerViewModel viewModel,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: Colors.grey.shade800)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bluetooth, color: Color(0xFF2F66D0)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      device.signalIcon,
                      color: device.signalColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      device.signalText,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: device.isConnected || device.isConnecting
                  ? null
                  : () => viewModel.connectToDevice(context, device.device),
              style: ElevatedButton.styleFrom(
                backgroundColor: device.isConnected
                    ? Colors.green
                    : (isDark
                          ? const Color(0xFF2F66D0)
                          : const Color(0xFF2F66D0)),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: device.isConnecting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      device.isConnected ? "connected".tr() : "connect".tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RipplePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (animationValue == 0.0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    _drawRipple(canvas, center, maxRadius, animationValue);
    _drawRipple(canvas, center, maxRadius, (animationValue + 0.3) % 1.0);
    _drawRipple(canvas, center, maxRadius, (animationValue + 0.6) % 1.0);
  }

  void _drawRipple(
    Canvas canvas,
    Offset center,
    double maxRadius,
    double value,
  ) {
    final radius = maxRadius * value;
    final opacity = (1.0 - value).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = color.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
