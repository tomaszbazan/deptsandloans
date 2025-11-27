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
