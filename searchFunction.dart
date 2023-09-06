import 'package:cloud_firestore/cloud_firestore.dart';

class WoundInfo {
  DateTime dateOfAppearance;
  String regionOfBody;
  String cause;
  List<String> associatedDiseases;

  WoundInfo(this.dateOfAppearance, this.regionOfBody, this.cause, this.associatedDiseases);
}

class InfectionAnalysis {
  String secretionPresence;
  String secretionSmell;
  String secretionColor;
  String otherSignsOfInfection;

  InfectionAnalysis(this.secretionPresence, this.secretionSmell, this.secretionColor, this.otherSignsOfInfection);
}

Future<List<DocumentSnapshot>> searchFunction(WoundInfo woundInfo, InfectionAnalysis infectionAnalysis,) async {
  final woundCollection = FirebaseFirestore.instance.collection('wound_data');
  final infectionCollection = FirebaseFirestore.instance.collection('wound_infection_assessments');
  final userCollection = FirebaseFirestore.instance.collection('users'); 

  // 1. Filter based on wound information.
  Query woundQuery = woundCollection
      .where('region of body', isEqualTo: woundInfo.regionOfBody)
      .where('cause', isEqualTo: woundInfo.cause);

  // For associated diseases
  //for (String disease in woundInfo.associatedDiseases) {
  //  woundQuery = woundQuery.where('associatedDiseases', arrayContains: disease);
  //}

  final woundDocs = await woundQuery.get();

  // 2. Narrowing down the search based on infection analysis.
  Query infectionQuery = infectionCollection
      .where('secretion presence', isEqualTo: infectionAnalysis.secretionPresence)
      .where('secretion smell', isEqualTo: infectionAnalysis.secretionSmell)
      .where('secretion color', isEqualTo: infectionAnalysis.secretionColor)
      .where('signs of infection', isEqualTo: infectionAnalysis.otherSignsOfInfection);

  final infectionDocs = await infectionQuery.get();

  // two lists: woundDocs and infectionDocs.
  List<String> matchingPatientIds = [];
  for (var woundDoc in woundDocs.docs) {
    for (var infectionDoc in infectionDocs.docs) {
      if (woundDoc.id == infectionDoc.id) {  
        matchingPatientIds.add(woundDoc.id);
      }
    }
  }

  Query userQuery = userCollection.where(FieldPath.documentId, whereIn: matchingPatientIds);

  final userDocs = await userQuery.get();

  // 4. Return the top 6 patients
  return userDocs.docs.take(6).toList();
}
