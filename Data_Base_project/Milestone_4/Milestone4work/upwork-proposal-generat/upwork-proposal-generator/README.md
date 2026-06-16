# Upwork Proposal Generator
### Database Systems — Milestone 3 Project

---

## Project Overview

A full-stack web application built with **Node.js + Express + MySQL + Vanilla HTML/CSS/JS**.

Demonstrates:
- Database Design (DDL + DML + schema extensions)
- GUI Design (Sidebar, Topbar, Stat Cards, Tables, Modals, role-based dashboards)
- CRUD Operations (Generated_Proposals, Proposal_Template)
- Stored Procedures (26 procedures across 4 SQL files)
- Triggers (3 triggers on Generated_Proposals, auto-maintaining Freelancer_Analytics)
- Node.js + MySQL integration via stored procedure calls only
- Role-based access: Freelancer, Super Admin, Template Manager

---

## Project Structure

```
upwork-proposal-generator/
│
├── database/
│   ├── dbDDL.sql            ← Original schema (12 tables)
│   ├── dbDML.sql            ← Original seed data
│   ├── procedures.sql       ← Core procedures (signup/login/dashboard/proposals/jobs/templates/reliability)
│   ├── triggers.sql         ← 3 triggers maintaining Freelancer_Analytics
│   ├── schema_updates.sql   ← Adds Admin password, Reliability_Config table, fixes analytics
│   └── procedures_v2.sql    ← Admin auth, reliability config, template CRUD, skills, detail views
│
├── backend/
│   ├── server.js
│   ├── db.js
│   ├── package.json
│   │
│   ├── routes/
│   │   ├── authRoutes.js          (freelancer login/signup)
│   │   ├── adminAuthRoutes.js     (admin login — Super Admin & Template Manager)
│   │   ├── dashboardRoutes.js
│   │   ├── proposalRoutes.js      (CRUD + dropdown helpers + reliability lookup)
│   │   ├── templateRoutes.js      (freelancer read-only)
│   │   ├── adminRoutes.js         (Template Manager CRUD + Super Admin config)
│   │   ├── jobRoutes.js
│   │   ├── reliabilityRoutes.js
│   │   └── skillRoutes.js
│   │
│   └── controllers/
│       ├── authController.js
│       ├── adminAuthController.js
│       ├── dashboardController.js
│       ├── proposalController.js
│       ├── templateController.js
│       ├── templateAdminController.js
│       ├── reliabilityConfigController.js
│       ├── jobController.js
│       ├── reliabilityController.js
│       └── skillController.js
│
└── frontend/
    ├── login.html              ← Freelancer login (links to Admin login)
    ├── signup.html             ← Freelancer signup (name, email, password only)
    ├── admin-login.html        ← Single admin login (routes by role)
    ├── dashboard.html          ← 4 KPI cards + "My Skills"
    ├── proposals.html          ← Full CRUD + dropdowns + clickable Job/Template + recommendation
    ├── templates.html          ← Read-only (freelancer view)
    ├── jobs.html               ← Read-only + Required Skills column
    ├── reliability.html        ← Read-only, dynamic recommendation
    ├── admin-super.html        ← Super Admin: Reliability scoring config
    ├── admin-templates.html    ← Template Manager: full template CRUD
    │
    ├── css/style.css
    └── js/app.js
```

---

## Prerequisites

| Tool    | Version |
|---------|---------|
| Node.js | 18+     |
| MySQL   | 8.0+    |
| npm     | comes with Node |

---

## Installation & Setup

### Step 1 — Set up the database

Run the SQL files **in this exact order**:

```bash
mysql -u root -p < database/dbDDL.sql
mysql -u root -p < database/dbDML.sql
mysql -u root -p < database/procedures.sql
mysql -u root -p < database/triggers.sql
mysql -u root -p < database/schema_updates.sql
mysql -u root -p < database/procedures_v2.sql
```

PowerShell users:
```powershell
Get-Content database/dbDDL.sql          | mysql -u root -p
Get-Content database/dbDML.sql           | mysql -u root -p
Get-Content database/procedures.sql      | mysql -u root -p
Get-Content database/triggers.sql        | mysql -u root -p
Get-Content database/schema_updates.sql  | mysql -u root -p
Get-Content database/procedures_v2.sql   | mysql -u root -p
```

### Step 2 — Configure database credentials

Edit `backend/db.js`:
```js
password: 'YOUR_MYSQL_PASSWORD',
```

### Step 3 — Install dependencies & run

```bash
cd backend
npm install
node server.js
```

### Step 4 — Open in browser

```
http://localhost:3000
```

---

## Logins

### Freelancer
Sign up via `/signup.html`, or use a seeded account, e.g.:
- Email: `david.m@example.com`
- Password: `$2b$12$K89`

### Admin (`/admin-login.html`)

| Role | Name | Email | Password |
|------|------|-------|----------|
| **Super Admin** | Kashif Ali | kashif.admin@system.com | `super123` |
| **Template Manager** | Tayyab Shahzad | tayyab.admin@system.com | `template123` |

Each admin role lands on its own dashboard:
- **Super Admin** → `admin-super.html` — configure reliability scoring weights & recommendation thresholds
- **Template Manager** → `admin-templates.html` — full CRUD on Proposal_Template

Freelancers cannot access either admin page; each is protected by `admin_type` checks.

---

## Pages & Features

| Page | URL | Access | Features |
|------|-----|--------|----------|
| Login | /login.html | Public | Freelancer auth via `sp_login_freelancer` |
| Sign Up | /signup.html | Public | `sp_signup_freelancer` (name, email, password) |
| Admin Login | /admin-login.html | Public | `sp_login_admin`, routes by `admin_type` |
| Dashboard | /dashboard.html | Freelancer | 4 KPI cards from `Freelancer_Analytics` + "My Skills" (`Freelancer_Skill_Map`) |
| My Proposals | /proposals.html | Freelancer | Full CRUD; Client/Job/Template dropdowns; clickable Job & Template detail modals; live client-reliability recommendation; per-proposal "Apply?" recommendation |
| Job Listings | /jobs.html | Freelancer | Read-only + Required Skills (`Job_Skill_Map`) |
| Templates | /templates.html | Freelancer | Read-only |
| Client Reliability | /reliability.html | Freelancer | Read-only, dynamic recommendation based on `Reliability_Config` |
| Super Admin | /admin-super.html | Super Admin | View/update `Reliability_Config` (weights + thresholds) |
| Template Manager | /admin-templates.html | Template Manager | Full CRUD on `Proposal_Template` |

---

## Stored Procedures Summary

**procedures.sql** (core):
`sp_signup_freelancer`, `sp_login_freelancer`, `sp_get_dashboard_stats`, `sp_get_templates`,
`sp_get_jobs`, `sp_get_reliability_scores`*, `sp_get_proposals`*, `sp_create_proposal`,
`sp_update_proposal`, `sp_delete_proposal`, `sp_get_clients`

*overridden in procedures_v2.sql with dynamic recommendation logic

**procedures_v2.sql** (admin / extended features):
`sp_login_admin`, `sp_get_reliability_config`, `sp_update_reliability_config`,
`sp_get_reliability_scores` (override), `sp_get_client_reliability`,
`sp_create_template`, `sp_update_template`, `sp_delete_template`, `sp_get_templates_admin`,
`sp_get_freelancer_skills`, `sp_get_job_skills`, `sp_get_job_details`, `sp_get_template_details`,
`sp_get_jobs_by_client`, `sp_get_proposals` (override)

---

## Triggers

| Trigger | Event | Action |
|---------|-------|--------|
| `trg_after_proposal_insert` | AFTER INSERT on Generated_Proposals | Increments total/accepted/rejected, recalculates success_rate |
| `trg_after_proposal_update` | AFTER UPDATE on Generated_Proposals | Full recalculation when proposal_status changes |
| `trg_after_proposal_delete` | AFTER DELETE on Generated_Proposals | Full recalculation after deletion |

---

## How the "Apply / Strong Apply / Consider / Skip" Recommendation Works

1. Super Admin sets weights (JSR / Reviews / Payment) and thresholds in `Reliability_Config`.
2. `sp_get_client_reliability` and `sp_get_reliability_scores` compare each client's
   `Reliability_Score.score` against the thresholds to compute a live `recommendation_level`.
3. This recommendation appears:
   - On the **Client Reliability** page (per client)
   - On the **Create Proposal** form (live, as soon as a client is selected)
   - On the **My Proposals** table (per existing proposal, "Apply?" column)

Changing the Super Admin config immediately changes all of the above — no data migration needed.

---

## Milestone Checklist

- [x] DDL — 12 original tables + Reliability_Config (schema_updates.sql)
- [x] DML — 20+ rows per table
- [x] Stored Procedures — 26 procedures across procedures.sql + procedures_v2.sql
- [x] Triggers — 3 triggers maintaining Freelancer_Analytics automatically
- [x] GUI — Login, Signup, Admin Login, Dashboard, Proposals, Templates, Jobs, Reliability, Super Admin, Template Manager
- [x] CRUD — Generated_Proposals (freelancer) + Proposal_Template (Template Manager)
- [x] Node.js + MySQL — All DB access via stored procedures
- [x] Authentication — Session-based, freelancer + 2-role admin system
- [x] Dashboard totals match My Proposals (one-time recalculation in schema_updates.sql + triggers keep it in sync)
- [x] Skills table used (My Skills on dashboard, Required Skills on jobs page)
- [x] Apply recommendation engine (Super Admin configurable)
