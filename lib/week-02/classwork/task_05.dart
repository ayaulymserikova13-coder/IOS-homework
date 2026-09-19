void main() {
  List<int> numbers=[3, 6];

  for (int number in numbers) {
    bool isPrime=true;
    if (number<=1) {
      isPrime=false;
    }

    for (int i=2; i<number; i++) {
      if (number%i==0) {
        isPrime=false;
        break;
      }
    }

    if (isPrime) {
      print('$number -> prime number');
    } else {
      print('$number -> not prime number');
    }
  }
}