import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/laptests/lab_tests_view_model/lab_tests_view_model.dart';
import 'package:sugar_wise/features/patient/laptests/model/lap_test_model.dart';

class LabTestsView extends StatelessWidget {
  const LabTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LabTestsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Lab Tests & Reports",
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Store and organize your medical analysis results.",
              style: TextStyle(color: Color(0xFF667085), fontSize: 14),
            ),
            const SizedBox(height: 25),

            _buildUploadButton(context, viewModel),
            const SizedBox(height: 30),

            // عرض التقارير
            ...viewModel.reports.map(
              (report) => _buildReportCard(context, viewModel, report),
            ),
            const SizedBox(height: 10),

            _buildScanSection(context, viewModel),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, LabTestsViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () => viewModel.uploadReport(context),
        icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
        label: const Text(
          "Upload Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F66D0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    LabTestsViewModel viewModel,
    ReportModel report,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: report.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(report.icon, color: report.iconColor, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              report.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D2939),
                              ),
                            ),
                          ),
                          Text(
                            report.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(
                            report.type,
                            Colors.grey.shade600,
                            Colors.grey.shade100,
                          ),
                          const SizedBox(width: 8),
                          _buildTag(
                            report.status,
                            report.statusColor,
                            report.statusColor.withValues(alpha: 0.15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: report.detailsPrefix,
                    style: const TextStyle(
                      color: Color(0xFF1D2939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: report.detailsText),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade200),

          // 🔥 الأزرار السفلية (View, Download, Options)
          // 🔥 الأزرار السفلية (View, Download, Options)
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => viewModel.viewReport(context, report),
                  child: Text(
                    "View ${report.type == 'PDF' ? 'PDF' : 'Image'}",
                    style: const TextStyle(
                      color: Color(0xFF2F66D0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade200),

              // ⬇️ زر الـ Download مخصص للتحميل فقط
              Expanded(
                child: TextButton(
                  onPressed: () => viewModel.downloadReport(context, report),
                  child: const Text(
                    "Download",
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade200),

              // 🔥 زر الثلاث نقاط مع القائمة المنسدلة (Share & Delete)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmationDialog(context, viewModel, report);
                  } else if (value == 'share') {
                    // 📤 استدعاء دالة المشاركة المخصصة هنا
                    viewModel.shareReport(context, report);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: Colors.black87,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text("Share"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildScanSection(BuildContext context, LabTestsViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2F66D0).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2F66D0).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Color(0xFF2F66D0),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Need to add more?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2939),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You can scan your physical reports using your phone camera for automatic organization.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF667085), fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => viewModel.startScanning(context),
            child: const Text(
              "Start Scanning",
              style: TextStyle(
                color: Color(0xFF2F66D0),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 نافذة التأكيد قبل الحذف (أفضل ممارسة UX)
  void _showDeleteConfirmationDialog(
    BuildContext context,
    LabTestsViewModel viewModel,
    ReportModel report,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                "Delete Report",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '${report.title}'? This action cannot be undone.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext), // إغلاق النافذة فقط
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // إغلاق النافذة أولاً
                viewModel.deleteReport(context, report); // تنفيذ الحذف
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
