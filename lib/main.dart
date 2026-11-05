import 'package:flutter/material.dart';
import 'dart:math'; // Used to generate random names

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AttendanceScreen(),
    );
  }
}

// 1. Student Model
class Student {
  final String rollNo;
  final String name;
  bool isPresent;

  Student({required this.rollNo, required this.name, this.isPresent = false});
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  
  // Name lists for random generation
  final List<String> firstNames = [
    "Aarav", "Vivaan", "Aditya", "Vihaan", "Arjun", "Sai", "Reyansh", "Ayaan", "Krishna", "Ishaan",
    "Ananya", "Diya", "Aadhya", "Saanvi", "Pari", "Anika", "Navya", "Angel", "Myra", "Sara",
    "Rohan", "Rahul", "Amit", "Priya", "Neha", "Pooja", "Sneha", "Karan", "Siddharth", "Riya",
    "John", "Emma", "Michael", "Olivia", "William", "Ava", "James", "Isabella", "Oliver", "Sophia"
  ];

  final List<String> lastNames = [
    "Sharma", "Verma", "Patel", "Gupta", "Singh", "Kumar", "Reddy", "Rao", "Das", "Joshi",
    "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"
  ];

  // Declare lists with 'late' to initialize them in initState
  late List<Student> students;
  late List<Student> filteredStudents;
  
  // Search Bar State
  String searchQuery = "";

  // 2. Initialize the 500 students inside initState to fix the error
  @override
  void initState() {
    super.initState();
    
    // Generate 500 realistic student records
    students = List.generate(500, (index) {
      final random = Random();
      String fName = firstNames[random.nextInt(firstNames.length)];
      String lName = lastNames[random.nextInt(lastNames.length)];
      String roll = "CS-${(index + 1).toString().padLeft(3, '0')}"; // e.g., CS-001
      
      return Student(
        rollNo: roll,
        name: "$fName $lName",
      );
    });

    // Initially, show all students
    filteredStudents = students;
  }

  // Function to filter students based on search
  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredStudents = students.where((student) {
        final nameLower = student.name.toLowerCase();
        final rollLower = student.rollNo.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) || rollLower.contains(searchLower);
      }).toList();
    });
  }

  int get presentCount => students.where((s) => s.isPresent).length;

  void submitAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved! Total Present: $presentCount / ${students.length}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance (500 Records)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      body: Column(
        children: [
          // SEARCH BAR (Very important for 500 records)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                labelText: 'Search by Name or Roll No',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // LIST OF STUDENTS
          Expanded(
            child: filteredStudents.isEmpty 
              ? const Center(child: Text("No students found."))
              : ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: student.isPresent ? Colors.green : Colors.grey[300],
                          child: Text(
                            student.rollNo.substring(3), // Just the number
                            style: TextStyle(
                              color: student.isPresent ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(student.name),
                        subtitle: Text(student.rollNo),
                        trailing: Switch(
                          value: student.isPresent,
                          // FIXED: Changed activeColor to activeThumbColor
                          activeThumbColor: Colors.green, 
                          onChanged: (bool value) {
                            setState(() {
                              student.isPresent = value;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      
      // BOTTOM SUBMIT BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Present: $presentCount  |  Absent: ${students.length - presentCount}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Attendance', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}