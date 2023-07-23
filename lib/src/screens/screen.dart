import 'dart:async';

import 'package:flutter/material.dart';
import 'question.dart';





class QuizScreen extends StatefulWidget{

State<QuizScreen> createState()=> _QuizScreenState();

}

class _QuizScreenState extends State<QuizScreen>{
    List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
   int totalTimeInSeconds = 30;
  int remainingTimeInSeconds = 30;
   Timer? _timer;
   bool timeIsUp = false;
   @override
void initState() {
  super.initState();
  startTimer();
}
  Widget build(context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 50, 80),
      body:Container(
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 32),
        child:  Column(
          children: [
          const Text("Simple Quiz",
            style: TextStyle(
            color: Colors.white,
            fontSize:24
            ),
            ),
            _questionWidget(),
            _answerList(),
            _nextButton(),
          ],
        ) ,
      ) ,
 
    );

  }
 _questionWidget() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 20),
      Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              questionList[currentQuestionIndex].questionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Time Left: ${remainingTimeInSeconds.toString()} seconds",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black, shape: const StadiumBorder(),
           backgroundColor: isSelected ? Colors.orangeAccent : Colors.white,
        ),
        onPressed:timeIsUp ? null: () {
          if (selectedAnswer == null) {
            if (answer.isCorrect) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
            });
          }
        },
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.blueAccent,
          disabledForegroundColor: Colors.white,
        ),
        onPressed: () {
          if (isLastQuestion) {
            //display score

            showDialog(context: context, builder: (_) => _showScoreDialog());
              _timer?.cancel();   
              remainingTimeInSeconds = totalTimeInSeconds;     
          } else {
            //next question
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;

    if (score >= questionList.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    String title = isPassed ? "Passed " : "Failed";

    return AlertDialog(
      title: Text(
        title + " | Score is $score",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: ElevatedButton(
        child: const Text("Restart"),
        onPressed: () {
          Navigator.pop(context);
         _restartQuiz();
        },
      ),
    );
  }

  void startTimer() {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      if (remainingTimeInSeconds > 0) {
        remainingTimeInSeconds--;
      } else {
        // Time is up, handle it here (e.g., move to the next question or submit the quiz).
       timeIsUp = true;
        _timer?.cancel();
        _submitQuiz();
      }
    });
  });

}
void _submitQuiz() {
  showDialog(
    context: context,
     builder:(_) => _showScoreDialog(),
  );
}
void _restartQuiz() {
  setState(() {
    currentQuestionIndex = 0;
    score = 0;
    selectedAnswer = null;
    timeIsUp = false;
    remainingTimeInSeconds = totalTimeInSeconds;
  });
  startTimer();
}
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

}

