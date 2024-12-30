class Flight {
  final String callsign;
  final String departure;
  final String dest;
  final String altn;
  final String ete;

  const Flight(
      {required this.callsign,
      required this.ete,
      required this.altn,
      required this.dest,
      required this.departure});

  factory Flight.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'callsign': String callsign,
        'departure': String departure,
        'dest': String dest,
        'altn': String altn,
        'ete': String ete,
      } =>
        Flight(
          departure: departure,
          dest: dest,
          altn: altn,
          ete: ete,
          callsign: callsign,
        ),
      _ => throw const FormatException('Failed to load flight.'),
    };
  }
}
