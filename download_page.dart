import 'package:flutter/material.dart';
import 'study_dashboard.dart';

class DownloadPage extends StatelessWidget {
  final String subject;

  const DownloadPage({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📥 Download Subject Package",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Internet Required Only Once",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            const Text("✅ Notes"),
            const Text("✅ Video Lessons"),
            const Text("✅ Practice Questions"),
            const Text("✅ Previous Year Question Papers"),
            const Text("✅ AI Quiz"),

            const SizedBox(height: 20),

            const Text(
              "Storage Required: 420 MB",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyDashboard(
                        subject: subject,
                      ),
                    ),
                  );
                },
                child: const Text("Download Package"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}