class Cases {
  String active;
  String confirmed;
  String deaths;
  String recovered;
  String lastupdate;

  Cases(
      {this.active,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.lastupdate});

  factory Cases.fromJson(Map<String, dynamic> json) {
    var data = json['statewise'][0];
    return Cases(
      active: data['active'],
      confirmed: data['confirmed'],
      deaths: data['deaths'],
      recovered: data['recovered'],
      lastupdate: data['lastupdatedtime'],
    );
  }
}
