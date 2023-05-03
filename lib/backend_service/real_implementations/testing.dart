import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';

Future<void> main() async {
  final realService = RealDAOService();

  print(await realService.getCategories("eventID"));
  print(await realService.getEvents());

}
