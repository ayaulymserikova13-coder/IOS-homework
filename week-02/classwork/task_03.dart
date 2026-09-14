void main() {
  String text='flutter mobile development';
  int count=0;

  for (int i=0; i<text.length; i++) {
    String letter=text[i].toLowerCase();
    if (letter == 'a' || letter == 'e' || letter == 'i' || letter == 'o' || letter == 'u') {
      count++;
    }
  }

  print('Text: $text');
  print('Vowel count: $count');
}