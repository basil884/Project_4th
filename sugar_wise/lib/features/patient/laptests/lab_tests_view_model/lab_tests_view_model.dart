import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sugar_wise/features/patient/laptests/model/lap_test_model.dart';

class LabTestsViewModel extends ChangeNotifier {
  final List<ReportModel> _reports = [
    ReportModel(
      title: "HBA1C Quarterly Report",
      date: "2024-01-15",
      type: "PDF",
      status: "Stable",
      statusColor: const Color(0xFF10B981),
      detailsPrefix: "Result: ",
      detailsText: "6.5%. Doctor said it is stable.",
      icon: Icons.picture_as_pdf,
      iconColor: Colors.redAccent,
      filePath: null,
    ),
    ReportModel(
      title: "CBC Blood Test",
      date: "2023-11-20",
      type: "IMAGE",
      status: "Routine",
      statusColor: const Color(0xFF2F66D0),
      detailsPrefix: "Details: ",
      detailsText: "Routine checkup. Iron levels are good.",
      icon: Icons.image_outlined,
      iconColor: Colors.black87,
      filePath: null,
    ),
  ];

  List<ReportModel> get reports => _reports;

  Future<void> uploadReport(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String extension = file.extension?.toLowerCase() ?? '';
        String type = 'DOC';
        IconData icon = Icons.insert_drive_file;
        Color iconColor = Colors.grey;

        if (extension == 'pdf') {
          type = 'PDF';
          icon = Icons.picture_as_pdf;
          iconColor = Colors.redAccent;
        } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
          type = 'IMAGE';
          icon = Icons.image_outlined;
          iconColor = Colors.blueAccent;
        }

        double sizeInMb = file.size / (1024 * 1024);

        ReportModel newReport = ReportModel(
          title: file.name,
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          type: type,
          status: "New",
          statusColor: const Color(0xFFF59E0B),
          detailsPrefix: "Size: ",
          detailsText: "${sizeInMb.toStringAsFixed(2)} MB",
          icon: icon,
          iconColor: iconColor,
          filePath: file.path,
        );

        _reports.insert(0, newReport);
        notifyListeners();
        _showMessage(context, "✅ File uploaded successfully!");
      }
    } catch (e) {
      _showMessage(context, "❌ Error uploading file.", isSuccess: false);
    }
  }

  void viewReport(BuildContext context, ReportModel report) async {
    if (report.filePath != null) {
      final result = await OpenFilex.open(report.filePath!);
      if (result.type != ResultType.done) {
        _showMessage(context, "❌ Could not open this file.", isSuccess: false);
      }
    } else {
      _showMessage(
        context,
        "⚠️ This is a demo file. Upload a real file to view it.",
        isSuccess: false,
      );
    }
  }

  // ⬇️ زر التحميل (Download) المخصص (حفظ فقط بدون مشاركة)
  // ⬇️ زر التحميل (Download) الحقيقي
  void downloadReport(BuildContext context, ReportModel report) async {
    if (report.filePath == null) {
      _showMessage(
        context,
        "⚠️ This is a demo file. Upload a real file to download.",
        isSuccess: false,
      );
      return;
    }

    try {
      _showMessage(
        context,
        "⏳ Downloading ${report.title}...",
        isSuccess: true,
      );

      // 1. طلب صلاحية التخزين من المستخدم (إذا كان أندرويد)
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      // 2. تحديد مسار مجلد التنزيلات (Downloads) بناءً على نوع الهاتف
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        // مسار التنزيلات الثابت في الأندرويد
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        // مسار المستندات في الآيفون
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (downloadsDirectory != null && await downloadsDirectory.exists()) {
        // 3. نسخ الملف من الذاكرة المؤقتة إلى الهاتف الحقيقي
        File sourceFile = File(report.filePath!);
        String newPath = "${downloadsDirectory.path}/${report.title}";

        // 💡 خطوة ذكية: التأكد من عدم وجود ملف بنفس الاسم لتجنب استبداله
        int counter = 1;
        while (await File(newPath).exists()) {
          int dotIndex = report.title.lastIndexOf('.');
          String name = dotIndex != -1
              ? report.title.substring(0, dotIndex)
              : report.title;
          String ext = dotIndex != -1 ? report.title.substring(dotIndex) : '';
          newPath = "${downloadsDirectory.path}/${name}_($counter)$ext";
          counter++;
        }

        // عملية النسخ الفعلي للملف
        await sourceFile.copy(newPath);

        // رسالة النجاح
        if (context.mounted) {
          _showMessage(context, "✅ Saved successfully to Downloads!\n$newPath");
        }
      } else {
        _showMessage(
          context,
          "❌ Could not find Downloads folder.",
          isSuccess: false,
        );
      }
    } catch (e) {
      _showMessage(context, "❌ Error saving file: $e", isSuccess: false);
    }
  }

  // 📤 زر المشاركة (Share) المخصص (يفتح نافذة الواتساب/الإيميل)
  void shareReport(BuildContext context, ReportModel report) async {
    if (report.filePath != null) {
      await Share.shareXFiles([
        XFile(report.filePath!),
      ], text: 'Medical Report: ${report.title}');
    } else {
      _showMessage(
        context,
        "⚠️ This is a demo file. Upload a real file to share.",
        isSuccess: false,
      );
    }
  }

  void deleteReport(BuildContext context, ReportModel report) {
    _reports.remove(report);
    notifyListeners();
    _showMessage(context, "🗑️ Report deleted successfully!");
  }

  void startScanning(BuildContext context) {
    _showMessage(context, "📸 Opening camera to scan document...");
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF10B981)
            : const Color(0xFFF97316),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
