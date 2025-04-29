// editor.txt
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonEncode
import 'dart:html' as html; // Keep for web download/upload
import 'package:file_picker/file_picker.dart'; // Keep for web upload
import 'dart:typed_data'; // Keep for web upload
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:http/http.dart' as http; // Import HTTP package

class Editor extends StatefulWidget {
  // --- MODIFIED: Add isGuest parameter ---
  final bool isGuest;

  const Editor({
    super.key,
    this.isGuest = true, // Default to guest if not provided (safer)
  });

  @override
  State<Editor> createState() => _EditorState(); // Renamed State class
}

// Renamed State class to avoid conflict if AZkviztestState was used elsewhere
class _EditorState extends State<Editor> {
  // ... (Keep all your existing variables: questionController, answerController, etc.)
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  // WARNING: Accessing window like this in initState/declaration can be problematic.
  // It's better to calculate these based on MediaQuery in the build method if possible.
  // For simplicity here, we'll leave it, but be aware it might not update on resize.
  final double baseHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.060;
  final double expandedHoverWidth = WidgetsBinding.instance.window.physicalSize.height * 0.105;
  String hoveredButton = "";
  String activeText = "";
  String currentquestion = "Question...";
  String currentanswer = "Answer...";
  String name = "Name";
  String desc = "Short description";
  int currentButton = 0;
  double _sliderValue = 5;
  List<Map<String, String>> buttonData = [];
  // Flag for loading state during network request
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _updateButtonData(); // Initialize buttonData based on initial _sliderValue
    // The popup logic seems fine
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only show setup popup if maybe it's the first time? Or always?
      // Consider if you want this every time Editor opens.
      showPopup(context);
    });
  }

  // ... (Keep _calculateDelay, _updateButtonData, showPopup, _animateText, _onEnter, _onExit)
  // ... (Keep _updateQuestionData, _updateAnswerData, _updateIndex)
  // ... (Keep _buttonPressed - maybe useful later)
  // ... (Keep _buildHoverButton, _buildTextField, _buildSquareGrid, _buildSquareButton)
  double _calculateDelay(int index) => (150 - (index * 50)).clamp(40, 150).toDouble();

  void _updateButtonData() {
    // Ensure this uses the current _sliderValue
    int gridSize = _sliderValue.toInt();
    int totalButtons = gridSize * gridSize;
    // Preserve existing data if resizing down, or create new if resizing up/first time
    List<Map<String, String>> oldData = (buttonData ?? []).toList(); // Copy old data
    buttonData = List.generate(
      totalButtons,
          (index) {
        if (index < oldData.length) {
          return oldData[index]; // Keep old data if possible
        } else {
          return {"question": "", "answer": ""}; // New button data
        }
      },
    );
    // If currentButton index is now out of bounds, reset it
    if (currentButton >= totalButtons) {
      _updateIndex(0); // Reset to first button
    } else {
      // Ensure controllers reflect the current button even after resize
      _updateIndex(currentButton);
    }
    // No need to call setState here if called from where UI rebuilds (like showPopup apply)
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use a local state variable for the slider inside the dialog
        double dialogSliderValue = _sliderValue;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text("Setup", style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
              backgroundColor: Color.fromARGB(255, 255, 230, 222),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ... (Type buttons - keep if needed) ...
                  SizedBox(height: 15,),
                  _buildTextField(_nameController, "$name", 0.2, (value) => ()),
                  SizedBox(height: 15,),
                  _buildTextField(_descController, "$desc", 0.4, (value) => ()),
                  SizedBox(height: 15,),
                  Row(
                      children: [
                        Text("Number of rows: ${dialogSliderValue.toInt()}", style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
                        Spacer()
                      ]
                  ),
                  Slider(
                    value: dialogSliderValue,
                    min: 3,
                    max: 8,
                    activeColor: Color.fromARGB(255, 230, 160, 149),
                    inactiveColor: Color.fromARGB(150, 130, 100, 130),
                    divisions: 5,
                    label: dialogSliderValue.toInt().toString(),
                    onChanged: (double value) {
                      setStateDialog(() { // Update dialog state
                        dialogSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 230, 160, 149),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Apply the change to the main state
                    setState(() {
                      _sliderValue = dialogSliderValue;
                      _updateButtonData(); // Update data structure based on new size
                    });
                  },
                  child: const Text('Apply', style: TextStyle(color: Color.fromARGB(255, 130, 100, 130), fontStyle: FontStyle.italic ,fontWeight: FontWeight.bold,),),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _animateText(String text) async {
    // ... existing code ...
    for (int i = 1; i <= text.length; i++) {
      if (hoveredButton != text) return; // Stop animation if hover changes
      if (!mounted) return; // Check if widget is still mounted
      setState(() {
        activeText = text.substring(0, i);
      });
      await Future.delayed(Duration(milliseconds: _calculateDelay(i).toInt()));
    }
  }

  void _onEnter(String buttonText) {
    if (!mounted) return;
    setState(() {
      hoveredButton = buttonText;
      activeText = ""; // Reset text animation
    });
    _animateText(buttonText);
  }

  void _onExit() {
    if (!mounted) return;
    setState(() {
      hoveredButton = "";
      activeText = "";
    });
  }

  void _updateQuestionData(int index, String question) {
    if (index >= 0 && index < buttonData.length) {
      setState(() {
        buttonData[index]["question"] = question;
      });
    }
  }

  void _updateAnswerData(int index, String answer) {
    if (index >= 0 && index < buttonData.length) {
      setState(() {
        buttonData[index]["answer"] = answer;
      });
    }
  }

  void _updateIndex(int index) {
    if (index >= 0 && index < buttonData.length) {
      setState(() {
        currentButton = index;
        currentquestion = buttonData[currentButton]?["question"] ?? "";
        currentanswer = buttonData[currentButton]?["answer"] ?? "";

        // Update controllers safely
        questionController.text = currentquestion;
        answerController.text = currentanswer;
        // Move cursor to end
        questionController.selection = TextSelection.fromPosition(TextPosition(offset: questionController.text.length));
        answerController.selection = TextSelection.fromPosition(TextPosition(offset: answerController.text.length));

      });
    } else if (buttonData.isNotEmpty) {
      // If index is somehow invalid, reset to 0
      _updateIndex(0);
    } else {
      // Handle case where buttonData is empty
      setState(() {
        currentButton = 0; // Or -1?
        currentquestion = "";
        currentanswer = "";
        questionController.text = "";
        answerController.text = "";
      });
    }
  }

  void _buttonPressed(String value) {
    print("Button pressed: $value");
  }

  Widget _buildHoverButton(String text, IconData icon, VoidCallback onPressed) {
    // Use MediaQuery for responsive widths here instead of physicalSize
    final bool isHovered = hoveredButton == text;
    final double currentBaseHoverWidth = MediaQuery.of(context).size.height * 0.060;
    final double adjustedTextWidth = (text.length > 4) ? (text.length - 4) * 8.0 : 0;
    final double currentExpandedHoverWidth = MediaQuery.of(context).size.height * 0.105 + adjustedTextWidth;


    return MouseRegion(
      onEnter: (_) => _onEnter(text),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        // Ensure width doesn't exceed available space if needed
        width: isHovered ? currentExpandedHoverWidth : currentBaseHoverWidth,
        height: currentBaseHoverWidth,
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
              Icon(icon, size: 20, color: Color.fromARGB(200, 130, 100, 110)), // Added color
              if (isHovered)
                Padding( // Added Padding
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    activeText,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(200, 130, 100, 110)), // Added color
                    overflow: TextOverflow.clip, // Prevent overflow issues
                    softWrap: false,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, num big, ValueChanged<String> onChanged) {
    // Make text field size relative to screen, not fixed * 0.3
    double fieldWidth = MediaQuery.of(context).size.width * 0.3;
    // Ensure minimum/maximum width if needed
    if (fieldWidth < 250) fieldWidth = 250;
    if (fieldWidth > 500) fieldWidth = 500;
    double fieldHeight = MediaQuery.of(context).size.height * 0.3 * big;
    if (fieldHeight > 300) fieldHeight = 300;


    return Container(
      width: fieldWidth, // Use calculated width
      height: fieldHeight, // Use calculated height
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 160, 149),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        expands: true, // Allow expansion within the container
        maxLines: null, // Required when expands is true
        minLines: null, // Required when expands is true
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(color: Color.fromARGB(200, 130, 100, 110), fontSize: 16), // Use fixed font size? Or relative?
        decoration: InputDecoration(
          border: InputBorder.none, // Use none instead of OutlineInputBorder
          // floatingLabelBehavior: FloatingLabelBehavior.always, // Not usually needed for this style
          hintStyle: TextStyle(color: Color.fromARGB(150, 130, 100, 130), fontSize: 16),
          hintText: hintText,
          contentPadding: EdgeInsets.zero, // Remove internal padding if needed
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSquareGrid() {
    int crossAxisCount = _sliderValue.toInt();
    double gridDimension = MediaQuery.of(context).size.height * 0.7;
    // Ensure the grid isn't too small or too large
    if (gridDimension < 300) gridDimension = 300;
    if (gridDimension > 600) gridDimension = 600; // Adjust max as needed

    return Container(
      height: gridDimension,
      width: gridDimension,
      decoration: BoxDecoration( // Optional: Add border or background
        color: Color.fromARGB(5, 0, 0, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(4.0), // Add padding around the grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          // Calculate aspect ratio to make squares (width / height)
          // Child size will be (gridWidth - spacing) / count
          // AspectRatio = Width / Height = 1.0 for squares
          childAspectRatio: 1.0,
        ),
        itemCount: crossAxisCount * crossAxisCount,
        itemBuilder: (context, index) {
          // Ensure index is valid before building button
          if (index < buttonData.length) {
            return _buildSquareButton(index);
          } else {
            return Container(color: Colors.grey[300]); // Placeholder for invalid index
          }
        },
      ),
    );
  }

  Widget _buildSquareButton(int index) {
    // Check bounds before accessing buttonData
    if (index < 0 || index >= buttonData.length) {
      return Container(color: Colors.red); // Error indicator
    }
    bool isCurrent = index == currentButton;
    int gridSize = _sliderValue.toInt();
    // Calculate max length based on grid size (adjust multiplier as needed)
    int maxLength = (45 - gridSize * 3).clamp(5, 30);


    String? questionText = buttonData[index]["question"];
    if (questionText != null && questionText.length > maxLength) {
      questionText = "${questionText.substring(0, maxLength)}...";
    } else if (questionText == null || questionText.isEmpty) {
      questionText = "Q..."; // Placeholder
    }

    String? answerText = buttonData[index]["answer"];
    if (answerText != null && answerText.length > maxLength) {
      answerText = "${answerText.substring(0, maxLength)}...";
    } else if (answerText == null || answerText.isEmpty) {
      answerText = "A..."; // Placeholder
    }

    // Calculate font size based on grid size
    double fontSize = (MediaQuery.of(context).size.height * 0.0125 + 6 - _sliderValue).clamp(8.0, 16.0);


    return ElevatedButton(
      onPressed: () => _updateIndex(index),
      style: ElevatedButton.styleFrom(
        // Size is determined by GridView item size, fixedSize might conflict
        // fixedSize: Size((130 - _sliderValue*10), (130 - _sliderValue*10)),
        padding: EdgeInsets.all(2), // Reduce padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCurrent ? BorderSide(color: Colors.white, width: 2) : BorderSide.none, // Highlight current
        ),
        backgroundColor: Color.fromARGB(150, 255, 115, 70),
        foregroundColor: Color.fromARGB(230, 130, 100, 150), // Default text color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questionText,
            style: TextStyle(fontSize: fontSize, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
            maxLines: 2, // Allow up to 2 lines
          ),
          const SizedBox(height: 4),
          Text(
            answerText,
            style: TextStyle(fontSize: fontSize, color: Color.fromARGB(200, 130, 100, 110), fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }


  // ############################## BUILD WIDGET ##############################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 255, 255, 255), // Make background transparent or match theme
      body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10,),
                  // --- Top Bar ---
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildHoverButton("Home", Icons.home, () {
                          Navigator.pop(context);
                        }),
                        // Maybe remove Edit/Play/Join from Editor screen?
                        // SizedBox(width: 5),
                        // _buildHoverButton("Edit", Icons.edit, () => _buttonPressed("Edit")),
                        SizedBox(width: 5),
                        _buildHoverButton("Play", Icons.cast, () => _buttonPressed("Play")),
                        SizedBox(width: 15),
                        Text('${_nameController.text}', style: TextStyle(color: Color.fromARGB(200, 130, 100, 110), fontStyle: FontStyle.normal ,fontWeight: FontWeight.bold,),),
                        // _buildHoverButton("Join", Icons.spoke, () => _buttonPressed("Join")),
                        Spacer(),
                        _buildHoverButton("Setup", Icons.settings, () => showPopup(context)),
                        SizedBox(width: 15),
                        _buildHoverButton("Download", Icons.download, _saveGridToFile), // Save to local file
                        SizedBox(width: 5),
                        // --- MODIFIED: Conditional "Save to Account" Button ---
                        if (!widget.isGuest) ...[
                          _buildHoverButton("Save", // Changed text
                            _isSaving ? Icons.sync : Icons.cloud_upload, // Show loading indicator
                            _isSaving ? () {} : _saveGridToAccount, // Disable button when saving
                          ),
                          SizedBox(width: 5),
                        ],
                        // --- End Modification ---
                        _buildHoverButton("Load", Icons.upload_file, _loadGridFromFileOnWeb), // Load from local file
                        // --- TODO: Add Load from Account Button (if !isGuest) ---
                        // if (!widget.isGuest) ...[ ... _buildHoverButton("Load Cloud", Icons.cloud_download, _loadGridFromAccount) ... ],
                        // Maybe remove User button or make it functional?
                        // _buildHoverButton("User", Icons.perm_identity_rounded, () => _buttonPressed("User")),
                        // SizedBox(width: 5),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  // --- Main Content Area ---
                  Expanded( // Use Expanded to fill remaining space
                    child: Container(
                      padding: EdgeInsets.all(20), // Reduced padding for smaller screens?
                      // width: double.infinity, // Provided by Expanded
                      // height: MediaQuery.of(context).size.height - 100, // Use Expanded instead
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(10, 0, 0, 0),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      // Use LayoutBuilder for responsive layout (Row vs Column)
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool useColumnLayout = constraints.maxWidth < 750; // Adjust breakpoint as needed
                          if (useColumnLayout) {
                            // --- Column Layout (Mobile/Narrow) ---
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center, // Center items
                                children: [
                                  _buildSquareGrid(),
                                  SizedBox(height: 20),
                                  _buildTextField(
                                    questionController,
                                    " Question...",
                                    1,
                                        (value) => _updateQuestionData(currentButton, value),
                                  ),
                                  SizedBox(height: 10),
                                  _buildTextField(
                                    answerController,
                                    " Answer...",
                                    1,
                                        (value) => _updateAnswerData(currentButton, value),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // --- Row Layout (Desktop/Wide) ---
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space out items
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Flexible helps manage space if needed
                                Flexible(
                                  flex: 2, // Give text fields slightly less space
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildTextField(
                                        questionController,
                                        " Question...",
                                        1,
                                            (value) => _updateQuestionData(currentButton, value),
                                      ),
                                      SizedBox(height: 10),
                                      _buildTextField(
                                        answerController,
                                        " Answer...",
                                        1,
                                            (value) => _updateAnswerData(currentButton, value),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 20), // Spacer if needed
                                Flexible(
                                    flex: 3, // Give grid more space
                                    child: _buildSquareGrid()
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100, // Adjust height based on how much fade you want
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0), // Start with transparent
                      Colors.white,       // Transition to black
                      Colors.white,       // End with full white
                    ],
                    stops: [0.0, 0.75, 1.0], // Control where the color transitions happen
                  ),
                ),
              ),
            ),
          ],
      )
    );
  }

  // --- (Keep _saveGridToFile and _loadGridFromFileOnWeb as they are for local file operations) ---
  void _saveGridToFile() {
    // ... existing code ...
    String fileContent = "GridSize: ${_sliderValue.toInt()}\n\n";
    fileContent += "Name: ${_nameController.text}\n";
    fileContent += "Desc: ${_descController.text}\n\n";
    for (int i = 0; i < buttonData.length; i++) {
      // Ensure index is valid
      if (i < buttonData.length) {
        fileContent += "Button ${i + 1}:\n";
        fileContent += "Question: ${buttonData[i]["question"] ?? ""}\n"; // Use "" for null
        fileContent += "Answer: ${buttonData[i]["answer"] ?? ""}\n\n"; // Use "" for null
      }
    }

    final bytes = utf8.encode(fileContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'tictactoe_${_sliderValue.toInt()}x${_sliderValue.toInt()}.httf'; // Dynamic filename
    anchor.click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grid saved to tictactoe_${_sliderValue.toInt()}x${_sliderValue.toInt()}.httf'), backgroundColor: Colors.green),
    );
  }

  Future<void> _loadGridFromFileOnWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['httf'],
    );

    if (result != null && result.files.single.bytes != null) {
      try {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileContent = utf8.decode(fileBytes);
        List<String> lines = fileContent.split('\n');
        int buttonIndex = -1;
        double? loadedSliderValue;
        String? loadedName;
        String? loadedDesc;
        List<Map<String, String>> loadedButtonData = [];

        for (String line in lines) {
          line = line.trim();
          if (line.startsWith('GridSize:')) {
            loadedSliderValue = double.tryParse(line.substring(9).trim());
            if (loadedSliderValue != null) {
              // Pre-generate list based on loaded size
              loadedButtonData = List.generate(
                (loadedSliderValue * loadedSliderValue).toInt(),
                    (index) => {"question": "", "answer": ""},
              );
            } else {
              // Handle error: Invalid GridSize
              throw FormatException("Invalid GridSize format in file.");
            }
          } else if (line.startsWith('Name')) {
            loadedName = line.substring(5).trim();
            loadedName ??= "Name";
            name = loadedName;
            _nameController.text = loadedName;
          } else if (line.startsWith('Desc')) {
            loadedDesc = line.substring(5).trim();
            loadedDesc ??= "Name";
            desc = loadedDesc;
            _descController.text = loadedDesc;
          } else if (line.startsWith('Button')) {
            // Optional: Parse button number if needed, otherwise just increment index
            buttonIndex++;
            if (loadedButtonData.isEmpty || buttonIndex >= loadedButtonData.length) {
              // Handle error: Button found before GridSize or index out of bounds
              throw FormatException("Button data found before GridSize or index out of bounds.");
            }
          } else if (line.startsWith('Question:')) {
            if (buttonIndex >= 0 && buttonIndex < loadedButtonData.length) {
              loadedButtonData[buttonIndex]["question"] = line.substring(9).trim();
            }
          } else if (line.startsWith('Answer:')) {
            if (buttonIndex >= 0 && buttonIndex < loadedButtonData.length) {
              loadedButtonData[buttonIndex]["answer"] = line.substring(7).trim();
            }
          }
        }

        // If successful, update the state
        if (loadedSliderValue != null && loadedButtonData.isNotEmpty) {
          setState(() {
            _sliderValue = loadedSliderValue!;
            buttonData = loadedButtonData;
            // Reset current button selection and update text fields
            _updateIndex(0);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Grid loaded successfully!'), backgroundColor: Colors.green),
          );
        } else {
          throw FormatException("Incomplete or invalid file structure.");
        }

      } catch (e) {
        print("Error loading file: $e");
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading file: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      // User canceled the picker
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File loading canceled.'), backgroundColor: Colors.orange),
        );
      }
    }
  }


  // --- NEW: Function to save grid data to your server ---
  Future<void> _saveGridToAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid.isEmpty) {
      // This check might be redundant if the button is hidden for guests, but good practice
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Not logged in!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isSaving = true; });

    final String userId = user.uid;

    // --- Get Firebase ID Token ---
    String? idToken;
    try {
      idToken = await user.getIdToken(true); // Pass true to force refresh if needed
      if (idToken == null) {
        throw Exception("Could not retrieve ID token.");
      }
    } catch (e) {
      print("Error getting ID token: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting authentication token: ${e.toString()}'), backgroundColor: Colors.red),
      );
      setState(() { _isSaving = false; });
      return;
    }
    // --- End Get Token ---


    // Prepare Data (same as before)
    String httfContent = "GridSize: ${_sliderValue.toInt()}\n\n";
    for (int i = 0; i < buttonData.length; i++) {
      if (i < buttonData.length) {
        httfContent += "Button ${i + 1}:\n";
        httfContent += "Question: ${buttonData[i]["question"] ?? ""}\n";
        httfContent += "Answer: ${buttonData[i]["answer"] ?? ""}\n\n";
      }
    }

    final url = Uri.parse('http://carrot.melonhost.cz:25601/save-httf'); // Your server endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // --- Add Authorization Header ---
          'Authorization': 'Bearer $idToken',
          // --- End Add Header ---
        },
        body: jsonEncode({
          'userId': userId, // Still send userId in body for the server's authorization check
          'fileName': 'tictactoe_${_sliderValue.toInt()}x${_sliderValue.toInt()}.httf',
          'httfContent': httfContent,
        }),
      ).timeout(const Duration(seconds: 15)); // Add a timeout

      // Handle Response (check for 401/403 specifically)
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grid saved to your account!'), backgroundColor: Colors.green),
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('Auth/Authz Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        String message = 'Authentication/Authorization Failed.';
        try { // Try to parse error message from server
          final bodyJson = jsonDecode(response.body);
          message = bodyJson['message'] ?? message;
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.orange),
        );
      }
      else {
        // Other Server error
        print('Server Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving to account: Server responded with ${response.statusCode}'), backgroundColor: Colors.red),
        );
      }
    } on TimeoutException catch (_) {
      print('Error sending data: Request timed out');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving to account: Request timed out.'), backgroundColor: Colors.red),
      );
    }
    catch (e) {
      // Network or other error
      print('Error sending data: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving to account: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }
    }
  }

// --- TODO: Implement _loadGridFromAccount() similarly using HTTP GET ---

} // End of _EditorState class
