class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(
    this.title,
    this.author,
    this.price,
    {this.isBorrowed=false}
  );
}

class Library {
  List<Book> _books=[];

  void addBook(Book book) {
    _books.add(book);
  }

  getAvailableBooks() {
    return _books.where((book)=>book.isBorrowed==false);
  }

  double getTotalValue() {
    return _books.fold(0.0,(total,book)=>total+book.price);
  }
}
void main() {
  Library library=Library();
  library.addBook(Book('The Lord of the Rings','J.R.R. Tolkien',30.0));
  library.addBook(Book('The Hunger Games','Suzanne Collins',20.0,isBorrowed: true));
  library.addBook(Book('Harry Potter','J.K. Rowling',25.0));
  library.addBook(Book('The Little Prince','Antoine de Saint-Exupery',15.0));

  var availableBooks=library.getAvailableBooks();
  print('Available books:');
  for (var book in availableBooks) {
    print('${book.title} by ${book.author}');
  }
  print('Total collection value: ${library.getTotalValue()}');
}