import 'package:auto_route/auto_route.dart';
import 'package:cabquiz/routes/app_router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class QuizNamePromptPage extends StatelessWidget {
  final String roomId;

  const QuizNamePromptPage({
    super.key,
    @PathParam('roomId') required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Username',
          textAlign: TextAlign.center,
        ),
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () {
            context.router.replace(const HomeRoute());
          },
          child: const Text('Leave'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text.trim();
                if (username.isNotEmpty) {
                  context.router.replaceNamed('/quiz/$roomId/$username');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a username')),
                  );
                }
              },
              child: const Text('Join Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
