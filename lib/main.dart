import 'package:flutter/material.dart';

void main() {
  runApp(GradeManagementApp());
}

class GradeManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GradeManagementScreen(),
    );
  }
}

class GradeManagementScreen extends StatefulWidget {
  @override
  _GradeManagementScreenState createState() => _GradeManagementScreenState();
}

class _GradeManagementScreenState extends State<GradeManagementScreen> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  List<Map<String, dynamic>> _grades = [];

  bool _isEditing = false;
  int _editingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Grade' : 'Grade Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _isEditing = false;
                _editingIndex = -1;
                _studentNameController.clear();
                _gradeController.clear();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _studentNameController,
                decoration: InputDecoration(labelText: 'Student Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _gradeController,
                decoration: InputDecoration(labelText: 'Grade'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text(_isEditing ? 'Update Grade' : 'Add Grade'),
                onPressed: _isEditing ? _updateGrade : _addGrade,
              ),
              SizedBox(height: 20),
              Text(
                'Grades',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_grades[index]['studentName']}'),
                    subtitle: Text('Grade: ${_grades[index]['grade']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                              _editingIndex = index;
                              _studentNameController.text =
                                  _grades[index]['studentName'];
                              _gradeController.text =
                                  _grades[index]['grade'].toString();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteGrade(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Grade Average: ${_calculateAverage().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addGrade() {
    final studentName = _studentNameController.text;
    final grade = double.tryParse(_gradeController.text);
    if (studentName.isNotEmpty && grade != null) {
      setState(() {
        _grades.add({'studentName': studentName, 'grade': grade});
        _studentNameController.clear();
        _gradeController.clear();
      });
    }
  }

  void _updateGrade() {
    final studentName = _studentNameController.text;
    final grade = double.tryParse(_gradeController.text);
    if (studentName.isNotEmpty && grade != null && _editingIndex != -1) {
      setState(() {
        _grades[_editingIndex] = {'studentName': studentName, 'grade': grade};
        _isEditing = false;
        _editingIndex = -1;
        _studentNameController.clear();
        _gradeController.clear();
      });
    }
  }

  void _deleteGrade(int index) {
    setState(() {
      _grades.removeAt(index);
    });
  }

  double _calculateAverage() {
    if (_grades.isEmpty) return 0;
    double sum = 0;
    for (var grade in _grades) {
      sum += grade['grade'];
    }
    return sum / _grades.length;
  }
}
