import '../models/job.dart';

class DemoData {
  static const operatorName = 'Marcus Chen';
  static const crewId = 'CREW-04';
  static const vehicle = 'Plow Unit #12';

  static List<JobSite> jobs = [
    const JobSite(
      id: 'JOB-2401',
      name: 'Northgate Plaza',
      customer: 'Northgate Retail LLC',
      address: '1840 Industrial Blvd, Minneapolis, MN',
      entryNotes: 'Gate code 4582. Service rear lots first. Avoid loading dock.',
      lat: 44.9778,
      lng: -93.2650,
      status: JobStatus.pending,
      serviceType: 'Snow Clearance + Salt',
      eta: '12 min',
      sqFt: 42000,
      estimatedSaltLbs: '850',
      workPlan: [
        'Clear main parking lanes',
        'Push snow to designated pile zones',
        'Apply salt on walkways & entrances',
        'Capture before/after photos',
      ],
    ),
    const JobSite(
      id: 'JOB-2402',
      name: 'Riverside Medical',
      customer: 'Riverside Health Group',
      address: '920 River Rd, St. Paul, MN',
      entryNotes: 'Emergency bay must stay open. Use side entrance for trucks.',
      lat: 44.9537,
      lng: -93.0900,
      status: JobStatus.pending,
      serviceType: 'Ice Management',
      eta: '28 min',
      sqFt: 18500,
      estimatedSaltLbs: '420',
      workPlan: [
        'Treat ER entrance first',
        'Clear sidewalks & ADA ramps',
        'Apply de-icer on patient walkways',
      ],
    ),
    const JobSite(
      id: 'JOB-2403',
      name: 'Oakwood Apartments',
      customer: 'Oakwood Property Mgmt',
      address: '55 Oakwood Dr, Bloomington, MN',
      entryNotes: 'Resident parking only after 7am. Stack snow at west lot.',
      lat: 44.8408,
      lng: -93.2983,
      status: JobStatus.enRoute,
      serviceType: 'Plow + Sand',
      eta: 'On site soon',
      sqFt: 31000,
      estimatedSaltLbs: '600',
      workPlan: [
        'Clear driveway loops',
        'Sand icy corners near building B',
        'Verify dumpster access cleared',
      ],
    ),
    const JobSite(
      id: 'JOB-2404',
      name: 'Lakeside Office Park',
      customer: 'Lakeside Holdings',
      address: '400 Lake Ave, Edina, MN',
      entryNotes: 'Call site manager on arrival: (612) 555-0199',
      lat: 44.8897,
      lng: -93.3499,
      status: JobStatus.completed,
      serviceType: 'Seasonal Contract Visit',
      eta: 'Done',
      sqFt: 52000,
      estimatedSaltLbs: '1100',
      workPlan: [
        'Full lot plow',
        'Salt application per rate card',
        'Photo proof submitted',
      ],
    ),
  ];

  static List<MaterialLog> materialLogs = [
    MaterialLog(
      jobId: 'JOB-2404',
      material: 'Rock Salt',
      amount: 980,
      unit: 'lbs',
      loggedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    MaterialLog(
      jobId: 'JOB-2404',
      material: 'Sand',
      amount: 120,
      unit: 'lbs',
      loggedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
    ),
  ];
}
