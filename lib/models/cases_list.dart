import 'package:maverick_red_2245/models/cases_state.dart';

class CasesList {
  List<CasesState> cases;

  CasesList({this.cases});

  factory CasesList.fromJson(Map<String, dynamic> json) {
    var data = json['statewise'];
    print("came");
    print(data.toString());
    print(data.length);
    List<CasesState> cases_copy = new List<CasesState>();

    for (int i = 0; i < data.length; i++) {
      print(data[i]['active']);
      print(data[i]['state']);
      cases_copy.add(
        CasesState(
          active: data[i]['active'],
          confirmed: data[i]['confirmed'],
          deaths: data[i]['deaths'],
          lastupdated: data[i]['lastupdatedtime'],
          recovered: data[i]['recovered'],
          state: data[i]['state'],
          statecode: data[i]['statecode'],
        ),
      );
    }
    print(cases_copy.toList());
    return CasesList(
      cases: cases_copy,
    );
  }
}
