# Socket.io Event Contract — AI Elderly Assistant

Status: DRAFT — pending backend team review. Update this file whenever an event or field changes; do not let the contract drift from what's actually implemented on either side.

## Connection
- Namespace/URL: [يتحدد مع الباك اند]
- Auth: [يتحدد — token في الـ handshake؟ query param؟]

## Events: Server → Client (Flutter listens)

### elder_status_update
Transient — live status only, not persisted per-update in the DB.

```json
{
  "elderId": "string (required)",
  "status": "active | idle | alert (required)",
  "timestamp": "ISO8601 string (required)",
  "location": "string (optional, nullable)"
}
```

### alert_triggered
Persisted — this event corresponds to a row in Postgres (alerts table).

```json
{
  "alertId": "string (required)",
  "elderId": "string (required)",
  "alertType": "string (required)",
  "severity": "low | medium | high (required)",
  "timestamp": "ISO8601 string (required)"
}
```

### connection_ack
Sent once on successful connection.

```json
{
  "connected": "boolean (required)",
  "elderId": "string (required)"
}
```

## Events: Client → Server (Flutter emits)
- [يتحدد — هل فلاتر هيبعت أي حاجة للسيرفر، ولا الاتجاه من السيرفر بس؟]

## Open Questions (resolve with backend team before implementing)
- [ ] Confirm namespace/URL and auth mechanism
- [ ] Confirm every field's required/optional status explicitly — no ambiguous fields
- [ ] Confirm whether Flutter needs to emit any events, or read-only
- [ ] Confirm reconnection behavior expected from client (does server track missed events?)