# Upwork Proposal Assistant

An intelligent platform designed to help freelancers evaluate job opportunities, analyze client reliability, and generate professional proposals efficiently.

---

## Overview

**Upwork Proposal Assistant** is a database-driven software system developed for freelancers working on the Upwork platform. The system assists users in analyzing client profiles, evaluating job requirements, generating personalized proposal drafts, and tracking proposal performance.

The objective of the project is to reduce the effort involved in proposal writing and improve freelancers' chances of winning projects by providing data-driven recommendations and reusable templates.

---

## Features

### Freelancer Features
- Analyze client reliability before applying.
- View job posting requirements.
- Generate customized proposal drafts.
- Maintain personal skill profiles.
- Track proposal statistics and success rates.

### Client Analysis
- Reliability score calculation.
- Risk level assessment.
- Hiring history evaluation.
- Recommendation generation.

### Admin Features
- Manage proposal templates.
- Monitor system activities.
- Track template usage statistics.
- Maintain system configuration.

---

## System Modules

- Client Profile Analysis
- Job Posting Management
- Proposal Template Management
- Automated Proposal Generation
- Reliability Score Evaluation
- Freelancer Analytics Dashboard
- Administrative Control Panel

---

## Database Architecture

The system follows a specialization hierarchy:

```
Person
│
├── Freelancer
├── Client
└── Admin
```

### Core Entities

1. Person
2. Freelancer
3. Client
4. Admin
5. Skills
6. Freelancer Skill Map
7. Job Posting
8. Job Skill Map
9. Proposal Template
10. Reliability Score
11. Freelancer Analytics
12. Generated Proposals

---

## Database Characteristics

- Third Normal Form (3NF)
- Primary Key Constraints
- Foreign Key Constraints
- Unique Attribute Constraints
- Data Integrity Enforcement
- Scalable Relational Structure

---

## Database Programmability Objects

### Stored Procedures

#### `CalculateReliability()`
Calculates client reliability scores and assigns risk levels and recommendation categories.

#### `SyncFreelancerMetrics()`
Updates freelancer analytics including proposal counts and success rates.

### Trigger

#### `IncrementTemplateUsage`
Automatically increments the template usage count whenever a new proposal is generated.

---

## Analytics Module

The system maintains:

- Total Proposals
- Accepted Proposals
- Rejected Proposals
- Success Rate

These analytics help freelancers improve proposal effectiveness and monitor performance.

---

## Reliability Evaluation

Clients are evaluated based on:

- Job Success Rate
- Historical Feedback
- Budget Behavior
- Reliability Score

Generated recommendations include:

- Highly Recommended
- Recommended
- Medium Risk
- Avoid

---

## Technologies Used

| Category | Technology |
|------------|------------|
| Database | MySQL 9.0 |
| Modeling | ERD & Relational Schema |
| Documentation | LaTeX |
| Design Standards | 3NF |
| Version Control | Git & GitHub |

---

## Repository Structure

```text
Software-engineering-project/
│
├── README.md
├── Proposal_document/
├── Milestone_1_work/
│   ├── Meetingvideo/
│   └── Meetingminutes/
│
├── Milestone_2_work/
│   ├── SRS/
│   ├── UseCases/
│   └── Diagrams/
│
├── Milestone_3_work/
│   ├── DatabaseDesign/
│   ├── ERD/
│   ├── RelationalSchema/
│   ├── SQLScripts/
│   └── Reports/
│
└── Documents/
```

---

## Project Milestones

### Milestone 1
- Requirement Gathering
- Stakeholder Meetings
- Problem Identification
- Project Proposal

### Milestone 2
- Software Requirements Specification (SRS)
- Use Cases
- Functional Requirements
- Non-Functional Requirements

### Milestone 3
- Conceptual Database Design
- Data Dictionary
- Relational Schema
- Normalization (3NF)
- Stored Procedures
- Triggers
- Database Implementation

---

## Standards Followed

- IEEE Std 830 – Software Requirements Specification
- IEEE Std 729 – Software Engineering Terminology
- ISO/IEC/IEEE 29148 – Requirements Engineering
- Relational Database Design Standards
- Third Normal Form (3NF)

---

## Future Enhancements

- AI-powered proposal generation
- Proposal success prediction
- Upwork API integration
- Freelancer recommendation engine
- Advanced analytics dashboard

---

## Team Members

- **Tayyab Shahzad**
- **Kashif Ali**
- **Najeeba**

### Requirement Provider
**Faisal Shahzad**  
Freelancer with 3+ years of industry experience.

---

## Conclusion

Upwork Proposal Assistant combines Software Engineering and Database Management principles to provide freelancers with intelligent client evaluation, automated proposal generation, and performance analytics. The system aims to improve proposal quality, reduce manual effort, and help freelancers make better decisions before applying to projects.

---

## License

This project is developed for academic purposes at **Namal University, Mianwali, Pakistan**.
