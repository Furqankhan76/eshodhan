import 'package:eshodhan/src/utils/helpers/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage =  FlutterSecureStorage();




final username = AuthHelper.getAuthDetails().then((value) => value?.userDisplayName ?? "User");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {

    String username = "User";

    @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final authDetails = await AuthHelper.getAuthDetails();
    setState(() {
      username = authDetails?.userDisplayName ?? "User";
    });
    
    // Also print to console for debugging
    print('User Display Name: ${authDetails?.userDisplayName}');
    print('User Email: ${authDetails?.userEmail}');
    print('User Nice Name: ${authDetails?.userNiceName}');
    print('Token: ${authDetails?.token}');
  }



  @override
  Widget build(BuildContext context)  {
   
    return  Scaffold(
      
      appBar: AppBar(
       
        
        title: Text('Home', style: TextStyle(color: Theme.of(context).textTheme.headlineMedium?.color),),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1.0),
    child: Container(
      color: Theme.of(context).textTheme.headlineMedium?.color, // Border color
      height: 1.0,
    ),
  ),        
        
      ),
      body: Center(

        child: Text('Welcome, $username!'),
        
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
    
  }
}