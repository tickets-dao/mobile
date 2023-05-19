enum UserType {
  unset,
  customer,
  ticketer,
  issuer,
}

abstract class IDAOUser {
  late UserType userType = UserType.unset;
  late String name;
  late String secret;
}
