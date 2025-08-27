import 'package:flutter/material.dart';
import 'package:get/get.dart';
 

// Model Classes
class ExamSession {
  final String subject;
  final String subjectCode;
  final String time;
  final String room;
  final int studentsCount;
  final String examType;
  final String batch;
  final ExamDuty dutyType;

  ExamSession({
    required this.subject,
    required this.subjectCode,
    required this.time,
    required this.room,
    required this.studentsCount,
    required this.examType,
    required this.batch,
    required this.dutyType,
  });
}

enum ExamDuty { invigilator, supervisor, observer, none }

// GetX Controller
class FacultyExamController extends GetxController {
  var isLoading = false.obs;
  var examSessions = <ExamSession>[].obs;
  var facultyName = 'Dr. Sarah Johnson'.obs;
  var facultyId = 'FAC001'.obs;
  var department = 'Computer Science'.obs;
  var totalDuties = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadExamData();
  }

  void loadExamData() {
    isLoading.value = true;
    
    Future.delayed(Duration(seconds: 1), () {
      examSessions.value = [
        ExamSession(
          subject: 'Data Structures',
          subjectCode: 'CS301',
          time: '9:00 AM - 12:00 PM',
          room: 'Room 101',
          studentsCount: 45,
          examType: 'Theory',
          batch: '2022-26',
          dutyType: ExamDuty.invigilator,
        ),
        ExamSession(
          subject: 'Database Systems',
          subjectCode: 'CS302',
          time: '2:00 PM - 4:00 PM',
          room: 'Room 309',
          studentsCount: 38,
          examType: 'Practical',
          batch: '2021-25',
          dutyType: ExamDuty.invigilator,
        ),
         
      ];
      
      totalDuties.value = examSessions.where((exam) => exam.dutyType != ExamDuty.none).length;
      isLoading.value = false;
    });
  }

  void refreshData() {
    loadExamData();
  }

  String getDutyText(ExamDuty duty) {
    switch (duty) {
      case ExamDuty.invigilator:
        return 'Invigilator';
      case ExamDuty.supervisor:
        return 'Supervisor';
      case ExamDuty.observer:
        return 'Observer';
      case ExamDuty.none:
        return 'No Duty';
    }
  }

  Color getDutyColor(ExamDuty duty) {
    switch (duty) {
      case ExamDuty.invigilator:
        return Color(0xFF5B5CE6);
      case ExamDuty.supervisor:
        return Colors.green;
      case ExamDuty.observer:
        return Colors.orange;
      case ExamDuty.none:
        return Colors.grey;
    }
  }
}

class FacultyPage extends StatelessWidget {
  final FacultyExamController controller = Get.put(FacultyExamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
         
         
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Duties',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
             Text(DateTime.now().toLocal().toString().split(" ")[0].replaceAll('-', '/'),style: TextStyle(fontSize: 13),)
          ],
        ),
         
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
            controller.refreshData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header Summary
                Container(
                  width: double.infinity,
                  color: Colors.grey[50],
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                              controller.facultyName.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            )),
                            SizedBox(height: 4),
                            Obx(() => Text(
                              '${controller.department.value} • ${controller.facultyId.value}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF5B5CE6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(() => Text(
                          '${controller.totalDuties.value} Duties Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),

                // Exam Sessions List
                Obx(() => ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  itemCount: controller.examSessions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final exam = controller.examSessions[index];
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => _showExamDetails(context, exam),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        exam.subjectCode,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: controller.getDutyColor(exam.dutyType).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    controller.getDutyText(exam.dutyType),
                                    style: TextStyle(
                                      color: controller.getDutyColor(exam.dutyType),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            // Exam Details Grid
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSimpleInfoItem(
                                    Icons.schedule,
                                    exam.time,
                                  ),
                                ),
                                Expanded(
                                  child: _buildSimpleInfoItem(
                                    Icons.location_on,
                                    exam.room,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildSimpleInfoItem(
                                    Icons.people,
                                    '${exam.studentsCount} Students',
                                  ),
                                ),
                                Expanded(
                                  child: _buildSimpleInfoItem(
                                    Icons.class_,
                                    exam.batch,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            // Action Buttons
                            Row(
                           
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => _showStudentList(context, exam),
                                    child: Text(
                                      'View Students',
                                      style: TextStyle(
                                        color: Color(0xFF5B5CE6),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                 
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSimpleInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black54),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showExamDetails(BuildContext context, ExamSession exam) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              exam.subject,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Subject Code', exam.subjectCode),
            _buildDetailRow('Time', exam.time),
            _buildDetailRow('Room', exam.room),
            _buildDetailRow('Students', '${exam.studentsCount}'),
            _buildDetailRow('Type', exam.examType),
            _buildDetailRow('Batch', exam.batch),
            _buildDetailRow('Duty', controller.getDutyText(exam.dutyType)),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      _showStudentList(context, exam);
                    },
                    child: Text('Student List'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF5B5CE6),
                      side: BorderSide(color: Color(0xFF5B5CE6)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _markAttendance(context, exam);
                    },
                    child: Text('Attendance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B5CE6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentList(BuildContext context, ExamSession exam) {
    Get.dialog(
      Dialog(
        child: Container(
          width: double.infinity,
          height: 400,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Students List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${exam.subject} (${exam.subjectCode})',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: exam.studentsCount,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF5B5CE6),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(
                        'Student ${index + 1}',
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Roll: 202200${index + 1}',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B5CE6),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markAttendance(BuildContext context, ExamSession exam) {
    Get.snackbar(
      'Attendance',
      'Attendance marking for ${exam.subject}',
      backgroundColor: Color(0xFF5B5CE6),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showFacultyProfile(BuildContext context) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF5B5CE6),
                child: Text(
                  'SJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Obx(() => Text(
                controller.facultyName.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
              SizedBox(height: 8),
              Obx(() => Text(
                '${controller.department.value}\n${controller.facultyId.value}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B5CE6),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}