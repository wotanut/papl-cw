class Flight {
  final String callsign;
  final String dep;
  final String dest;
  final String altn;
  final String ete;

  const Flight(
      {required this.callsign,
      required this.ete,
      required this.altn,
      required this.dest,
      required this.dep});

  factory Flight.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'dep': String dep,
        'dest': String dest,
        'altn': String altn,
        'ete': String ete,
      } =>
        Flight(
          dep: dep,
          dest: dest,
          altn: altn,
          ete: ete,
          callsign: id,
        ),
      _ => throw const FormatException('Failed to load flight.'),
    };
  }
}
