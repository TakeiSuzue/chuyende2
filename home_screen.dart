import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
// Import các file trong dự án của bạn
import 'package:emotion_diary_app/services/database_helper.dart';
import 'package:emotion_diary_app/models/diary_model.dart';
import 'package:emotion_diary_app/screens/add_diary_screen.dart';
import 'package:emotion_diary_app/screens/stats_screen.dart'; // File biểu đồ mới

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Diary> _diaries = [];

  @override
  void initState() {
    super.initState();
    _refreshDiaries();
  }

  // Cập nhật lại danh sách từ Database
  _refreshDiaries() async {
    final data = await DatabaseHelper.instance.getAllDiaries();
    setState(() => _diaries = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Nhật Ký Của Tôi", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // Nút xem biểu đồ thống kê tuần
          IconButton(
            icon: Icon(Icons.bar_chart_rounded, color: Colors.blueAccent, size: 28),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => StatsScreen()));
              _refreshDiaries();
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _diaries.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 100, color: Colors.grey[300]),
            Text("Hôm nay bạn thế nào? Hãy ghi lại nhé!", style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _diaries.length,
        itemBuilder: (context, index) {
          final item = _diaries[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM, yyyy - HH:mm').format(DateTime.parse(item.date)),
                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () => _confirmDelete(item.id!),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Hiển thị Emoji
                      Text(item.emotion, style: TextStyle(fontSize: 28)),
                      SizedBox(width: 12),
                      // Hiển thị nội dung
                      Expanded(
                        child: Text(
                          item.content,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Hiển thị ảnh nếu có
                  if (item.imagePath != null) ...[
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(item.imagePath!),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  // Hiển thị vị trí nếu có
                  if (item.location != null && item.location != "Chưa lấy vị trí") ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location!,
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Đợi người dùng thêm xong rồi mới load lại danh sách
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDiaryScreen()));
          _refreshDiaries();
        },
        label: Text("Viết Nhật Ký", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Hàm xác nhận xóa kỷ niệm
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Xóa nhật ký?"),
        content: Text("Bạn có chắc chắn muốn xóa kỷ niệm này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Hủy")),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete(id);
              Navigator.pop(ctx);
              _refreshDiaries();
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}