# Black Jack Tracking — Customer App

Fully functional Flutter customer tracking experience for snow removal in Revelstoke, BC.

## Working features

- **Live tracking** with auto GPS updates (every 4s), pause/resume, manual refresh
- **Proximity alerts** when the plow is within 5 stops
- **Live map** with route progress, operator position, and completion state
- **Daily temperature** from Open-Meteo (live API + offline fallback)
- **Completion timestamp** when service finishes
- **Star rating**
  - 5★ → opens Google Reviews
  - under 5★ → saved as internal admin feedback
- **Profile preferences** persisted locally (SMS / email / proximity)
- **Activity log** of tracking events
- **Restart tracking** from Profile

No invoicing or payment gateways.

## Run

```bash
flutter pub get
flutter run -d chrome
```
