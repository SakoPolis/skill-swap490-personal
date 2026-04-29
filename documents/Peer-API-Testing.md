# Peer API Testing Template & Results

Project: Skill Swap (skill-swap490-personal)

---

## Individual Cloud API (example)

- **API Name:** `CreateSwapRequest`
- **Purpose:** Let a user request a skill swap (book a lesson swap) with another user.
- **Method:** POST
- **Cloud Service:** Firebase Cloud Functions (HTTP)
- **Input (JSON):
  - `requesterId` (string)
  - `providerId` (string)
  - `lessonId` (string)
  - `proposedDate` (ISO8601 string)
  - `message` (string, optional)
- **Output (JSON):** `success`, `swapId`, `status`, `createdAt`
- **Related Module:** `request_swap.dart` + Cloud Function `createSwapRequest`
- **Related DB Collections:** `swaps`, `users`, `lessons`

### Sample Request
```json
{
  "requesterId": "user_123",
  "providerId": "user_456",
  "lessonId": "lesson_789",
  "proposedDate": "2026-05-03T18:00:00Z",
  "message": "Can we meet for 60 minutes?"
}
```

### Sample Response
```json
{
  "success": true,
  "swapId": "swap_ab12",
  "status": "pending",
  "createdAt": "2026-04-28T14:02:00Z"
}
```

### Error Cases
- 400 Bad Request — missing required field
- 401 Unauthorized — invalid auth
- 404 Not Found — provider or lesson not found
- 409 Conflict — lesson already booked at proposed time

---

## Team Cloud APIs (minimum 2)

### API: `GetUserProfile`
- **Purpose:** Retrieve public profile and rating for a user.
- **Method:** GET
- **Input (query):** `userId`
- **Output:** `userId`, `displayName`, `avatarUrl`, `bio`, `skills`, `rating`, `memberSince`
- **Related Module:** `user_profile.dart`
- **DB Collections:** `users`, `ratings`

Sample Request: `GET /getUserProfile?userId=user_456`

Sample Response:
```json
{
  "userId":"user_456",
  "displayName":"Alex Kim",
  "avatarUrl":"https://.../avatar.jpg",
  "bio":"Guitar teacher and web dev",
  "skills":["Guitar","HTML","CSS"],
  "rating":4.8,
  "memberSince":"2024-02-10T12:00:00Z"
}
```

Errors:
- 400 — missing `userId`
- 404 — user not found
- 500 — DB read error

### API: `SearchLessons`
- **Purpose:** Search available lessons/swaps by skill, location, date, or keyword.
- **Method:** GET
- **Input (query):** `q`, `skill`, `location`, `availableAfter`, `limit`, `cursor`
- **Output:** `results` (array), `nextCursor`
- **Related Module:** `browse.dart`, `category_results.dart`
- **DB Collections / Indexes:** `lessons`, `lesson_search_index`

Sample Request: `GET /searchLessons?skill=Guitar&availableAfter=2026-05-01T00:00:00Z&limit=10`

Sample Response:
```json
{
  "results":[
    {
      "lessonId":"lesson_789",
      "providerId":"user_456",
      "title":"Beginner Guitar: Chords",
      "skill":"Guitar",
      "nextAvailable":"2026-05-03T18:00:00Z",
      "price":0
    }
  ],
  "nextCursor": null
}
```

Errors:
- 400 — invalid `availableAfter` format
- 422 — `limit` exceeds allowed max
- 500 — search index timeout

---

## Peer API Testing Template (to complete during session)

- **Team Tested:** [Team Name]
- **APIs Tested:** [list of API names]

For each API tested include:

- **API:** `API Name`
- **What is good:**
  - Bullet points describing strengths
- **Issues found:**
  1. Numbered issue with short reproduction steps
  2. Another issue
- **Suggestions for improvement:**
  - Bullet suggestions

Repeat the above for each API.

---

## Example Peer Testing Results

- **Team Tested:** Team Phoenix
- **APIs Tested:** `CreateSwapRequest`, `SearchLessons`, `GetUserProfile`

API: `CreateSwapRequest`
- What is good:
  - Clear required fields and expected status (`pending`).
  - Response returns `swapId` and `createdAt`.
- Issues found:
  1. 400 response returns HTML error page when `lessonId` missing (repro: POST with empty `lessonId`). Should return JSON.
  2. Timezone ambiguity: `proposedDate` accepted without timezone; server treats non-Z dates inconsistently.
- Suggestions:
  - Return structured JSON errors consistently (e.g., `{success:false, errorCode:"MISSING_FIELD", message:"lessonId required"}`).
  - Validate and require ISO8601 with timezone or normalize to UTC.

API: `SearchLessons`
- What is good:
  - Pagination via `cursor` works and `nextCursor` provided.
- Issues found:
  1. 422 returned when `limit=100` but message unclear; should specify max limit.
  2. `location` search returns irrelevant results; fuzzy rules undocumented.
- Suggestions:
  - Document max `limit` and include it in 422 response.
  - Clarify search matching behavior (exact vs fuzzy) in docs.

API: `GetUserProfile`
- What is good:
  - Returns `rating` and `skills` arrays; schema is stable.
- Issues found:
  1. Requesting an inactive user returns 200 with empty `skills` array—should indicate user `status` or return 404.
- Suggestions:
  - Add `status` field (`active|inactive|banned`) to the profile response.

---

## Submission Checklist

- Individual Cloud API spec (required)
- Team Cloud APIs (>=2)
- Request/Response examples for each API
- At least two error cases per API
- Peer testing results filled in using the template above
- Save as PDF or Word and submit via Canvas

---

If you'd like, I can also generate a Word (`.docx`) version of this file or convert it to a PDF for submission.
