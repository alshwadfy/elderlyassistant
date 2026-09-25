# Backend Integration Proposal & API Specifications

**Document Version:** 1.0.0  
**Target:** Node.js Core Backend & Python AI Microservice Teams  
**Sender:** Flutter Mobile Client (Ezz al-din)  

---

## 1. Overview & Objectives

The Flutter client provides the voice-first user interface for the elderly user. To finalize end-to-end integration, we propose the following REST API contracts and Socket.io real-time event schemas.

---

## 2. Real-Time Socket.io Contract

### 2.1 Connection Details
- **Protocol:** Socket.io v4 (`transports: ['websocket', 'polling']`)
- **Proposed Base Path / Namespace:** `/` or `/socket.io/`
- **Handshake Authentication:** We propose sending a JWT Bearer token inside `auth`:
  ```javascript
  // Client connection config
  io("https://api.domain.com", {
    auth: { token: "JWT_ACCESS_TOKEN" },
    query: { elderId: "ELDER_UUID" }
  });
  ```

### 2.2 Server-to-Client Events (Client Listens)

#### `connection_ack`
Sent by the backend immediately upon successful handshake:
```json
{
  "connected": true,
  "elderId": "string (UUID)",
  "serverTime": "2026-09-25T03:30:00Z"
}
```

#### `elder_status_update`
Emitted periodically or on activity changes (e.g. from wearable, voice, or sensor):
```json
{
  "elderId": "string (UUID)",
  "status": "active" | "idle" | "alert",
  "timestamp": "ISO8601 string",
  "location": "string (optional, e.g. Living Room)"
}
```

#### `alert_triggered`
Emitted immediately when an emergency, fall, or critical anomaly is detected:
```json
{
  "alertId": "string (UUID)",
  "elderId": "string (UUID)",
  "alertType": "fall_detected" | "sos_button" | "missed_medication" | "abnormal_vitals",
  "severity": "low" | "medium" | "high",
  "timestamp": "ISO8601 string"
}
```

### 2.3 Client-to-Server Events (Client Emits)

#### `ack_alert`
When the elder acknowledges or dismisses an alert prompt:
```json
{
  "alertId": "string (UUID)",
  "elderId": "string (UUID)",
  "action": "dismissed" | "need_help",
  "timestamp": "ISO8601 string"
}
```

---

## 3. REST API Endpoints Specification

### 3.1 Authentication
- **`POST /api/v1/auth/login`**
  - **Body:** `{ "phone": "+201...", "pin": "1234" }`
  - **Response (200):**
    ```json
    {
      "token": "JWT_STRING",
      "user": {
        "id": "UUID",
        "name": "Adel Mahmoud",
        "phone": "+201..."
      }
    }
    ```

### 3.2 Doctors Directory & Appointments
- **`GET /api/v1/doctors`**
  - **Query Params:** `query` (string), `specialty` (optional)
  - **Response (200):**
    ```json
    [
      {
        "provider_id": "doc_001",
        "name": "Dr. Sarah Jenkins",
        "type": "General Practitioner",
        "address": "452 Elm Street, Suite 3B",
        "distance_km": 1.2,
        "estimated_minutes": 15
      }
    ]
    ```

- **`POST /api/v1/appointments`**
  - **Body:**
    ```json
    {
      "doctor_id": "doc_001",
      "scheduled_time": "2026-09-28T10:00:00Z",
      "notes": "Regular checkup"
    }
    ```
  - **Response (201):** Created appointment details.

### 3.3 Reminders (Medications & Tasks)
- **`GET /api/v1/reminders?user_id={id}`**
  - **Response (200):**
    ```json
    [
      {
        "reminder_id": "rem_101",
        "user_id": "usr_001",
        "type": "medication",
        "title": "Blood Pressure Pill (Amlodipine)",
        "scheduled_time": "2026-09-25T08:00:00Z",
        "repeat_pattern": "daily",
        "status": "pending"
      }
    ]
    ```

- **`PATCH /api/v1/reminders/{id}/status`**
  - **Body:** `{ "status": "completed" }`
  - **Response (200):** Updated reminder.

### 3.4 Voice Interaction & AI Microservice
- **`POST /api/v1/ai/voice-interaction`**
  - **Body:**
    ```json
    {
      "user_id": "usr_001",
      "audio_url": "https://...",
      "transcript": "Remind me to take my medicine at 8 PM"
    }
    ```
  - **Response (200):**
    ```json
    {
      "interaction_id": "int_901",
      "user_id": "usr_001",
      "transcript": "Remind me to take my medicine at 8 PM",
      "detected_intent": "SET_REMINDER",
      "response_text": "I set a reminder for your medicine at 8:00 PM.",
      "timestamp": "2026-09-25T03:30:00Z"
    }
    ```

---

## 4. Key Questions for Backend Team

1. **Authentication:** Do you prefer auth token in `socket.handshake.auth.token` or in HTTP headers?
2. **Naming convention:** Are backend JSON keys `snake_case` or `camelCase`? (Client currently expects `snake_case` in models).
3. **Base URLs:** What are the local, staging, and production URLs for:
   - Node.js Core Backend
   - Python AI Microservice
   - Socket.io instance
