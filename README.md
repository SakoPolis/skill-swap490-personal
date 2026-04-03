# SkillSwap

SkillSwap is a cross-platform app (Web, iOS, Android) that helps people **learn new skills** and **share their expertise** through peer-to-peer exchanges.

This repository contains the source code for our Senior Design project (COMP 490), built with **Flutter (Dart)** and backed by **Firebase**.

---
=======

## Getting Started

### Run in GitHub Codespaces (Web)
1. Open this repo in **Codespaces**.
2. In the terminal, run:
   ```bash
   flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
   ```
3. Click the **Forwarded Port 8080** link to preview.


### Run Locally

1. Install Flutter: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. Clone the repo:
   ```bash
   git clone https://github.com/skill-swap490/skill-swap490.git
   cd skill-swap490
   ```
3. Run (web, using Chrome):
   ```bash
   flutter run -d chrome
   ```

---

## Project Structure

```text
skill-swap490/
├─ lib/                     # Main app code (Dart/Flutter)
│  ├─ screens/              # UI pages (Intro, Browse, Messages, etc.)
│  └─ services/             # App logic (Auth, Chat, Matching) [to be added]
├─ web/                     # Web entry (index.html), icons
├─ android/                 # Android scaffolding (Gradle, manifests)
├─ ios/                     # iOS scaffolding (Xcode project, plist)
├─ windows/ linux/ macos/   # Desktop scaffolding (optional)
├─ test/                    # Unit/widget tests
├─ pubspec.yaml             # Packages & app metadata (like package.json)
├─ pubspec.lock             # Locked dependency versions (auto-generated)
├─ analysis_options.yaml    # Lint rules
├─ docs/                    # Deliverables (PDFs, slides, reports)
└─ README.md
```


Ethical Issues

Privacy Expectations
The system collects sensitive student data, including technical skills, availability schedules, and experience levels. To meet privacy expectations, TeamMatch restricts access so that students cannot see the full class dataset; only instructors have this privilege. Furthermore, student data is not publicly accessible.

Discrimination & Fairness
A primary ethical risk in automated grouping is the potential for bias or "clustering" that could marginalize certain students. TeamMatch addresses this by:

    Heterogeneous Grouping: Implementing research-backed principles to ensure balanced skill distribution.

Preventing Clustering: Ensuring high-experience students are distributed across teams rather than grouped together.

Transparency: Generating explanation reports for instructors that justify why each student was assigned to a specific team.

Potential Misuse
While designed for academic balance, the system could be misused if instructors set "hard constraints" that inadvertently isolate specific students. To prevent this, the system uses a deterministic, rule-based algorithm rather than a "black-box" model, allowing every decision to be traceable and auditable by the department.

Legal Issues

Licensing & Third-Party Software
The project must comply with the licenses of the web frameworks and AI libraries used to build the AI Recommendation Module. As the system progresses, a full inventory of Open Source Software (OSS) libraries must be maintained to ensure compliance with MIT, Apache, or GPL requirements.

Intellectual Property (IP) & Data Ownership

    User Data: Under educational privacy laws (like FERPA), the student data collected—such as names and IDs—is protected.

System Logic: The "rule-based greedy assignment algorithm" and "normalized skill taxonomy" are the core IP of the SkillSwap Team.

Illegal Use & Liability
The Communication Module allows for announcements and notifications. There is a risk of users posting copyrighted material or using the platform for unauthorized data scraping. The system mitigates this by restricting "Team Formation" and "Project Management" features to authenticated Instructor roles only.

Security Issues

Sensitive Information Protection
The system stores several types of sensitive data that require protection:

    User Credentials: Authentication data handled by the User Management Module.

Personal Profiles: Student IDs, skill levels, and availability matrices.

Protection Plan: Data must be secured via encryption (specifically for passwords in the User table) and secure storage protocols.

Attack Vectors & Mitigation

    Unauthorized Access: Malicious users might attempt to bypass role-based access to gain instructor-level privileges. TeamMatch uses strict Access Control (FR-1, FR-2) to ensure students can only submit their own data and view their own team assignments.

Injection Attacks: Since the system handles "Student Input" and "Instructor Configuration," it is vulnerable to SQL Injection. All inputs must be validated for completeness and sanitized before processing.

XSS (Cross-Site Scripting): The "Communication Module" and "Progress Tracking" screens involve user-generated text. The system must sanitize all output to prevent malicious scripts from executing in other users' browsers.

Insecure API Endpoints: Malicious actors could target endpoints like POST /teams/save. These will be protected by session-based authentication and CSRF (Cross-Site Request Forgery) tokens.

---

## Documentation

For full technical details, see the **Wiki**:


* **Wiki Home:** [https://github.com/skill-swap490/skill-swap490/wiki](https://github.com/skill-swap490/skill-swap490/wiki)
* **Architecture Overview:** [https://github.com/skill-swap490/skill-swap490/wiki/Architecture-Overview](https://github.com/skill-swap490/skill-swap490/wiki/Architecture-Overview)
* **Database Schema:** [https://github.com/skill-swap490/skill-swap490/wiki/Database-Schema](https://github.com/skill-swap490/skill-swap490/wiki/Database-Schema)
* **Views (UI/UX):** [https://github.com/skill-swap490/skill-swap490/wiki/Views](https://github.com/skill-swap490/skill-swap490/wiki/Views)
* **REST API & Controllers:** [https://github.com/skill-swap490/skill-swap490/wiki/REST-API-&-Controllers](https://github.com/skill-swap490/skill-swap490/wiki/REST-API-&-Controllers)
* **Deployment Plan:** [https://github.com/skill-swap490/skill-swap490/wiki/Deployment](https://github.com/skill-swap490/skill-swap490/wiki/Deployment)
* **Design Considerations:** [https://github.com/skill-swap490/skill-swap490/wiki/Design-Considerations](https://github.com/skill-swap490/skill-swap490/wiki/Design-Considerations)
=======
* **Wiki Home:** [https://github.com/jkalski/490-Senior-Design/wiki](https://github.com/jkalski/490-Senior-Design/wiki)
* **Architecture Overview:** [https://github.com/jkalski/490-Senior-Design/wiki/Architecture-Overview](https://github.com/jkalski/490-Senior-Design/wiki/Architecture-Overview)
* **Database Schema:** [https://github.com/jkalski/490-Senior-Design/wiki/Database-Schema](https://github.com/jkalski/490-Senior-Design/wiki/Database-Schema)
* **Views (UI/UX):** [https://github.com/jkalski/490-Senior-Design/wiki/Views](https://github.com/jkalski/490-Senior-Design/wiki/Views)
* **REST API & Controllers:** [https://github.com/jkalski/490-Senior-Design/wiki/REST-API-&-Controllers](https://github.com/jkalski/490-Senior-Design/wiki/REST-API-&-Controllers)
* **Deployment Plan:** [https://github.com/jkalski/490-Senior-Design/wiki/Deployment](https://github.com/jkalski/490-Senior-Design/wiki/Deployment)
* **Design Considerations:** [https://github.com/jkalski/490-Senior-Design/wiki/Design-Considerations](https://github.com/jkalski/490-Senior-Design/wiki/Design-Considerations)



---

## Team

* Talin Keshesh — Lead Frontend & Integrations
* Sako Asatryan — Data Models & Chat
* Zakir Rizvi — CI/CD & Testing
* BachViet Nguyen — Search/AI & Location Services
* Justin Kalski — Backend Functions & Auth
