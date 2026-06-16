-- ============================================================================
-- FILE PATHWAY: C:\upworkdatabase\dbDML.sql
-- OBJECTIVE: SEED DATA CONTAINING 2 TARGETED ADMINS & 20+ INSTANCES PER TABLE
-- ============================================================================

USE upworkproposalgenerator;

-- Safeguard truncation script to safely refresh tables without FK locks
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Generated_Proposals;
TRUNCATE TABLE Reliability_Score;
TRUNCATE TABLE Job_Skill_Map;
TRUNCATE TABLE Freelancer_Skill_Map;
TRUNCATE TABLE Proposal_Template;
TRUNCATE TABLE Job_Posting;
TRUNCATE TABLE Freelancer_Analytics;
TRUNCATE TABLE Skills;
TRUNCATE TABLE Admin;
TRUNCATE TABLE Client;
TRUNCATE TABLE Freelancer;
TRUNCATE TABLE Person;
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------------
-- 1. SEED ENTITY: PERSON DIRECTORY (50 Total Entities Generated)
-- ----------------------------------------------------------------------------
INSERT INTO Person (person_id, f_name, Lname, email, country, upwork_profile_url) VALUES
(1, 'David', 'Miller', 'david.m@example.com', 'United States', 'upwork.com/users/david'),
(2, 'Sophia', 'Vargas', 'sophia.v@example.com', 'Germany', 'upwork.com/users/sophia'),
(3, 'Marcus', 'Stone', 'marcus.s@example.com', 'Canada', 'upwork.com/users/marcus'),
(4, 'Elena', 'Rostova', 'elena.r@example.com', 'Ukraine', 'upwork.com/users/elena'),
(5, 'Arjun', 'Patel', 'arjun.p@example.com', 'India', 'upwork.com/users/arjun'),
(6, 'Chloe', 'Dubois', 'chloe.d@example.com', 'France', 'upwork.com/users/chloe'),
(7, 'Yusuf', 'Ali', 'yusuf.a@example.com', 'Egypt', 'upwork.com/users/yusuf'),
(8, 'Min-jun', 'Kim', 'minjun.k@example.com', 'South Korea', 'upwork.com/users/minjun'),
(9, 'Emma', 'Smith', 'emma.s@example.com', 'United Kingdom', 'upwork.com/users/emma'),
(10, 'Liam', 'Johnson', 'liam.j@example.com', 'Australia', 'upwork.com/users/liam'),
(11, 'Mateo', 'Garcia', 'mateo.g@example.com', 'Spain', 'upwork.com/users/mateo'),
(12, 'Yuki', 'Sato', 'yuki.s@example.com', 'Japan', 'upwork.com/users/yuki'),
(13, 'Amara', 'Okonkwo', 'amara.o@example.com', 'Nigeria', 'upwork.com/users/amara'),
(14, 'Lucas', 'Silva', 'lucas.s@example.com', 'Brazil', 'upwork.com/users/lucas'),
(15, 'Anna', 'Novak', 'anna.n@example.com', 'Poland', 'upwork.com/users/anna'),
(16, 'Zayd', 'Khan', 'zayd.k@example.com', 'Pakistan', 'upwork.com/users/zayd'),
(17, 'Olivia', 'Brown', 'olivia.b@example.com', 'New Zealand', 'upwork.com/users/olivia'),
(18, 'Ivan', 'Petrov', 'ivan.p@example.com', 'Russia', 'upwork.com/users/ivan'),
(19, 'Lin', 'Wang', 'lin.w@example.com', 'China', 'upwork.com/users/lin'),
(20, 'Sofia', 'Rossi', 'sofia.r@example.com', 'Italy', 'upwork.com/users/sofia'),
(21, 'Ali', 'Hassan', 'ali.h@example.com', 'UAE', 'upwork.com/users/alih'),
(22, 'John', 'Doe', 'john.d@example.com', 'United States', 'upwork.com/users/johnd'),
(23, 'Jane', 'Doe', 'jane.d@example.com', 'United States', 'upwork.com/users/janed'),
(24, 'Tariq', 'Mahmood', 'tariq.m@example.com', 'Pakistan', 'upwork.com/users/tariqm'),
(25, 'Sana', 'Malik', 'sana.m@example.com', 'Pakistan', 'upwork.com/users/sanam'),
-- Clients Pool
(26, 'Alex', 'Vogel', 'alex.v@nexus.com', 'Germany', NULL),
(27, 'Sarah', 'Connor', 'sarah.c@cyberdyne.com', 'United States', NULL),
(28, 'Bruce', 'Wayne', 'bruce@waynecorp.com', 'United States', NULL),
(29, 'Tony', 'Stark', 'tony@starkind.com', 'United States', NULL),
(30, 'Peter', 'Parker', 'peter@dailybugle.com', 'United States', NULL),
(31, 'Clark', 'Kent', 'clark@dailyplanet.com', 'Metropolis', NULL),
(32, 'Diana', 'Prince', 'diana@themyscira.gov', 'Greece', NULL),
(33, 'Barry', 'Allen', 'barry@star_labs.com', 'United States', NULL),
(34, 'Hal', 'Jordan', 'hal@ferrisair.com', 'United States', NULL),
(35, 'Arthur', 'Curry', 'arthur@atlantis.org', 'Oceania', NULL),
(36, 'Victor', 'Stone', 'victor@star_labs.co', 'United States', NULL),
(37, 'Oliver', 'Queen', 'oliver@queencon.com', 'Canada', NULL),
(38, 'Billy', 'Batson', 'billy@whizradio.com', 'United States', NULL),
(39, 'James', 'Gordon', 'james@gcpd.gov', 'United States', NULL),
(40, 'Harvey', 'Dent', 'harvey@gothamda.org', 'United States', NULL),
(41, 'Selina', 'Kyle', 'selina@gothamcat.org', 'Italy', NULL),
(42, 'Arthur', 'Fleck', 'arthur@gothamclown.com', 'United States', NULL),
(43, 'Lex', 'Luthor', 'lex@lexcorp.com', 'Lexington', NULL),
(44, 'Lois', 'Lane', 'lois@dailyplanet.com', 'United States', NULL),
(45, 'Jimmy', 'Olsen', 'jimmy@dailyplanet.com', 'United States', NULL),
(46, 'Perry', 'White', 'perry@dailyplanet.com', 'United States', NULL),
(47, 'Walter', 'White', 'walter@graymatter.com', 'United States', NULL),
(48, 'Jesse', 'Pinkman', 'jesse@vamonos.com', 'United States', NULL),
-- Admins Domain Range Location Area
(49, 'Kashif', 'Ali', 'kashif.admin@system.com', 'Pakistan', NULL),
(50, 'Tayyab', 'Shahzad', 'tayyab.admin@system.com', 'Pakistan', NULL);

-- ----------------------------------------------------------------------------
-- 2. SEED SUBTYPES: FREELANCER, CLIENT, ADMIN (2 Admins Distinctly Configured)
-- ----------------------------------------------------------------------------
-- 25 Freelancers (IDs 1-25)
INSERT INTO Freelancer (freelancer_id, password, hourly_rate, experience_years) VALUES 
(1, '$2b$12$K89', 55.00, 5), (2, '$2b$12$L90', 40.00, 3), (3, '$2b$12$M91', 65.00, 7), (4, '$2b$12$N92', 35.00, 2),
(5, '$2b$12$O93', 50.00, 4), (6, '$2b$12$P94', 70.00, 8), (7, '$2b$12$Q95', 45.00, 3), (8, '$2b$12$R96', 80.00, 10),
(9, '$2b$12$S97', 30.00, 1), (10, '$2b$12$T98', 95.00, 12), (11, '$2b$12$U99', 60.00, 6), (12, '$2b$12$V10', 42.00, 4),
(13, '$2b$12$W11', 110.0, 9), (14, '$2b$12$X12', 25.00, 2), (15, '$2b$12$Y13', 52.00, 5), (16, '$2b$12$Z14', 48.00, 3),
(17, '$2b$12$A15', 75.00, 7), (18, '$2b$12$B16', 38.00, 2), (19, '$2b$12$C17', 90.00, 11), (20, '$2b$12$D18', 65.00, 6),
(21, '$2b$12$E19', 50.00, 4), (22, '$2b$12$F20', 40.00, 3), (23, '$2b$12$G21', 55.00, 5), (24, '$2b$12$H22', 70.00, 8),
(25, '$2b$12$I23', 35.00, 2);

-- 23 Clients (IDs 26-48)
INSERT INTO Client (client_id, company_name, success_rate, feedback) VALUES 
(26, 'Nexus Software Solutions', 95.00, 'Excellent communications.'),
(27, 'Cyberdyne Systems', 45.00, 'Unpredictable payouts.'),
(28, 'Wayne Enterprises', 99.00, 'Unlimited budget, highly demanding requirements.'),
(29, 'Stark Industries', 98.00, 'Needs cutting edge solutions.'),
(30, 'Daily Bugle', 65.00, 'Pays poorly but prompt reviews.'),
(31, 'Daily Planet', 88.00, 'Great editorial oversight.'),
(32, 'Themyscira Global', 92.00, 'Ethical team.'),
(33, 'STAR Labs', 74.00, 'Frequent scope modifications.'),
(34, 'Ferris Aircraft', 81.00, 'Solid contracts.'),
(35, 'Atlantis Ecological', 90.00, 'Consistent workflow.'),
(36, 'Cybernetic Systems', 85.00, 'Good technical leads.'),
(37, 'Queen Consolidated', 78.00, 'Average communication.'),
(38, 'Whiz Media', 89.00, 'Creative freedom allowed.'),
(39, 'Gotham Security', 94.00, 'Safe and reliable transactional history.'),
(40, 'Dent Legal Partners', 51.00, 'Highly litigious environment.'),
(41, 'Kyle Logistics', 86.00, 'Fast settlement processing.'),
(42, 'Fleck Entertainment', 12.00, 'Total failure to communicate goals.'),
(43, 'LexCorp Aerospace', 97.00, 'Top market rates offered.'),
(44, 'Lane Reporting', 93.00, 'Highly factual specs.'),
(45, 'Olsen Photography', 79.00, 'Friendly management.'),
(46, 'White Publishing', 87.00, 'Strict deadlines enforced.'),
(47, 'Gray Matter Tech', 96.00, 'Elite-tier infrastructure.'),
(48, 'Vamonos Pest Control', 40.00, 'Unverified payment pathways.');

-- 2 Admins with Explicit Operational Roles (IDs 49-50)
INSERT INTO Admin (admin_id, role, joined_date, status) VALUES 
(49, 'User Account Analysis', '2026-01-01', 'Active'), -- Admin 1: Analyzes account metrics/reliability
(50, 'Proposal Handling', '2026-01-15', 'Active');      -- Admin 2: Manages engines/templates

-- ----------------------------------------------------------------------------
-- 3. SEED ENTITY: SKILLS DICTIONARY (22 Skills Loaded)
-- ----------------------------------------------------------------------------
INSERT INTO Skills (skill_id, skill_name, skill_level) VALUES 
(1, 'Relational Schema Design', 'Expert'), (2, 'Go Programming', 'Intermediate'),
(3, 'React Frontend Development', 'Expert'), (4, 'Python Scripting', 'Intermediate'),
(5, 'AWS Deployment Cloud', 'Expert'), (6, 'MySQL Data Tuning', 'Expert'),
(7, 'Docker Containerization', 'Intermediate'), (8, 'GraphQL API Build', 'Expert'),
(9, 'Technical Content Copy', 'Intermediate'), (10, 'Figma Interaction UI', 'Expert'),
(11, 'Laravel System Setup', 'Expert'), (12, 'NodeJS REST Framework', 'Expert'),
(13, 'Django Backend Engine', 'Intermediate'), (14, 'TypeScript Application', 'Expert'),
(15, 'Redis Cache Implementation', 'Expert'), (16, 'CI/CD Workflow Piping', 'Intermediate'),
(17, 'Cybersecurity Pen Test', 'Expert'), (18, 'Kubernetes Scaling', 'Expert'),
(19, 'PyTorch Deep Model Training', 'Expert'), (20, 'Flutter Multiplatform Mobile', 'Intermediate'),
(21, 'NoSQL Architecture Mapping', 'Intermediate'), (22, 'Java Enterprise Core', 'Expert');

-- ----------------------------------------------------------------------------
-- 4. SEED ASSOCIATIVE: FREELANCER SKILL MAP (25 Rows Mapping Profiles)
-- ----------------------------------------------------------------------------
INSERT INTO Freelancer_Skill_Map (freelancer_id, skill_id) VALUES 
(1,1), (1,6), (2,2), (2,7), (3,3), (3,14), (4,4), (5,5), (5,18), (6,8), (7,9), 
(8,10), (9,11), (10,12), (11,13), (12,15), (13,17), (14,14), (15,16), (16,1), 
(17,19), (18,20), (19,21), (20,22), (21,4), (22,3), (23,2), (24,6), (25,9);

-- ----------------------------------------------------------------------------
-- 5. SEED ENTITY: FREELANCER ANALYTICS (25 Rows Mapping All Active Freelancers)
-- ----------------------------------------------------------------------------
INSERT INTO Freelancer_Analytics (analytics_id, freelancer_id, total_proposals, accepted_proposals, rejected_proposals, success_rate) VALUES 
(1, 1, 20, 15, 5, 75.00), (2, 2, 10, 4, 6, 40.00), (3, 3, 35, 28, 7, 80.00), (4, 4, 5, 1, 4, 20.00),
(5, 5, 14, 9, 5, 64.28), (6, 6, 18, 12, 6, 66.67), (7, 7, 8, 3, 5, 37.50), (8, 8, 40, 35, 5, 87.50),
(9, 9, 3, 0, 3, 0.00), (10, 10, 50, 46, 4, 92.00), (11, 11, 22, 15, 7, 68.18), (12, 12, 11, 5, 6, 45.45),
(13, 13, 29, 24, 5, 82.75), (14, 14, 6, 2, 4, 33.33), (15, 15, 17, 11, 6, 64.70), (16, 16, 13, 8, 5, 61.53),
(17, 17, 25, 20, 5, 80.00), (18, 18, 9, 3, 6, 33.33), (19, 19, 31, 26, 5, 83.87), (20, 20, 16, 10, 6, 62.50),
(21, 21, 12, 7, 5, 58.33), (22, 22, 15, 9, 6, 60.00), (23, 23, 8, 4, 4, 50.00), (24, 24, 21, 16, 5, 76.19),
(25, 25, 7, 2, 5, 28.57);

-- ----------------------------------------------------------------------------
-- 6. SEED ENTITY: PROPOSAL TEMPLATE (22 Engine Templates Guided by Admin 50)
-- ----------------------------------------------------------------------------
INSERT INTO Proposal_Template (template_id, admin_id, template_name, category, template_content, usage_count, success_rate) VALUES 
(1, 50, 'High-Tier Schema Architecture Framework', 'Backend Engineering', 'Dear Client, I reviewed your normalization...', 15, 85.00),
(2, 50, 'Go Lang Systems Core Blueprint', 'Systems Engineering', 'Dear Client, parsing microservices with Go requires...', 8, 75.00),
(3, 50, 'React Single Page App layout Framework', 'Frontend Engineering', 'Dear Client, performance in components begins with...', 22, 90.00),
(4, 50, 'Python Data Extraction Blueprint', 'Data Automation', 'Dear Client, scraping structural entities reliably...', 5, 40.00),
(5, 50, 'AWS Elastic Scale Setup Framework', 'Cloud Operations', 'Dear Client, setting up Multi-AZ infrastructure allows...', 11, 80.00),
(6, 50, 'MySQL Query Performance Optimization', 'Database Operations', 'Dear Client, tracking slow logging indexes directly...', 19, 88.00),
(7, 50, 'Docker Cloud Native Isolation Master', 'DevOps Infrastructure', 'Dear Client, continuous lightweight containerization...', 7, 71.00),
(8, 50, 'GraphQL Unified Data Layer Gateway', 'API Architecture', 'Dear Client, decoupling structural overfetching starts with...', 12, 83.00),
(9, 50, 'Technical Documentation Conversion Asset', 'Technical Writing', 'Dear Client, translating layout dictionaries requires...', 4, 50.00),
(10, 50, 'Figma Scalable UI Design Blueprint', 'UI/UX Design', 'Dear Client, atomic asset component mapping patterns...', 30, 92.00),
(11, 50, 'Laravel Enterprise Core Blueprint', 'Backend Engineering', 'Dear Client, monolithic application scaffolding using...', 6, 66.00),
(12, 50, 'NodeJS Express REST Integration Engine', 'API Development', 'Dear Client, async thread pool handling operations...', 25, 89.00),
(13, 50, 'Django Secure Dashboard Architecture', 'Web Platforms', 'Dear Client, python safe middleware deployment safeguards...', 9, 77.00),
(14, 50, 'TypeScript Clean Code Domain Blueprint', 'Frontend Engineering', 'Dear Client, compile-time strict type enforcement ensures...', 14, 85.00),
(15, 50, 'Redis Distributed High Hit Cache Engine', 'Data Operations', 'Dear Client, in-memory string-key invalidation policies...', 16, 91.00),
(16, 50, 'GitHub Actions Automation Framework', 'DevOps Infrastructure', 'Dear Client, continuous automation pipelines catch bugs...', 10, 70.00),
(17, 50, 'OWASP Automated Vulnerability Auditor', 'Cybersecurity', 'Dear Client, identifying perimeter vectors requires strict...', 18, 94.00),
(18, 50, 'Kubernetes Production State Cluster', 'DevOps Infrastructure', 'Dear Client, stateful pod orchestration parameters require...', 13, 84.00),
(19, 50, 'PyTorch Specialized Model Classifier', 'Artificial Intelligence', 'Dear Client, convolutional backpropagation convergence...', 20, 85.00),
(20, 50, 'Flutter Cross Platform Layout Blueprint', 'Mobile Engineering', 'Dear Client, non-native compiling widget render pipelines...', 11, 72.00),
(21, 50, 'MongoDB Dynamic Document Map Core', 'NoSQL Architectures', 'Dear Client, schema-less collection horizontal partitioning...', 8, 62.00),
(22, 50, 'Java Spring Boot Cloud Config Platform', 'Backend Engineering', 'Dear Client, enterprise inversion of control patterns...', 15, 80.00);

-- ----------------------------------------------------------------------------
-- 7. SEED ENTITY: JOB POSTING (23 Job Openings Advertised by Clients 26-48)
-- ----------------------------------------------------------------------------
INSERT INTO Job_Posting (job_id, client_id, job_title, job_description, experience_level, job_type, project_duration, budget_amount, posted_date, proposal_count) VALUES 
(1, 26, 'Migrate Legacy DB to 3NF MySQL', 'Seeking an experienced database administrator.', 'Expert', 'Fixed Price', '1 Month', 1200.00, '2026-06-12', 1),
(2, 27, 'Build Concurrency Engine with Go', 'Need assistance writing structural backend routers.', 'Intermediate', 'Hourly', '2 Months', 45.00, '2026-06-11', 1),
(3, 28, 'Design Gotham Corporate Dashboard', 'High end React setup required with clean modules.', 'Expert', 'Fixed Price', '6 Months', 75000.00, '2026-06-10', 1),
(4, 29, 'Python Automated Data Pipeline Engine', 'Extract fields from large public files completely.', 'Intermediate', 'Fixed Price', '2 Weeks', 2500.00, '2026-06-09', 1),
(5, 30, 'Deploy Newsroom Storage on AWS Cloud', 'Need zero downtime file systems configured.', 'Expert', 'Fixed Price', '1 Month', 900.00, '2026-06-08', 1),
(6, 31, 'Tune Heavy Production Database Inst', 'Optimize indexing paths to clear memory lags.', 'Expert', 'Hourly', '3 Weeks', 85.00, '2026-06-07', 1),
(7, 32, 'Isolate Global Microservices Framework', 'Docker setup matching secure network isolation.', 'Intermediate', 'Fixed Price', '1 Month', 3800.00, '2026-06-06', 1),
(8, 33, 'GraphQL Gateway Implementation Project', 'Consolidate multiple internal server nodes.', 'Expert', 'Fixed Price', '3 Months', 14000.00, '2026-06-05', 1),
(9, 34, 'Convert Flight Spec Logs to Markdown', 'Format data elements into crisp documentation tables.', 'Intermediate', 'Fixed Price', '5 Days', 450.00, '2026-06-04', 1),
(10, 35, 'Figma Layout Design for Ocean Tracker', 'Build sleek high fidelity custom component blocks.', 'Expert', 'Hourly', '2 Months', 65.00, '2026-06-03', 1),
(11, 36, 'Laravel Customer Portal Refactor Job', 'Clean tracking modules to prevent cross leaks.', 'Expert', 'Fixed Price', '1 Month', 5000.00, '2026-05-30', 1),
(12, 37, 'NodeJS Asynchronous Queue Setup', 'Refactor backend endpoints handling payload streams.', 'Expert', 'Hourly', '1 Month', 55.00, '2026-05-29', 1),
(13, 38, 'Secure Radio Dashboard Platform CMS', 'Django infrastructure integration with safe auth.', 'Intermediate', 'Fixed Price', '1 Month', 1800.00, '2026-05-28', 1),
(14, 39, 'TypeScript Clean Architecture Conversion', 'Port old vanilla scripts to explicit type layers.', 'Expert', 'Fixed Price', '2 Months', 9500.00, '2026-05-27', 1),
(15, 40, 'Redis Cache Invalidation Fix Task', 'Resolve memory overflow problems across clusters.', 'Expert', 'Hourly', '1 Week', 120.00, '2026-05-26', 1),
(16, 41, 'Automate Cargo Verification Pipeline', 'Implement GitHub Actions matrix tracking.', 'Intermediate', 'Fixed Price', '3 Weeks', 2200.00, '2026-05-25', 1),
(17, 42, 'Penetration Test Ticketing Platform', 'Run security auditing to detect logic holes.', 'Expert', 'Fixed Price', '10 Days', 3500.00, '2026-05-24', 1),
(18, 43, 'Orchestrate Multi Region Kubernetes Pod', 'Set automated backup recovery configurations.', 'Expert', 'Hourly', '4 Months', 150.00, '2026-05-23', 1),
(19, 44, 'Image Segmentation Network Development', 'Train deep networks to classify specific objects.', 'Expert', 'Fixed Price', '2 Months', 18000.00, '2026-05-22', 1),
(20, 45, 'Flutter Android iOS Event App Build', 'Create beautiful responsive interactive streams.', 'Intermediate', 'Fixed Price', '1 Month', 4000.00, '2026-05-21', 1),
(21, 46, 'Migrate SQL Records to MongoDB Maps', 'Unpack structured values into flat BSON elements.', 'Intermediate', 'Hourly', '2 Weeks', 40.00, '2026-05-20', 1),
(22, 47, 'Spring Boot Distributed Core System', 'Write dependency micro-endpoints safely.', 'Expert', 'Fixed Price', '3 Months', 25000.00, '2026-05-19', 1),
(23, 48, 'Simple Routing Patch Update Task', 'Verify payment pathway logging links.', 'Entry', 'Fixed Price', '2 Days', 200.00, '2026-05-18', 1);

-- ----------------------------------------------------------------------------
-- 8. SEED ASSOCIATIVE: JOB SKILL MAP (23 Rows Mapping Job Requirements)
-- ----------------------------------------------------------------------------
INSERT INTO Job_Skill_Map (job_id, skill_id) VALUES 
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10), (11,11), 
(12,12), (13,13), (14,14), (15,15), (16,16), (17,17), (18,18), (19,19), (20,20), 
(21,21), (22,22), (23,4);

-- ----------------------------------------------------------------------------
-- 9. SEED ENTITY: RELIABILITY SCORE (23 Client Snapshots Logged)
-- ----------------------------------------------------------------------------
INSERT INTO Reliability_Score (score_id, client_id, score, risk_level, recommendation_level, calculated_date) VALUES 
(1, 26, 95.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:00:00'),
(2, 27, 45.00, 'High Risk', 'Skip', '2026-06-12 12:05:00'),
(3, 28, 99.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:10:00'),
(4, 29, 98.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:15:00'),
(5, 30, 65.00, 'Medium Risk', 'Apply with Caution', '2026-06-12 12:20:00'),
(6, 31, 88.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:25:00'),
(7, 32, 92.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:30:00'),
(8, 33, 74.00, 'Medium Risk', 'Apply with Caution', '2026-06-12 12:35:00'),
(9, 34, 81.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:40:00'),
(10, 35, 90.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:45:00'),
(11, 36, 85.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:50:00'),
(12, 37, 78.00, 'Low Risk', 'Strong Apply', '2026-06-12 12:55:00'),
(13, 38, 89.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:00:00'),
(14, 39, 94.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:05:00'),
(15, 40, 51.00, 'Medium Risk', 'Apply with Caution', '2026-06-12 13:10:00'),
(16, 41, 86.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:15:00'),
(17, 42, 12.00, 'High Risk', 'Skip', '2026-06-12 13:20:00'),
(18, 43, 97.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:25:00'),
(19, 44, 93.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:30:00'),
(20, 45, 79.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:35:00'),
(21, 46, 87.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:40:00'),
(22, 47, 96.00, 'Low Risk', 'Strong Apply', '2026-06-12 13:45:00'),
(23, 48, 40.00, 'High Risk', 'Skip', '2026-06-12 13:50:00');

-- ----------------------------------------------------------------------------
-- 10. SEED ENTITY: GENERATED PROPOSALS (23 Full Output Submissions Created)
-- ----------------------------------------------------------------------------
INSERT INTO Generated_Proposals (proposal_id, freelancer_id, client_id, job_id, template_id, proposal_content, generated_date, proposal_status, submission_date) VALUES 
(1, 1, 26, 1, 1, 'Dear Client, I reviewed your normalization...', '2026-06-12 14:00:00', 'Submitted', '2026-06-12'),
(2, 2, 27, 2, 2, 'Dear Client, parsing microservices with Go...', '2026-06-12 14:01:00', 'Rejected', '2026-06-12'),
(3, 3, 28, 3, 3, 'Dear Client, performance in components...', '2026-06-12 14:02:00', 'Accepted', '2026-06-12'),
(4, 4, 29, 4, 4, 'Dear Client, scraping structural entities...', '2026-06-12 14:03:00', 'Submitted', '2026-06-12'),
(5, 5, 30, 5, 5, 'Dear Client, setting up Multi-AZ infrastructure...', '2026-06-12 14:04:00', 'Draft', NULL),
(6, 1, 31, 6, 6, 'Dear Client, tracking slow logging indexes...', '2026-06-12 14:05:00', 'Accepted', '2026-06-12'),
(7, 2, 32, 7, 7, 'Dear Client, continuous lightweight containerization...', '2026-06-12 14:06:00', 'Submitted', '2026-06-12'),
(8, 3, 33, 8, 8, 'Dear Client, decoupling structural overfetching...', '2026-06-12 14:07:00', 'Accepted', '2026-06-12'),
(9, 4, 34, 9, 9, 'Dear Client, translating layout dictionaries...', '2026-06-12 14:08:00', 'Rejected', '2026-06-12'),
(10, 5, 35, 10, 10, 'Dear Client, atomic asset component mapping...', '2026-06-12 14:09:00', 'Submitted', '2026-06-12'),
(11, 6, 36, 11, 11, 'Dear Client, monolithic application scaffolding...', '2026-06-12 14:10:00', 'Submitted', '2026-06-12'),
(12, 7, 37, 12, 12, 'Dear Client, async thread pool handling...', '2026-06-12 14:11:00', 'Draft', NULL),
(13, 8, 38, 13, 13, 'Dear Client, python safe middleware deployment...', '2026-06-12 14:12:00', 'Accepted', '2026-06-12'),
(14, 9, 39, 14, 14, 'Dear Client, compile-time strict type enforcement...', '2026-06-12 14:13:00', 'Rejected', '2026-06-12'),
(15, 10, 40, 15, 15, 'Dear Client, in-memory string-key invalidation...', '2026-06-12 14:14:00', 'Accepted', '2026-06-12'),
(16, 11, 41, 16, 16, 'Dear Client, continuous automation pipelines...', '2026-06-12 14:15:00', 'Submitted', '2026-06-12'),
(17, 12, 42, 17, 17, 'Dear Client, identifying perimeter vectors...', '2026-06-12 14:16:00', 'Rejected', '2026-06-12'),
(18, 13, 43, 18, 18, 'Dear Client, stateful pod orchestration...', '2026-06-12 14:17:00', 'Accepted', '2026-06-12'),
(19, 14, 44, 19, 19, 'Dear Client, convolutional backpropagation...', '2026-06-12 14:18:00', 'Submitted', '2026-06-12'),
(20, 15, 45, 20, 20, 'Dear Client, non-native compiling widget render...', '2026-06-12 14:19:00', 'Submitted', '2026-06-12'),
(21, 16, 46, 21, 21, 'Dear Client, schema-less collection horizontal...', '2026-06-12 14:20:00', 'Draft', NULL),
(22, 17, 47, 22, 22, 'Dear Client, enterprise inversion of control...', '2026-06-12 14:21:00', 'Accepted', '2026-06-12'),
(23, 18, 48, 23, 4, 'Dear Client, parsing microservices with Go...', '2026-06-12 14:22:00', 'No Response', '2026-06-12');