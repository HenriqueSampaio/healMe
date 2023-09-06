import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healme/Pages/profile.dart';
import 'package:healme/Pages/searchFunction.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import '../Widgets/appbar_widget.dart';
import 'package:healme/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

//REGISTERING STAGE 1
enum _SelectedTab { home, camera, shop }

class woundRegisterPage extends StatefulWidget {
  const woundRegisterPage({super.key});

  @override
  State<woundRegisterPage> createState() => _woundRegisterPageState();
}

DateTime dateTime = DateTime.now();
String dropdownValueCause = 'Spontaneous wound';
String dropdownValueAssociatedDisease = 'NA';

List<String> diseases = [
  'NA',
  'Diabetes',
  'Arterial hypertension',
  'Cancer',
  'Vascular insufficiency',
  'Stroke',
  'Other'
];
List<String> selectedDiseases = [];

TextEditingController _regionController = TextEditingController();
TextEditingController _causeController = TextEditingController();
TextEditingController _diseaseController = TextEditingController();
WoundInfo userWoundInfo = WoundInfo(
                              dateTime,
                              _regionController.text.trim(),
                              _causeController.text.trim(),
                              selectedDiseases);

class _woundRegisterPageState extends State<woundRegisterPage>
    with TickerProviderStateMixin {
  @override
  var _selectedTab = _SelectedTab.camera;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
    if (i == 1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const woundRegisterPage()));
    } else if (i == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Profile()));
    }
  }

  Widget build(BuildContext context) {
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Icon(
                    Icons.app_registration_outlined,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Image(
                      image: AssetImage(
                          "/Users/henriquesampaio/flutterspace/healMe/healme/assets/images/healMeLogo.png"),
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: const Text(
                        "Wound information",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                        overflow:
                            TextOverflow.ellipsis, // Handle text overflow,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                //email textbox
                Text("When did your wound first appear?"),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade300, // Set the button color
                    minimumSize:
                        Size(double.infinity, 48), // Stretch horizontally
                  ),
                  child: Text(
                    '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;
                    setState(() => dateTime = date);
                  },
                ),

                const SizedBox(height: 24),

                //password textbox
                Material(
                  child: TextField(
                    controller: _regionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "What region of the body?",
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey), // Set the border color
                    borderRadius:
                        BorderRadius.circular(8.0), // Set the border radius
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text("What cause? "),
                      SizedBox(width: 50),
                      DropdownButton<String>(
                        value: dropdownValueCause,
                        items: <String>[
                          'Trauma',
                          'Burn',
                          'Fracture',
                          'Bug bite',
                          'Spontaneous wound',
                          'Eschar',
                          'Other'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueCause = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                dropdownValueCause == 'Other'
                    ? Column(
                        children: [
                          SizedBox(height: 24),
                          Material(
                            child: TextField(
                              controller: _causeController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    "Please specify the cause of the wound",
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(height: 24),

                const SizedBox(height: 24),
                //MULTISELECT
                DropDownMultiSelect(
                  options: diseases,
                  selectedValues: selectedDiseases,
                  onChanged: (value) {
                    selectedDiseases = value;
                  },
                  whenEmpty:
                      "Select associated diseases", // Adding the displayText parameter
                ),

                const SizedBox(
                  height: 24,
                ),
                dropdownValueAssociatedDisease == 'Other'
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Material(
                            child: TextField(
                              controller: _diseaseController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    "Please specify the cause of the wound",
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(height: 24),

                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.green.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        bool isOther = false;

                        for (int i = 0; i < selectedDiseases.length; i++) {
                          if (selectedDiseases[i] == 'Other') {
                            isOther = true;
                            selectedDiseases.remove(selectedDiseases[i]);
                            selectedDiseases
                                .add(_diseaseController.text.trim());
                          }
                        }
                        if (dropdownValueCause == 'Other') {
                          register1(
                            dateTime,
                            _regionController.text.trim(),
                            _causeController.text.trim(),
                            selectedDiseases,
                          );
                          WoundInfo userWoundInfo = WoundInfo(
                              dateTime,
                              _regionController.text.trim(),
                              _causeController.text.trim(),
                              selectedDiseases);
                        } else {
                          register1(
                            dateTime,
                            _regionController.text.trim(),
                            dropdownValueCause,
                            selectedDiseases,
                          );
                          WoundInfo userWoundInfo = WoundInfo(
                              dateTime,
                              _regionController.text.trim(),
                              dropdownValueCause,
                              selectedDiseases);
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: const EdgeInsets.only(left: 10, right: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 50,
          //enableFloatingNavBar: false,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: Colors.green.shade300,
            ),

            /// Camera
            DotNavigationBarItem(
              icon: const Icon(Icons.camera_alt_rounded),
              selectedColor: Colors.green.shade300,
            ),

            /// Shop
            DotNavigationBarItem(
              icon: const Icon(Icons.medical_information),
              selectedColor: Colors.green.shade300,
            ),
          ],
        ),
      ),
    );
  }

  //REGISTERING WOUND INFORMATION
  Future register1(DateTime date, String region, String cause,
      List<String> associated_diseases) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseFirestore.instance.collection('wound_data').add({
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'date of appearence': date,
        'region of body': region,
        'cause': cause,
        'associated diseases': associated_diseases,
      });
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const woundRegistration2()));
  }

  //DATE PICKER
  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
}

// REGISTERING STAGE 2

class woundRegistration2 extends StatefulWidget {
  const woundRegistration2({super.key});

  @override
  State<woundRegistration2> createState() => _woundRegistration2State();
}

String dropdownValueSecretionP = 'No';
String dropdownValueSecretionS = 'NA';
String dropdownValueSecretionC = 'NA';
String dropdownValueInfection = 'NA';
InfectionAnalysis userInfectionInfo =
                                InfectionAnalysis(
                                    dropdownValueSecretionP,
                                    dropdownValueSecretionS,
                                    dropdownValueSecretionC,
                                    dropdownValueInfection);

class _woundRegistration2State extends State<woundRegistration2> {
  @override
  //INFECTION SIGNS
  /*List<String> infections = [
    'NA',
    'Local redness',
    'Local warmth',
    'Fever',
    'Prostration/lack of appetite' 'Others'
  ];
  List<String> selectedInfections = [];*/

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Icon(
                    Icons.app_registration_outlined,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Image(
                      image: AssetImage(
                          "/Users/henriquesampaio/flutterspace/healMe/healme/assets/images/healMeLogo.png"),
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: const Text(
                        "Infection and secretion assessment",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Handle text overflow
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                //email textbox
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey), // Set the border color
                    borderRadius:
                        BorderRadius.circular(8.0), // Set the border radius
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text("Secretion presence: "),
                      SizedBox(width: 100),
                      DropdownButton<String>(
                        value: dropdownValueSecretionP,
                        items: <String>['Yes', 'No']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueSecretionP = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                //if secretion presence is selected
                dropdownValueSecretionP == 'Yes'
                    ? Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Set the border color
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text("Foul Smell: "),
                                SizedBox(width: 160),
                                DropdownButton<String>(
                                  value: dropdownValueSecretionS,
                                  items: <String>[
                                    'NA',
                                    'Weak',
                                    'Medium',
                                    'Strong'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValueSecretionS = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Set the border color
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text("Secretion Colour: "),
                                SizedBox(width: 95),
                                DropdownButton<String>(
                                  value: dropdownValueSecretionC,
                                  items: <String>[
                                    'NA',
                                    'Serous',
                                    'Haemoserous',
                                    'Purulent',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValueSecretionC = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Serous = clear yellow/straw colour"),
                          const SizedBox(height: 5),
                          const Text("Haemoserous = light pink/red and watery"),
                          const SizedBox(height: 5),
                          const Text(
                              "Purulent = viscous dull red/grey/greenish fluid"),
                          const SizedBox(height: 5),
                        ],
                      )
                    : const SizedBox(height: 0),

                //
                //
                // MULTISELECT - SIGNS OF INFECTION
                //
                //

                /*SizedBox(height: 24),
                DropDownMultiSelect(
                  options: infections,
                  selectedValues: selectedInfections,
                  onChanged: (value){
                    setState(() {
                      selectedInfections = value;
                    });
                  },
                ),*/

                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey), // Set the border color
                    borderRadius:
                        BorderRadius.circular(8.0), // Set the border radius
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text("Other infection signs"),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: dropdownValueInfection,
                        items: <String>[
                          'NA',
                          'Local redness',
                          'Local warmth',
                          'Fever',
                          'Prostration/lack of appetite',
                          'Others'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueInfection = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                dropdownValueInfection == 'Others'
                    ? Material(
                        child: TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Please state the sign of infection",
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.black)),
                        ),
                      )
                    : const SizedBox(height: 24),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        child: RawMaterialButton(
                          fillColor: Colors.green.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const woundRegisterPage()));
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 100,
                        child: RawMaterialButton(
                          fillColor: Colors.green.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            register2(
                                dropdownValueSecretionP,
                                dropdownValueSecretionS,
                                dropdownValueSecretionC,
                                dropdownValueInfection);

                            InfectionAnalysis userInfectionInfo =
                                InfectionAnalysis(
                                    dropdownValueSecretionP,
                                    dropdownValueSecretionS,
                                    dropdownValueSecretionC,
                                    dropdownValueInfection);
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future register2(String secretion_presence, String secretion_smell,
      String secretion_color, String infection) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseFirestore.instance
          .collection('wound_infection_assessments')
          .add({
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'secretion presence': secretion_presence,
        'secretion smell': secretion_smell,
        'secretion color': secretion_color,
        'signs of infection': infection,
      });
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Camera()));
  }
}

// CAMERA

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      this.image = imageTemporary;
    } on PlatformException catch (e) {
      print("failed to pick image");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
          child: Column(
        children: [
          //SELECT FROM GALLERY
          const Row(
            children: [
              Image(
                image: AssetImage(
                    "/Users/henriquesampaio/flutterspace/healMe/healme/assets/images/healMeLogo.png"), // Update the path
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10),
              Flexible(
                // Wrap the Text widget with Flexible
                child: Text(
                  "Wound Image Upload",
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ),
            ],
          ),

          const Text(
            "Select from gallery",
            style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: const Icon(
                Icons.insert_drive_file,
              )),

          SizedBox(height: 24),

          //TAKE A PICTURE
          const Text(
            "Take picture now",
            style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () => pickImage(ImageSource.camera),
              icon: const Icon(
                Icons.camera,
              )),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100,
                  child: RawMaterialButton(
                    fillColor: Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const woundRegistration2()));
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 100,
                  child: RawMaterialButton(
                    fillColor: Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      if (image != null) {
                        uploadPhoto(image!);
                      }

                      //run the seach function
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
            ],
          ),
        ],
      )),
    );
  }

  Future uploadPhoto(File photo) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseFirestore.instance.collection('wound_data').add({
        'photo': photo,
      });
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const treatmentSuggestion()));
  }
}


//Making a treatment suggestion

class treatmentSuggestion extends StatefulWidget {
  const treatmentSuggestion({super.key});

  @override
  State<treatmentSuggestion> createState() => _treatmentSuggestionState();
}

final userID = getCurrentUserId();
final age = fetchUserAge(userID);
final sex = fetchUserSex(userID);

class _treatmentSuggestionState extends State<treatmentSuggestion> {

  final matchedPatients = searchFunction(userWoundInfo, userInfectionInfo,);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
           SizedBox(
                  width: 100,
                  child: RawMaterialButton(
                    fillColor: Colors.green.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      print(matchedPatients);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Profile()));
                    },
                    child: const Text(
                      "Get matched paients",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
           )),
      ],)
    );
  }

}
//fetching the sex and age
Future<int?> fetchUserAge(String? userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      int age = userDoc['age'];
      return age;
    } else {
      print('No data found for user ID: $userId');
    }

}

//fetch user age
Future<String?> fetchUserSex(String? userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String sex = userDoc['sex'];
      return sex;
    } else {
      print('No data found for user ID: $userId');
    }

}

//fetching the user id
String? getCurrentUserId() {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? currentUser = _auth.currentUser;

  if (currentUser != null) {
    return currentUser.uid;
  } else {
    print('No user is currently signed in.');
  }
}
