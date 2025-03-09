import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class PlayGame extends StatefulWidget {
  const PlayGame({super.key});

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  late List<String> board;
  late List<Map<String, String>> questions;
  late double gridSize = 3;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartGameDialog();
    });
  }

  void initializeGame() {
    board = List.generate((gridSize * gridSize).toInt(), (index) => (index + 1).toString());
    questions = List.generate(
      (gridSize * gridSize).toInt(),
          (index) => {"question": "", "answer": ""},
    );
  }

  void _showStartGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 230, 222),
          title: const Text('Pick a File.', style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.normal ,fontWeight: FontWeight.bold,),),
          content: const Text('From:', style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
          actions: [
            _fileButton("Return"),
            _fileButton("Your PC"),
            _fileButton("Your Library"),
          ],
        );
      },
    );
  }

  Widget _fileButton(String fileText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 230, 160, 149),
      ),
      onPressed: () async {
        if(fileText == "Return") {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          await _loadGameFile();
          Navigator.pop(context);
        }
      },
      child: Text(fileText, style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
    );
  }

  Future<void> _loadGameFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['httf'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      String fileContent = utf8.decode(fileBytes!);
      List<String> lines = fileContent.split('\n');
      int buttonIndex = -1;

      for (String line in lines) {
        line = line.trim();
        if (line.startsWith('GridSize:')) {
          setState(() {
            gridSize = double.parse(line.substring(9).trim());
            initializeGame();
          });
        } else if (line.startsWith('Button')) {
          buttonIndex++;
          continue;
        } else if (line.startsWith('Question:')) {
          questions[buttonIndex]["question"] = line.substring(9).trim();
        } else if (line.startsWith('Answer:')) {
          questions[buttonIndex]["answer"] = line.substring(7).trim();
        }
      }
      setState(() {
        gameStarted = true;
      });
    }
  }

  void _showQuestionDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 230, 222),
          title: Text('Field ${index + 1}', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03 + 5 - gridSize, color: Color.fromARGB(230, 130, 100, 150), fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(questions[index]["question"] ?? "", style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.07 + 5 - gridSize, color: Color.fromARGB(230, 130, 100, 150), fontStyle: FontStyle.italic),),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAnswerDialog(index);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 230, 160, 149),
                ),
                child: Text('Show Answer', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025 + 5 - gridSize, color: Color.fromARGB(230, 130, 100, 150), fontStyle: FontStyle.normal),),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAnswerDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Answer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(questions[index]["answer"] ?? ""),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _answerButton("X", index),
                  _answerButton("O", index),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _answerButton(String answerText, int index) {
    return ElevatedButton(
      onPressed: () {
        _updateBoard(index, answerText);
        Navigator.pop(context);
      },
      child: Text(answerText),
    );
  }

  void _updateBoard(int index, String player) {
    setState(() {
      board[index] = player;
      if (_checkWinner(player)) {
        _showWinnerDialog(player);
      }
    });
  }

  bool _checkWinner(String player) {
    // rows
    for (int i = 0; i < gridSize; i++) {
      int count = 0;
      for (int j = 0; j < gridSize; j++) {
        if (board[i * gridSize.toInt() + j] == player) count++;
      }
      if (count >= 3) return true;
    }

    // vertical
    for (int i = 0; i < gridSize; i++) {
      int count = 0;
      for (int j = 0; j < gridSize; j++) {
        if (board[j * gridSize.toInt() + i] == player) count++;
      }
      if (count >= 3) return true;
    }

    // horizontal
    int count1 = 0, count2 = 0;
    for (int i = 0; i < gridSize; i++) {
      if (board[i * gridSize.toInt() + i] == player) count1++;
      if (board[i * gridSize.toInt() + (gridSize.toInt() - 1 - i)] == player) count2++;
    }
    return count1 >= 3 || count2 >= 3;
  }

  void _showWinnerDialog(String player) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Player $player Wins!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                initializeGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!gameStarted) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Spacer(),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.height * 0.7,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize.toInt(),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: gridSize.toInt() * gridSize.toInt(),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size((130 - gridSize*10), (130 - gridSize*10)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(150, 255, 115, 70)
                    ),
                    onPressed: () {
                      if (board[index] != "X" && board[index] != "O") {
                        _showQuestionDialog(index);
                      }
                    },
                    child: Text(
                      board[index],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
                    ),
                  );
                },
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
