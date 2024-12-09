import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Mini Projet",
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  QuestionPageState createState() => QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {
  List <String> questions = [];
  List<String> answers = [];
  int currentIndex = 0;
  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Cette fonction permet de récupérer les questions, disponibles au format JSON
  // dans /assets
  Future<void> _loadQuestions() async {
    final String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      questions = List<String>.from(jsonData);
    });
  }

  void submitAnswer() {
    setState(() {
      answers.add(textFieldController.text);
      textFieldController.clear();
      currentIndex++;
    });
  }
  
  // MARK: Build method
  @override
  Widget build(BuildContext context) {

    // Page Buffering
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Page résultats
    if (currentIndex == questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Questionnaire")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final answer = answers[index];
                      final question = questions[index];
                  
                      return Column(children: [
                        Text(question),
                        Text(answer),
                        const SizedBox(height: 20.0,)
                      ],);
                    }
                  ),
                ),
                TextButton(onPressed:() {
                  setState(() {
                    currentIndex = 0;
                    answers = [];
                    textFieldController.clear();
                  });
                }, child: 
                  const Text("Recommencer")
                )
              ]
            ),
          ),
        ),
      );
    }

    // Page Questionnaire
    return Scaffold(
      appBar: AppBar(title: const Text("Questionnaire")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Question ${currentIndex + 1}/${questions.length}"),
              Text(questions[currentIndex]),
              TextButton(
                onPressed:() {
                  submitAnswer();
                },
                child:
                  const Text("Question suivante")
                ),
              TextField(
                controller: textFieldController,
                onSubmitted:(value) {
                  submitAnswer();
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
  
}