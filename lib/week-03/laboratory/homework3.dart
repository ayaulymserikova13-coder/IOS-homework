abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);
  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading $title...');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;
  Audiobook(
    String id,
    String title,
    double price,
    this.durationHours,
    this.narrator,
  ) : super(id, title, price);

  @override
  String getDetails() {
    return 'Audiobook: $title, Price: $price, Duration: $durationHours hours, Narrator: $narrator';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;
  EBook(
    String id,
    String title,
    double price,
    this.fileSizeMB,
    this.author,
  ) :super(id, title, price);

  @override
  String getDetails() {
    return 'EBook: $title, Price: $price, Size: $fileSizeMB MB, Author: $author';
  }
}

class ShoppingCart {
  List<MediaItem> _items=[];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double total=_items.fold(0.0,(sum, item)=>sum+item.price,
    );
    return total+(total*taxRate);
  }

  filterByMaxPrice(double maxPrice) {
    return _items.where((item)=>item.price<=maxPrice);
  }

  void printReceipt() {
    for (var item in _items) {
      print(item.getDetails());

      if (item is Audiobook) {
        item.download(item.title);
      }
      if (item is EBook) {
        item.download(item.title);
      }
    }
  }
}
void main() {
  ShoppingCart cart=ShoppingCart();
  Audiobook audiobook=Audiobook('A1','The Lord of the Rings',30.0,20.0,'Andy Serkis',);
  EBook ebook=EBook('E1','The Hunger Games',20.0,5.0,'Suzanne Collins',);

  cart.addItem(audiobook);
  cart.addItem(ebook);
  cart.printReceipt();

  print('Total with tax: ${cart.calculateTotalWithTax()}');
  print('Items with price<=25:');

  var filteredItems=cart.filterByMaxPrice(25.0);
  for (var item in filteredItems) {
    print(item.getDetails());
  }
}