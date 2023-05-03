enum TicketCategory {
  all,
  parter,
  lodge,
}

class Ticket {
  late final String category;
  late final int price;
  late final int sector;
  late final int row;
  late final int number;
  late final String eventID;
  Ticket(this.category, this.price, this.sector, this.row, this.number,
      this.eventID);
}
