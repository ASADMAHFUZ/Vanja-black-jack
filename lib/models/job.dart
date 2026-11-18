enum JobStatus { pending, enRoute, inProgress, completed }

class JobSite {
  final String id;
  final String name;
  final String customer;
  final String address;
  final String entryNotes;
  final double lat;
  final double lng;
  final JobStatus status;
  final String serviceType;
  final String eta;
  final double sqFt;
  final String estimatedSaltLbs;
  final List<String> workPlan;

  const JobSite({
    required this.id,
    required this.name,
    required this.customer,
    required this.address,
    required this.entryNotes,
    required this.lat,
    required this.lng,
    required this.status,
    required this.serviceType,
    required this.eta,
    required this.sqFt,
    required this.estimatedSaltLbs,
    required this.workPlan,
  });

  JobSite copyWith({JobStatus? status}) {
    return JobSite(
      id: id,
      name: name,
      customer: customer,
      address: address,
      entryNotes: entryNotes,
      lat: lat,
      lng: lng,
      status: status ?? this.status,
      serviceType: serviceType,
      eta: eta,
      sqFt: sqFt,
      estimatedSaltLbs: estimatedSaltLbs,
      workPlan: workPlan,
    );
  }
}

class MaterialLog {
  final String jobId;
  final String material;
  final double amount;
  final String unit;
  final DateTime loggedAt;

  const MaterialLog({
    required this.jobId,
    required this.material,
    required this.amount,
    required this.unit,
    required this.loggedAt,
  });
}
