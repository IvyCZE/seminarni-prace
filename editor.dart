import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

void main() {
  runApp(const Editor());
}

class Editor extends StatelessWidget {
  const Editor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seminární Práce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AZkviztest(title: 'Seminární Práce Pg1'),
    );
  }
}

class AZkviztest extends StatefulWidget {
  const AZkviztest({super.key, required this.title});

  final String title;

  @override
  State<AZkviztest> createState() => _AZkviztestState();
}

class _AZkviztestState extends State<AZkviztest> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final double baseHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.060;
  final double expandedHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.105;
  String _enteredText = '';
  String hoveredButton = "";
  String activeText = "";

  double _calculateDelay(int index) => (150 - (index * 50)).clamp(40, 150).toDouble();

  Future<void> _animateText(String text) async {
    for (int i = 1; i <= text.length; i++) {
      if (hoveredButton != text) return; // Stop animation if hover changes
      setState(() {
        activeText = text.substring(0, i);
      });
      await Future.delayed(Duration(milliseconds: _calculateDelay(i).toInt()));
    }
  }

  void _onEnter(String buttonText) {
    setState(() {
      hoveredButton = buttonText;
      activeText = ""; // Reset text animation
    });
    _animateText(buttonText);
  }

  void _onExit() {
    setState(() {
      hoveredButton = "";
      activeText = "";
    });
  }
  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 230, 160, 149),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          Text(text),
        ],
      ),
    );
  }
  Widget _buildHoverButton(String text, IconData icon, VoidCallback onPressed) {
    final bool isHovered = hoveredButton == text;

    return MouseRegion(
      onEnter: (_) => _onEnter(text),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        width: isHovered ? expandedHoverWidth : baseHoverWidth,
        height: baseHoverWidth,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 230, 160, 149),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              if (isHovered)
                Text(
                  activeText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
  String currentquestion = "Question...";
  String currentanswer = "Answer...";
  int currentButton = 0;

  final List<Map<String, String>> buttonData = List.generate(
    25,
        (index) => {"question": "", "answer": ""},
  );

  void _updateQuestionData(int index, String question) {
    setState(() {
      buttonData[index]["question"] = question;
    });
  }

  void _updateAnswerData(int index, String answer) {
    setState(() {
      buttonData[index]["answer"] = answer;
    });
  }

  void _updateIndex(int index) {
    setState(() {
      currentButton = index;
      currentquestion = buttonData[currentButton]["question"] ?? "";
      currentanswer = buttonData[currentButton]["answer"] ?? "";

      // Update controllers
      questionController.text = currentquestion;
      answerController.text = currentanswer;
    });
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, ValueChanged<String> onChanged) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.3,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 160, 149),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        expands: false,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(color: Color.fromARGB(200, 130, 100, 110), fontSize: MediaQuery.of(context).size.height * 0.025),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: TextStyle(color: Color.fromARGB(150, 130, 100, 130), fontSize: MediaQuery.of(context).size.height * 0.025),
          hintText: hintText,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSquareGrid() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.height * 0.7,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          return _buildSquareButton(index);
        },
      ),
    );
  }

  Widget _buildSquareButton(int index) {
    String? questiontext;{
      if(buttonData[index]["question"]!.length > 19){
        questiontext = (buttonData[index]["question"]!.substring(0,20) + "...")!;
      }
      else{
        questiontext = buttonData[index]["question"];
      }
    }
    String? answertext;{
      if(buttonData[index]["answer"]!.length > 19){
        answertext = (buttonData[index]["answer"]!.substring(0,20) + "...")!;
      }
      else{
        answertext = buttonData[index]["answer"];
      }
    }
    return ElevatedButton(
      onPressed: () => _updateIndex(index),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(80, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color.fromARGB(150, 255, 115, 70)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questiontext!,
            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0125, color: Color.fromARGB(230, 130, 100, 150), fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            answertext!,
            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0125, color: Color.fromARGB(200, 130, 100, 110), fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        _buildHoverButton("Home", Icons.home, () {
                            Navigator.pop(context);
                        },
                        ),
                        SizedBox(width: 5),
                        _buildHoverButton("Edit", Icons.edit, () => _buttonPressed("Edit")),
                        SizedBox(width: 5),
                        _buildHoverButton("Play", Icons.cast, () => _buttonPressed("Play")),
                        SizedBox(width: 5),
                        _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                        Spacer(),
                        _buildHoverButton("Save", Icons.download, () => _saveGridToFile()),
                        SizedBox(width: 5),
                        _buildHoverButton("Load", Icons.upload_file, () => _loadGridFromFileOnWeb()),
                        Spacer(),
                        _buildHoverButton("User", Icons.perm_identity_rounded, () => _buttonPressed("User")),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              padding: EdgeInsets.all(50),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // image: DecorationImage(image: AssetImage('assets/main.jpg'), fit: BoxFit.cover,),
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.025,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextField(
                        questionController,
                        " Question...",
                            (value) => _updateQuestionData(currentButton, value),
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        answerController,
                        " Answer...",
                            (value) => _updateAnswerData(currentButton, value),
                      ),
                    ],
                  ),
                  Spacer(),
                  _buildSquareGrid(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.025,),
                ],
              ),

            )
          ],
        ),
      ),
    );
  }
  void _textInput(String value) {
    setState(() {
      _enteredText = value;
    });
    print("Entered text: $_enteredText");
  }

  void _buttonPressed(String value) {
    print("Button pressed: $value");
  }
  void _saveGridToFile() {
    // Step 1: Extract grid data
    String fileContent = "";
    for (int i = 0; i < buttonData.length; i++) {
      fileContent += "Button ${i + 1}:\n";
      fileContent += "Question: ${buttonData[i]["question"] ?? "None"}\n";
      fileContent += "Answer: ${buttonData[i]["answer"] ?? "None"}\n\n";
    }

    // Step 2: Create a Blob and trigger the download
    final bytes = utf8.encode(fileContent); // Convert to bytes
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Step 3: Trigger download
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'tictactoe.httf'; // Desired file name and extension
    anchor.click();

    // Cleanup
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _loadGridFromFile() async {
    // Step 1: Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['httf'], // Limit to .htf files
    );

    if (result != null) {
      // Step 2: Read the file
      File file = File(result.files.single.path!);
      String fileContent = await file.readAsString();

      // Step 3: Parse the file content
      List<String> lines = fileContent.split('\n');
      int buttonIndex = -1;

      for (String line in lines) {
        line = line.trim();
        if (line.startsWith('Button')) {
          // Button entry, update index
          buttonIndex++;
          continue;
        } else if (line.startsWith('Question:')) {
          buttonData[buttonIndex]["question"] = line.substring(10,line.length);
          continue;
        } else if (line.startsWith('Answer:')) {
          buttonData[buttonIndex]["answer"] = line.substring(8,line.length);
          continue;
        }
      }

      // Step 4: Update the UI
      setState(() {
        // The `buttonData` list has been updated, so re-render the grid
      });

      print("Grid data loaded successfully!");
    } else {
      print("File selection canceled.");
    }
  }

  Future<void> _loadGridFromFileOnWeb() async {
    // Step 1: Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['httf'], // Limit to .htf files
    );

    if (result != null) {
      // Step 2: Access the file content
      Uint8List? fileBytes = result.files.single.bytes;
      if (fileBytes != null) {
        // Decode the file content
        String fileContent = utf8.decode(fileBytes);
        print("File content: $fileContent"); // Debug: Print the file content

        // Step 3: Parse the file content
        List<String> lines = fileContent.split('\n');
        int buttonIndex = -1;

        for (String line in lines) {
          line = line.trim();
          if (line.startsWith('Button')) {
            // Button entry, update index
            buttonIndex++;
            print("Processing Button $buttonIndex"); // Debug: Log button index
            continue;
          } else if (line.startsWith('Question:')) {
            String question = line.substring(9).trim();
            buttonData[buttonIndex]["question"] = question;
            print("Question for Button $buttonIndex: $question"); // Debug: Log question
          } else if (line.startsWith('Answer:')) {
            String answer = line.substring(7).trim();
            buttonData[buttonIndex]["answer"] = answer;
            print("Answer for Button $buttonIndex: $answer"); // Debug: Log answer
          }
        }

        // Step 4: Update the UI
        setState(() {
          // Notify Flutter to re-render the UI
        });

        print("Grid data loaded successfully!");
      } else {
        print("Error: File content is null.");
      }
    } else {
      print("File selection canceled.");
    }
  }
}
