class TransactionNotFoundException implements Exception {
  final int id;

  const TransactionNotFoundException(this.id);

  @override
  String toString() => 'Transaction with id $id not found';
}

class TransactionRepositoryException implements Exception {
  final String message;
  final Object? cause;

  const TransactionRepositoryException(this.message, [this.cause]);

  @override
  String toString() => 'TransactionRepositoryException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}

class RepaymentNotFoundException implements Exception {
  final int id;

  const RepaymentNotFoundException(this.id);

  @override
  String toString() => 'Repayment with id $id not found';
}

class RepaymentRepositoryException implements Exception {
  final String message;
  final Object? cause;

  const RepaymentRepositoryException(this.message, [this.cause]);

  @override
  String toString() => 'RepaymentRepositoryException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}
