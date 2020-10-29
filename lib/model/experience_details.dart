class ExperienceDetails {
  String context;
  String missions;

  ExperienceDetails({this.context, this.missions});

  ExperienceDetails.fromJson(Map<String, dynamic> json) {
    context = json['context'];
    missions = json['missions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['context'] = this.context;
    data['missions'] = this.missions;
    return data;
  }
}
