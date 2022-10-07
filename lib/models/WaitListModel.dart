class WaitListModel {
  String? cellphone;
  int? finalPageSend;
  String? lastname;
  // int? waitGuestTime;
  String? sitwear;
  String? color;
  String? proImage;
  int? minutesOutput;
  String? firstname;
  int? waitid;
  String? action;
  String? class1;
  String? krowdWaitListNumberOfPeople;

  WaitListModel(
      {this.cellphone,
      this.finalPageSend,
      this.lastname,
      // this.waitGuestTime,
      this.sitwear,
      this.color,
      this.proImage,
      this.minutesOutput,
      this.firstname,
      this.waitid,
      this.action,
      this.class1,
      this.krowdWaitListNumberOfPeople});

  WaitListModel.fromJson(Map<String, dynamic> json) {
    cellphone = json['cellphone'];
    finalPageSend = json['finalPageSend'];
    lastname = json['lastname'];
    // waitGuestTime = json['wait_guest_time'];
    sitwear = json['sitwear'];
    color = json['color'];
    proImage = json['Pro_image'];
    minutesOutput = json['MinutesOutput'];
    firstname = json['firstname'];
    waitid = json['waitid'];
    action = json['action'];
    class1 = json['class'];
    krowdWaitListNumberOfPeople = json['krowdWaitListNumberOfPeople'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cellphone'] = cellphone;
    data['finalPageSend'] = finalPageSend;
    data['lastname'] = lastname;
    //data['wait_guest_time'] = waitGuestTime;
    data['sitwear'] = sitwear;
    data['color'] = color;
    data['Pro_image'] = proImage;
    data['MinutesOutput'] = minutesOutput;
    data['firstname'] = firstname;
    data['waitid'] = waitid;
    data['action'] = action;
    data['class'] = class1;
    data['krowdWaitListNumberOfPeople'] = krowdWaitListNumberOfPeople;
    return data;
  }
}
