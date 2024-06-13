


class EmploymentInfo {
  String company;
  String position;
  String startMonthYear;
  String endMonthYear;

  EmploymentInfo({
    required this.company,
    required this.position,
    required this.startMonthYear,
    required this.endMonthYear,
  });

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startMonthYear': startMonthYear,
      'endMonthYear': endMonthYear,
    };
  }
}

