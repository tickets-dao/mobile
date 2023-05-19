import 'package:dao_ticketer/screens/user_selection.dart'
    show UserSelectionWidget;
import 'package:dao_ticketer/screens/customer/ticket_purchase.dart';
import 'package:dao_ticketer/screens/customer/event_list.dart';
import 'package:dao_ticketer/screens/issuer/event.dart';
import 'package:dao_ticketer/screens/issuer/event_creation.dart';
import 'package:dao_ticketer/screens/issuer/event_list.dart';
import 'package:dao_ticketer/screens/shared/balance.dart';
import 'package:dao_ticketer/screens/customer/render_qr.dart';
import 'package:dao_ticketer/screens/home.dart';
import 'package:dao_ticketer/screens/shared/ticket.dart';
import 'package:dao_ticketer/screens/shared/tickets_list.dart';
import 'package:dao_ticketer/screens/ticketer/scan_qr.dart';
import 'package:dao_ticketer/types/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:dao_ticketer/types/route_names.dart';

Map<String, WidgetBuilder> appRoutes = {
  AppRouteName.userSelect: (context) => const UserSelectionWidget(),
  '/home': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;
    return HomeScreen(selectedFile: args.selectedFile);
  },
  AppRouteName.userBalance: (context) => const BalanceScreen(),
  AppRouteName.userTickets: (context) => const TicketListScreen(),
  AppRouteName.userTicket: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TicketScreenArguments;
    return TicketScreen(ticket: args.ticket, event: args.event);
  },
  AppRouteName.customerEvents: (context) => const EventsListScreen(),
  AppRouteName.customerTicketPurchase: (context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as CustomerTicketPurchaseScreenArguments;
    return TicketPurchaseScreen(event: args.event);
  },
  AppRouteName.customerGenerateQR: (context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as CustomerGenerateQRScreenArguments;
    return GenerateScreen(ticket: args.ticket);
  },
  AppRouteName.issuerEventCreation: (context) => const EventCreationScreen(),
  AppRouteName.issuerEventList: (context) => const IssuerEventsListScreen(),
  AppRouteName.issuerEvent: (context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as IssuerEventScreenArguments;
    return IssuerEventScreen(event: args.event, eventID: args.eventID);
  },
  AppRouteName.ticketerScan: (context) => const ScanScreen(),
};
