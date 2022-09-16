class UserModel {
  final String name;
  final String email;
  final String department;
  final String previousRes;
  final String repReansons;
  final int grade;
  final int votes;
  final double gpa;
  final bool isCandidate;
  final bool voted;

  UserModel({
    required this.name,
    required this.email,
    required this.department,
    this.previousRes = '',
    this.repReansons = '',
    this.grade = 2,
    this.votes = 0,
    this.gpa = 2,
    this.isCandidate = false,
    this.voted = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['data']['user']['name'],
      email: json['data']['user']['email'],
      department: json['data']['user']['department'],
      gpa: json['data']['user']['gpa'],
      grade: json['data']['user']['grade'],
      isCandidate: json['data']['user']['isCandidate'],
      previousRes: json['data']['user']['previousRes'],
      repReansons: json['data']['user']['repReansons'],
      voted: json['data']['user']['voted'],
      votes: json['data']['user']['votes'],
    );
  }
}
