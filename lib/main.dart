import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Actify/pages/notes_page.dart';
import 'package:Actify/pages/reminder_page.dart';
import 'package:Actify/pages/timetable_page.dart';
import 'package:Actify/pages/userprofile_page.dart';
import 'package:Actify/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final userId = prefs.getString('userId');
  final userName = prefs.getString('userName');
  final userEmail = prefs.getString('userEmail');
 


  runApp(
    ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MyApp(
      isLoggedIn: isLoggedIn,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
    ),
    
  ));
}

class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  final String? userId;
  final String? userName;
  final String? userEmail;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.userId,
    this.userName,
    this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Student Organizer',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111010),
        textTheme: ThemeData.dark().textTheme,
        useMaterial3: true,
      ),

       
      
      
      home: isLoggedIn && userId != null
          ? HomeShell(
              userId: userId!,
              userName: userName!,
              userEmail: userEmail!,
            )
          : const LoginPage(),
    );
  }
}

class HomeShell extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;

  const HomeShell({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      NotesPage(userId: widget.userId, userName: widget.userName, userEmail: widget.userEmail),
      const RemindersPage(),
      const TimetablePage(),
      UserProfilePage(userId: widget.userId, userName: widget.userName, userEmail: widget.userEmail),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.note_outlined), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.alarm_outlined), label: 'Reminders'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Timetable'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
