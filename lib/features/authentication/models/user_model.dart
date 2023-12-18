enum Status { pending, completed }

enum SubscriptionType { silver, gold, platinum }

class UserModel {
  final String uid;
  final String userName;
  final DateTime createdAt;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final String emailId;
  final String mobileNo;
  final Status paymentStatus;
  final SubscriptionType subscriptionType;

  UserModel(
      {required this.createdAt,
      required this.subscriptionStartDate,
      required this.subscriptionEndDate,
      required this.emailId,
      required this.mobileNo,
      required this.uid,
      required this.paymentStatus,
      required this.subscriptionType,
      required this.userName});

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
        createdAt: json["createdAt"],
        subscriptionStartDate: json["subscriptionStartDate"],
        subscriptionEndDate: json["subscriptionEndDate"],
        emailId: json["emailId"],
        mobileNo: json["mobileNo"],
        uid: json["uid"],
        subscriptionType: json["subscriptionType"] ?? SubscriptionType.gold,
        paymentStatus: json["paymentStatus"],
        userName: json["userName"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "subscriptionStartDate": subscriptionStartDate,
      "subscriptionEndDate": subscriptionEndDate,
      "emailId": emailId,
      "mobileNo": mobileNo,
      "uid": uid,
      "paymentStatus": paymentStatus,
      "subscriptionType": subscriptionType,
      "userName": userName
    };
  }

  UserModel cloneWith(
      {uid,
      emailId,
      userName,
      paymentStatus,
      mobileNo,
      subscriptionType,
      createdAt,
      subscriptionEndDate,
      subscriptionStartDate}) {
    return UserModel(
      uid: uid ?? this.uid,
      emailId: emailId ?? this.emailId,
      userName: userName ?? this.userName,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      mobileNo: mobileNo ?? this.mobileNo,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      createdAt: createdAt ?? this.createdAt,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
    );
  }
}
