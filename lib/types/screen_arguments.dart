import "package:dao_ticketer/types/event.dart";
import "package:dao_ticketer/types/ticket.dart";

/// Shared Screens
class HomeScreenArguments {
  final String selectedSecret;
  final String selectedUserName;

  HomeScreenArguments(this.selectedSecret, this.selectedUserName);
}

class TicketScreenArguments {
  final Ticket ticket;
  final Event event;

  TicketScreenArguments(this.ticket, this.event);
}

class CustomerTicketPurchaseScreenArguments {
  final Event event;

  CustomerTicketPurchaseScreenArguments(this.event);
}

/// Customer argumented screens
class CustomerGenerateQRScreenArguments {
  final Ticket ticket;

  CustomerGenerateQRScreenArguments(this.ticket);
}

/// Issuer argumented screens
class IssuerEventScreenArguments {
  Event? event;
  String? eventID;

  IssuerEventScreenArguments(this.event, this.eventID);
}
