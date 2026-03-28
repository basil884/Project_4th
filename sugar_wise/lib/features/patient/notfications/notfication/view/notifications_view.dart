import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/notfications/notfication/model/notification_model.dart';
import 'package:sugar_wise/features/patient/notfications/notfication/view_model/notifications_view_model.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء نظيفة
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الهيدر (زر الرجوع + Mark as read)
            _buildHeader(context, viewModel),

            // 2. النصوص العلوية
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2939),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Stay updated with your patients and clinic activities",
                style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
            ),
            const SizedBox(height: 20),

            // 3. التبويبات (All / Unread)
            _buildTabs(viewModel),
            Divider(height: 1, color: Colors.grey.shade200),

            // 4. قائمة الإشعارات
            Expanded(
              child: viewModel.filteredNotifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No notifications here! 🎉",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: viewModel.filteredNotifications.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey.shade100),
                      itemBuilder: (context, index) {
                        return _buildNotificationTile(
                          viewModel,
                          viewModel.filteredNotifications[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🧩 أجزاء الواجهة المساعدة
  // ==========================================

  // الهيدر العلوي
  Widget _buildHeader(BuildContext context, NotificationsViewModel viewModel) {
    // إذا كان العداد 0، نجعل زر Mark as read رمادياً باهتاً
    bool hasUnread = viewModel.unreadCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF667085)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton.icon(
            onPressed: hasUnread ? () => viewModel.markAllAsRead() : null,
            icon: Icon(
              Icons.done_all,
              color: hasUnread ? const Color(0xFF2F66D0) : Colors.grey,
              size: 18,
            ),
            label: Text(
              "Mark as read",
              style: TextStyle(
                color: hasUnread ? const Color(0xFF2F66D0) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // التبويبات مع العداد
  Widget _buildTabs(NotificationsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildTabItem(
            "All",
            viewModel.selectedTab == 'All',
            () => viewModel.setTab('All'),
          ),
          const SizedBox(width: 25),
          _buildTabItem(
            "Unread",
            viewModel.selectedTab == 'Unread',
            () => viewModel.setTab('Unread'),
            badgeCount: viewModel.unreadCount, // إرسال العداد الحقيقي
          ),
        ],
      ),
    );
  }

  // تصميم تبويب واحد
  Widget _buildTabItem(
    String title,
    bool isSelected,
    VoidCallback onTap, {
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF2F66D0)
                      : const Color(0xFF667085),
                ),
              ),
              // عرض الـ Badge الأحمر فقط إذا كان العدد أكبر من صفر
              if (badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          // الخط الأزرق تحت التبويب المختار
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2F66D0) : Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تصميم الإشعار الواحد
  Widget _buildNotificationTile(
    NotificationsViewModel viewModel,
    NotificationModel notification,
  ) {
    return InkWell(
      onTap: () =>
          viewModel.markAsRead(notification.id), // 🔥 عند الضغط يصبح مقروءاً
      child: Container(
        // خلفية زرقاء خفيفة جداً للغير مقروء، وبيضاء للمقروء
        color: notification.isRead
            ? Colors.white
            : const Color(0xFF2F66D0).withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأيقونة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notification.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),

            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          // 🔥 النص يكون عريض جداً (Bold) إذا كان غير مقروء
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w900,
                            color: const Color(0xFF1D2939),
                          ),
                        ),
                      ),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 11,
                          // 🔥 لون الوقت يكون أزرق بارز إذا كان غير مقروء
                          color: notification.isRead
                              ? Colors.grey.shade500
                              : const Color(0xFF2F66D0),
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      // لون الوصف يغمق قليلاً إذا كان غير مقروء
                      color: notification.isRead
                          ? const Color(0xFF667085)
                          : const Color(0xFF344054),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 السحر هنا: نقطة زرقاء (Dot) للفت الانتباه تظهر فقط للإشعارات غير المقروءة
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(left: 12, top: 4),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF2F66D0),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
