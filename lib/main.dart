import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'screens/homepage.dart';
import 'package:flutter_todo/suggestions_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DatabaseHelper(),
        child: ChangeNotifierProvider(
          create: (context) => SuggestionsProvider(),
          child: MaterialApp(
          theme: ThemeData(
              textTheme:
              GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme)),
          home: Homepage())
        )

    );
  }
}
