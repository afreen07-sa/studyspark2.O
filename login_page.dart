import 'package:flutter/material.dart';
import 'data/syllabus_data.dart';
import 'models/app_state.dart';
import 'category_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController(text: 'Arun Kumar');
  String _selectedClass = 'Class 10';
  String _selectedGroup = 'Bio-Maths';
  String _selectedLanguage = 'English';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    final name = _nameController.text.trim().isEmpty ? 'Student' : _nameController.text.trim();
    AppState.instance.updateStudent(
      name: name,
      className: _selectedClass,
      group: _selectedGroup,
      language: _selectedLanguage,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome, $name! Loading $_selectedClass curriculum...'),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CategoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHigherSec = _selectedClass == 'Class 11' || _selectedClass == 'Class 12';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Student Login / Profile'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school, color: Colors.indigo, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'StudySpark Login',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tamil Nadu State Board Learning Portal',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // STUDENT NAME
                    const Text(
                      'Student Name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter student full name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CLASS SELECTION
                    const Text(
                      'Select Class (Grade)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          isExpanded: true,
                          items: SyllabusData.classes.map((cls) {
                            return DropdownMenuItem<String>(
                              value: cls,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 20,
                                    color: cls == 'Class 11' || cls == 'Class 12'
                                        ? Colors.indigo
                                        : Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    cls,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  if (cls == 'Class 11' || cls == 'Class 12')
                                    const Text(
                                      ' (Choose Group)',
                                      style: TextStyle(color: Colors.indigo, fontSize: 13),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedClass = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // GROUP SELECTION (FOR CLASS 11 & 12)
                    if (isHigherSec) ...[
                      Row(
                        children: [
                          const Text(
                            'Higher Secondary Group / Stream',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Required for $_selectedClass',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo.shade300, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.indigo.shade50.withAlpha(50),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGroup,
                            isExpanded: true,
                            items: SyllabusData.groups.keys.map((grp) {
                              return DropdownMenuItem<String>(
                                value: grp,
                                child: Text(
                                  grp,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedGroup = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        SyllabusData.groupDescriptions[_selectedGroup] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo.shade900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // LANGUAGE SELECTION
                    const Text(
                      'Medium of Instruction / Language',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _selectedLanguage == 'English'
                                  ? Colors.indigo.shade100
                                  : Colors.white,
                              side: BorderSide(
                                color: _selectedLanguage == 'English'
                                    ? Colors.indigo
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedLanguage = 'English';
                              });
                            },
                            child: const Text(
                              'English Medium',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _selectedLanguage == 'Tamil'
                                  ? Colors.indigo.shade100
                                  : Colors.white,
                              side: BorderSide(
                                color: _selectedLanguage == 'Tamil'
                                    ? Colors.indigo
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedLanguage = 'Tamil';
                              });
                            },
                            child: const Text(
                              'தமிழ் வழி (Tamil)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // LOGIN BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      onPressed: _submitLogin,
                      child: const Text(
                        'Enter Learning Dashboard',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // GUEST ACCESS
                    TextButton(
                      onPressed: () {
                        AppState.instance.updateStudent(
                          name: 'Guest Learner',
                          className: 'Class 10',
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CategoryPage()),
                        );
                      },
                      child: const Text('Continue as Guest'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
