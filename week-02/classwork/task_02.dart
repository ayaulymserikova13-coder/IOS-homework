void main() {
  int day=28;
  int month=2;
  int year=2100;

  String originalDate ='${day.toString().padLeft(2, '0')}.' '${month.toString().padLeft(2, '0')}.' '$year';

  bool isLeapYear=year%400==0 || (year%4==0 && year%100!=0);

  int daysInMonth=0;

  if (month==2) {
    if (isLeapYear) {
      daysInMonth=29;
    } else {
      daysInMonth=28;
    }
  } else if (month==4 || month==6 || month==9 || month==11) {
    daysInMonth=30;
  } else if (month>=1 && month<=12) {
    daysInMonth=31;
  }

  if (month<1 || month>12 || day<1 || day>daysInMonth) {
    print('$originalDate -> invalid date');
  } else {
    day++;

    if (day>daysInMonth) {
      day=1;
      month++;
    }

    if (month>12) {
      month=1;
      year++;
    }

    String nextDate= '${day.toString().padLeft(2, '0')}.' '${month.toString().padLeft(2, '0')}.' '$year';
    print('$originalDate -> $nextDate');
  }
}