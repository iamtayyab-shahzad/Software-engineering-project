# Upwork Proposal Generator
### Database Systems — Milestone 3 Project

---

## Project Overview

A full-stack web application built with **Node.js + Express + MySQL + Vanilla HTML/CSS/JS**.

Demonstrates:
- Database Design (DDL + DML)
- GUI Design (Sidebar, Topbar, Tables, Modals)
- CRUD Operations (Generated_Proposals)
- Stored Procedures (11 procedures)
- Triggers (3 triggers on Generated_Proposals)
- Node.js + MySQL integration via stored procedure calls

---

## Project Structure

```
upwork-proposal-generator/
│
├── database/
│   ├── dbDDL.sql          ← Your original schema
│   ├── dbDML.sql          ← Your original seed data
│   ├── procedures.sql     ← 11 stored procedures
│   └── triggers.sql       ← 3 triggers
│
├── backend/
│   ├── server.js          ← Express entry point
│   ├── db.js              ← MySQL connection pool
│   ├── package.json
│   │
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── dashboardRoutes.js
│   │   ├── proposalRoutes.js
│   │   ├── templateRoutes.js
│   │   ├── jobRoutes.js
│   │   └── reliabilityRoutes.js
│   │
│   └── controllers/
│       ├── authController.js
│       ├── dashboardController.js
│       ├── proposalController.js
│       ├── templateController.js
│       ├── jobController.js
│       └── reliabilityController.js
│
└── frontend/
    ├── login.html
    ├── signup.html
    ├── dashboard.html
    ├── proposals.html       ← Full CRUD (Create/Read/Update/Delete)
    ├── templates.html       ← Read-only
    ├── jobs.html            ← Read-only
    ├── reliability.html     ← Read-only
    │
    ├── css/
    │   └── style.css
    │
    └── js/
        └── app.js
```

---

## Prerequisites

| Tool    | Version     |
|---------|-------------|
| Node.js | 18+         |
| MySQL   | 8.0+        |
| npm     | comes with Node |

---

## Installation & Setup

### Step 1 — Set up the database

Open MySQL Workbench (or your MySQL client) and run the files **in this exact order**:

```sql
-- 1. Create schema and tables
SOURCE /path/to/database/dbDDL.sql;

-- 2. Insert seed data
SOURCE /path/to/database/dbDML.sql;

-- 3. Create stored procedures
SOURCE /path/to/database/procedures.sql;

-- 4. Create triggers
SOURCE /path/to/database/triggers.sql;
```

Or from the command line:
```bash
mysql -u root -p < database/dbDDL.sql
mysql -u root -p < database/dbDML.sql
mysql -u root -p < database/procedures.sql
mysql -u root -p < database/triggers.sql
```

### Step 2 — Configure database credentials

Open `backend/db.js` and update:
```js
const pool = mysql.createPool({
    host    : 'localhost',
    user    : 'root',
    password: 'YOUR_MYSQL_PASSWORD',   // ← change this
    database: 'upworkproposalgenerator'
});
```

### Step 3 — Install Node.js dependencies

```bash
cd backend
npm install
```

### Step 4 — Start the server

```bash
node server.js
```

You should see:
```
Server running at http://localhost:3000
```

### Step 5 — Open in browser

```
http://localhost:3000
```

---

## Pages

| Page              | URL                  | Features                     |
|-------------------|----------------------|------------------------------|
| Login             | /login.html          | Authenticate via sp_login_freelancer |
| Sign Up           | /signup.html         | Register via sp_signup_freelancer |
| Dashboard         | /dashboard.html      | 4 KPI cards from Freelancer_Analytics |
| My Proposals      | /proposals.html      | Full CRUD via stored procedures |
| Job Listings      | /jobs.html           | Read-only via sp_get_jobs |
| Templates         | /templates.html      | Read-only via sp_get_templates |
| Client Reliability| /reliability.html    | Read-only via sp_get_reliability_scores |

---

## Stored Procedures

| Procedure              | Purpose                                      |
|------------------------|----------------------------------------------|
| sp_signup_freelancer   | Inserts into Person + Freelancer + Analytics |
| sp_login_freelancer    | Authenticates by email + password            |
| sp_get_dashboard_stats | Returns 4 KPI stats for a freelancer         |
| sp_get_templates       | Returns all Proposal_Template rows           |
| sp_get_jobs            | Returns all Job_Posting rows                 |
| sp_get_reliability_scores | Returns Reliability_Score + company name  |
| sp_get_proposals       | Returns proposals for a freelancer           |
| sp_create_proposal     | Inserts into Generated_Proposals             |
| sp_update_proposal     | Updates content/status/date                  |
| sp_delete_proposal     | Deletes a proposal by ID + freelancer_id     |
| sp_get_clients         | Returns Client list for form dropdown        |

---

## Triggers

| Trigger                    | Event         | Action                                              |
|----------------------------|---------------|-----------------------------------------------------|
| trg_after_proposal_insert  | AFTER INSERT  | Increments total/accepted/rejected, recalc success_rate |
| trg_after_proposal_update  | AFTER UPDATE  | Full recalculate of analytics when status changes   |
| trg_after_proposal_delete  | AFTER DELETE  | Full recalculate of analytics after deletion        |

---

## Testing Login

Any of the 25 seeded freelancers can log in.

Example credentials from dbDML.sql:

| Email                   | Password (raw — as seeded) |
|-------------------------|----------------------------|
| david.m@example.com     | $2b$12$K89                 |
| sophia.v@example.com    | $2b$12$L90                 |
| marcus.s@example.com    | $2b$12$M91                 |

> **Note:** The DML seeds passwords as plain bcrypt stub strings.
> Since the login procedure does a direct string match (no bcrypt compare in this milestone),
> use those exact strings as the password when testing.
> For a new account, use the Sign Up page — it stores the password as typed.

---

## Tech Stack Summary

| Layer    | Technology              |
|----------|-------------------------|
| Backend  | Node.js + Express.js    |
| Database | MySQL 8.0               |
| Frontend | HTML5 + CSS3 + Vanilla JS |
| Session  | express-session         |
| DB Driver| mysql2 (promise pool)   |

---

## Milestone Checklist

- [x] DDL — 12 tables with proper FK relationships
- [x] DML — 20+ rows per table
- [x] Stored Procedures — 11 procedures covering all operations
- [x] Triggers — 3 triggers maintaining Freelancer_Analytics automatically
- [x] GUI — Login, Signup, Dashboard, Proposals, Templates, Jobs, Reliability
- [x] CRUD — Full Create/Read/Update/Delete on Generated_Proposals
- [x] Node.js + MySQL — All DB calls go through stored procedures
- [x] Authentication — Session-based freelancer login
