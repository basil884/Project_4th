import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// ✅ تأكد من أن هذا المسار يطابق مكان الـ ViewModel لديك
import 'package:sugar_wise/features/patient/monitoring_patient/view_model/monitoring_view_model.dart';

class MonitoringView extends StatelessWidget {
  const MonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MonitoringViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChartCard(context, viewModel),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddLogBottomSheet(context, viewModel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F66D0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xFF2F66D0).withValues(alpha: 0.4),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Readings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRecentReadingsList(viewModel.recentReadings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, MonitoringViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sugar Wise",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Glucose Analysis Report",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => viewModel.generateAndSavePdf(context),
                icon: const Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 16,
                  color: Color(0xFFE65100),
                ),
                label: const Text(
                  "Save PDF",
                  style: TextStyle(color: Color(0xFFE65100), fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Glucose Trends (${viewModel.selectedFilter})",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: ["Day", "Week", "Mo"].map((filter) {
                    bool isSelected = viewModel.selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => viewModel.setFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 40,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  // ✅ إغلاق الجوانب بشكل آمن
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 0),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32, // ✅ تم تكبير المساحة لتجنب الخطأ
                      interval: 2, // ✅ تحديد المسافات برمجياً بذكاء
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        );
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = '10 AM';
                            break;
                          case 2:
                            text = '1 PM';
                            break;
                          case 4:
                            text = '4 PM';
                            break;
                          case 6:
                            text = '8 PM';
                            break;
                          case 8:
                            text = '10 PM';
                            break;
                          default:
                            return const SizedBox.shrink();
                        }
                        // 🔥 السحر هنا: تغليف النص بـ SideTitleWidget هو ما يمنع الكراش تماماً!
                        // 🔥 السحر هنا: تغليف النص بـ SideTitleWidget هو ما يمنع الكراش تماماً!
                        return SideTitleWidget(
                          meta:
                              meta, // ✅ التعديل الصحيح: استخدام meta بدلاً من axisSide
                          space: 8,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 8,
                minY: 60,
                maxY: 160,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 80),
                      FlSpot(2, 140),
                      FlSpot(3, 110),
                      FlSpot(5, 70),
                      FlSpot(7, 110),
                      FlSpot(8, 100),
                    ],
                    isCurved: true,
                    color: const Color(0xFFF97316),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (LineBarSpot touchedSpot) =>
                        const Color(0xFF1D2939),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots
                          .map(
                            (spot) => LineTooltipItem(
                              "${spot.y.toInt()} mg/dL\nLevel",
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReadingsList(List<SugarReading> readings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "TIME",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "READING",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "STATUS",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ...readings.map((reading) => _buildReadingRow(reading)),
        ],
      ),
    );
  }

  Widget _buildReadingRow(SugarReading reading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              reading.time,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  "${reading.value}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "mg/dL",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: reading.statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  reading.status,
                  style: TextStyle(
                    color: reading.statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLogBottomSheet(
    BuildContext context,
    MonitoringViewModel viewModel,
  ) {
    String selectedMeal = "Breakfast";
    String selectedUnit = viewModel.glucoseUnits[0];
    String selectedInsulin = viewModel.insulinTypes[0];
    String selectedDefaultFood = viewModel.defaultFoods[0];

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    final TextEditingController glucoseCtrl = TextEditingController();
    final TextEditingController customFoodCtrl = TextEditingController();

    bool isGlucoseEmptyError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add New Health Log",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color(0xFF1D2939),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.blueGrey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildLogInputField(
                                  "GLUCOSE LEVEL",
                                  "e.g., 120",
                                  prefixIcon: Icons.water_drop_outlined,
                                  controller: glucoseCtrl,
                                  hasError: isGlucoseEmptyError,
                                  errorText: "Required field",
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 2,
                                child: _buildLogDropdownField(
                                  "UNIT",
                                  selectedUnit,
                                  viewModel.glucoseUnits,
                                  (val) =>
                                      setModalState(() => selectedUnit = val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _buildLogInputField(
                                  "DATE",
                                  DateFormat("dd/MM/yyyy").format(selectedDate),
                                  suffixIcon: Icons.calendar_month,
                                  readOnly: true,
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                    if (picked != null) {
                                      setModalState(
                                        () => selectedDate = picked,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildLogInputField(
                                  "TIME",
                                  selectedTime.format(context),
                                  suffixIcon: Icons.access_time,
                                  readOnly: true,
                                  onTap: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: selectedTime,
                                        );
                                    if (picked != null) {
                                      setModalState(
                                        () => selectedTime = picked,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          _buildSectionHeader(Icons.restaurant, "My Foods"),
                          _buildMealSelectors(
                            selectedMeal,
                            (val) => setModalState(() => selectedMeal = val),
                          ),
                          const SizedBox(height: 15),

                          _buildLogDropdownField(
                            "",
                            selectedDefaultFood,
                            viewModel.defaultFoods,
                            (val) =>
                                setModalState(() => selectedDefaultFood = val!),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: _buildLogTextField(
                                  customFoodCtrl,
                                  "Custom...",
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (customFoodCtrl.text.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${customFoodCtrl.text} added to meal!",
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                    setModalState(() => customFoodCtrl.clear());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffF97316),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          _buildSectionHeader(
                            Icons.medication_outlined,
                            "Insulin & Medication",
                            iconColor: const Color(0xFF9333EA),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(
                                  0xFF9333EA,
                                ).withValues(alpha: 0.2),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(
                                0xFF9333EA,
                              ).withValues(alpha: 0.05),
                            ),
                            child: _buildLogDropdownField(
                              "",
                              selectedInsulin,
                              viewModel.insulinTypes,
                              (val) =>
                                  setModalState(() => selectedInsulin = val!),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (glucoseCtrl.text.trim().isEmpty) {
                            setModalState(() {
                              isGlucoseEmptyError = true;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Please enter your glucose level!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.75,
                                  left: 20,
                                  right: 20,
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                          setModalState(() {
                            isGlucoseEmptyError = false;
                          });

                          int glucoseValue =
                              int.tryParse(glucoseCtrl.text.trim()) ?? 0;
                          viewModel.saveLog(
                            glucoseValue: glucoseValue,
                            unit: selectedUnit,
                            date: DateFormat("dd/MM/yyyy").format(selectedDate),
                            time: selectedTime.format(context),
                            meal: selectedMeal,
                            insulin: selectedInsulin == "Select insulin..."
                                ? null
                                : selectedInsulin,
                          );

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ Reading saved successfully!"),
                              backgroundColor: Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F66D0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Save Log",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // Helper Widgets
  // ==========================================
  Widget _buildSectionHeader(
    IconData icon,
    String title, {
    Color iconColor = const Color(0xFFE65100),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const Spacer(),
          const Icon(Icons.close, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildLogInputField(
    String label,
    String value, {
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextEditingController? controller,
    bool hasError = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: hasError ? Colors.red : const Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError ? Colors.red : Colors.grey.shade200,
                width: hasError ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                if (prefixIcon != null)
                  Icon(
                    prefixIcon,
                    color: hasError ? Colors.red : const Color(0xFF2F66D0),
                    size: 18,
                  ),
                if (prefixIcon != null) const SizedBox(width: 10),
                Expanded(
                  child: controller == null
                      ? Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        )
                      : TextField(
                          controller: controller,
                          readOnly: readOnly,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            hintText: "e.g. 120",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                ),
                if (suffixIcon != null)
                  Icon(suffixIcon, color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLogDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667085),
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffF97316)),
        ),
      ),
    );
  }

  Widget _buildMealSelectors(String selectedMeal, Function(String) onSelected) {
    List<String> meals = ["Breakfast", "Lunch", "Dinner", "Extra"];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: meals.map((meal) {
          bool isSelected = selectedMeal == meal;
          return GestureDetector(
            onTap: () => onSelected(meal),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffF97316)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                meal,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
