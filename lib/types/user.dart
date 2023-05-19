
import 'package:dao_ticketer/types/user/user.dart';

class DAOUser extends IDAOUser {
  @override
  late final String name;

  @override
  late final String secret;

  DAOUser({required this.name, required this.secret});

  factory DAOUser.fromJson(Map<String, dynamic> json) {
    return DAOUser(name: json['name'], secret: json['secret']);
  }
}
