enum UserType {
  unset,
  customer,
  ticketer,
  arranger,
}

abstract class IDAOUser {
  late UserType userType = UserType.unset;
  Future<int> getBalance();
}
