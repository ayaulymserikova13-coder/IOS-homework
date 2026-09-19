void checkBalance({
  required String name,
  required double balance,
}) => print('$name, your available balance is $balance');

double deposit({
  required double currentBalance,
  double? amount,
}) {
  double depositAmount=amount ?? 0.0;

  if (depositAmount<=0) {
    print('Invalid deposit amount');
    return currentBalance;
  }

  double updatedBalance=currentBalance+depositAmount;
  print('Deposit successful: $depositAmount');
  print('Updated balance: $updatedBalance');
  return updatedBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int enteredPin=pinCode ?? 0000;

  if (enteredPin!=1234) {
    print('Incorrect PIN. Transaction declined.');
    return currentBalance;
  }

  double withdrawAmount=amount ?? 0.0;

  if (withdrawAmount<=0) {
    print('Invalid withdrawal amount');
    return currentBalance;
  }

  if (withdrawAmount>currentBalance) {
    print('Insufficient funds.Transaction declined.');
    return currentBalance;
  }

  double updatedBalance=currentBalance-withdrawAmount;
  print('Withdrawal successful for $name: $withdrawAmount');
  print('Updated balance: $updatedBalance');
  return updatedBalance;
}
void main() {
  String? userName='Ayaulym';
  double balance=10000.0;
  checkBalance(
    name: userName,
    balance: balance,
  );
  balance=deposit(
    currentBalance: balance,
    amount: 5000.0,
  );
  balance=withdraw(
    name: userName,
    currentBalance: balance,
    amount: 3000.0,
    pinCode: 1234,
  );
  checkBalance(
    name: userName,
    balance: balance,
  );
}