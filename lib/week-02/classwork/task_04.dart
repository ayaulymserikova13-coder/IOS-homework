void main() {
  List<int> numbers=[14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1=[234, 34, 123, 44, 949, 112, 67];

  int min=numbers[0];
  int max=numbers[0];
  for (int number in numbers) {
    if (number<min) {
      min=number;
    }
    if (number>max) {
      max=number;
    }
  }

  int min1=numbers1[0];
  int max1=numbers1[0];
  for (int number in numbers1) {
    if (number<min1) {
      min1=number;
    }
    if (number>max1) {
      max1=number;
    }
  }

  print('First list: max = $max, min = $min');
  print('Second list: max = $max1, min = $min1');
}