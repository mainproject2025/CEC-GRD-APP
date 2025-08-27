import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model Classes
class ExamInfo {
  final String subject;
  final String subjectCode;
  final String date;
  final String time;
  final String duration;
  final String roomNumber;
  final String hallTicketNumber;
  final String examType;
  final ExamStatus status;

  ExamInfo({
    required this.subject,
    required this.subjectCode,
    required this.date,
    required this.time,
    required this.duration,
    required this.roomNumber,
    required this.hallTicketNumber,
    required this.examType,
    required this.status,
  });
}

enum ExamStatus { upcoming, ongoing, completed }

// GetX Controller
class ExamController extends GetxController {
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var examList = <ExamInfo>[].obs;
  var studentName = 'John Doe'.obs;
  var studentId = 'ST2024001'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExamData();
  }

  void loadExamData() {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      examList.value = [
        ExamInfo(
          subject: 'Data Structures & Algorithms',
          subjectCode: 'CS301',
          date: 'Today',
          time: '10:00 AM - 1:00 PM',
          duration: '3 Hours',
          roomNumber: 'Room 101',
          hallTicketNumber: 'HT2024001',
          examType: 'Theory',
          status: ExamStatus.upcoming,
        ),
        ExamInfo(
          subject: 'Database Management Systems',
          subjectCode: 'CS302',
          date: 'Today',
          time: '2:30 PM - 4:30 PM',
          duration: '2 Hours',
          roomNumber: '',
          hallTicketNumber: 'HT2024002',
          examType: 'Practical',
          status: ExamStatus.upcoming,
        ),
         
      ];
      isLoading.value = false;
    });
  }

  void refreshExams() {
    loadExamData();
  }

  Color getStatusColor(ExamStatus status) {
    switch (status) {
      case ExamStatus.upcoming:
        return Color(0xFF5B5CE6);
      case ExamStatus.ongoing:
        return Colors.orange;
      case ExamStatus.completed:
        return Colors.green;
    }
  }

  String getStatusText(ExamStatus status) {
    switch (status) {
      case ExamStatus.upcoming:
        return 'Upcoming';
      case ExamStatus.ongoing:
        return 'Ongoing';
      case ExamStatus.completed:
        return 'Completed';
    }
  }
}

class StudentPage extends StatelessWidget {
  final ExamController controller = Get.put(ExamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Exam Schedule',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF5B5CE6)),
            onPressed: () => controller.refreshExams(),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black54),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _showProfileDialog(context);
                  break;
                case 'download':
                  Get.snackbar(
                    'Download',
                    'Exam schedule downloaded successfully!',
                    backgroundColor: Color(0xFF5B5CE6),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  break;
                case 'settings':
                  Get.snackbar(
                    'Settings',
                    'Settings page coming soon!',
                    backgroundColor: Colors.grey,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF5B5CE6)),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Color(0xFF5B5CE6)),
                    SizedBox(width: 8),
                    Text('Download Schedule'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF5B5CE6)),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5B5CE6),
            ),
          );
        }

        return RefreshIndicator(
          color: Color(0xFF5B5CE6),
          onRefresh: () async {
            controller.refreshExams();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5B5CE6), Color(0xFF7C7CE8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Obx(() => Text(
                        controller.studentName.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 4),
                      Obx(() => Text(
                        'Student ID: ${controller.studentId.value}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      )),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Today's Exams Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Exams',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF5B5CE6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() => Text(
                        '${controller.examList.where((exam) => exam.date == 'Today').length} Exams',
                        style: TextStyle(
                          color: Color(0xFF5B5CE6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Exam Cards
                Obx(() => Column(
                  children: controller.examList.map((exam) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => _showExamDetails(context, exam),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exam.subject,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          exam.subjectCode,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: controller.getStatusColor(exam.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      controller.getStatusText(exam.status),
                                      style: TextStyle(
                                        color: controller.getStatusColor(exam.status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),

                              // Exam Details
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.access_time,
                                      'Time',
                                      exam.time,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.timer,
                                      'Duration',
                                      exam.duration,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.location_on,
                                      'Room',
                                      exam.roomNumber,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      Icons.category,
                                      'Type',
                                      exam.examType,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),

                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showRoomLocation(context, exam),
                                      icon: Icon(Icons.search, size: 16, color: Color(0xFF5B5CE6)),
                                      label: Text(
                                        'Search room',
                                        style: TextStyle(color: Color(0xFF5B5CE6)),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Color(0xFF5B5CE6)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showExamDetails(context, exam),
                                      icon: Icon(Icons.info, size: 16),
                                      label: Text('Details'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF5B5CE6),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Color(0xFF5B5CE6)),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value.isEmpty ? "Not Yet Available" : value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showExamDetails(BuildContext context, ExamInfo exam) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exam Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailRow('Subject', exam.subject),
              _buildDetailRow('Subject Code', exam.subjectCode),
              _buildDetailRow('Date', exam.date),
              _buildDetailRow('Time', exam.time),
              _buildDetailRow('Duration', exam.duration),
              _buildDetailRow('Room Number', exam.roomNumber),
              _buildDetailRow('Hall Ticket', exam.hallTicketNumber),
              _buildDetailRow('Exam Type', exam.examType),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B5CE6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomLocation(BuildContext context, ExamInfo exam) {
    final TextEditingController _roomController=TextEditingController();
    Get.bottomSheet(
       
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.location_on,
              size: 48,
              color: Color(0xFF5B5CE6),
            ),
            SizedBox(height: 16),
            Text(
              'Find Room',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: TextField(
                controller: _roomController,
                decoration: InputDecoration(
                  labelText: 'Enter Register Number',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                  ),
                  
              ),
            ),
            SizedBox(height: 16),
             
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Finding Room',
                    'Be patient...',
                    backgroundColor: Color(0xFF5B5CE6),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(Icons.directions),
                label: Text('Find Room'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B5CE6),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF5B5CE6),
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Obx(() => Text(
                controller.studentName.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),
              SizedBox(height: 4),
              Obx(() => Text(
                controller.studentId.value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B5CE6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}