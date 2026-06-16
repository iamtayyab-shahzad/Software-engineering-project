-- ============================================================================
-- FILE PATHWAY: C:\upworkdatabase\dbDDL.sql
-- OBJECTIVE: SCHEMA ARCHITECTURE MATCHING DATA DICTIONARY SPECIFICATIONS
-- ============================================================================

DROP DATABASE IF EXISTS upworkproposalgenerator;
CREATE DATABASE upworkproposalgenerator;
USE upworkproposalgenerator;

-- ----------------------------------------------------------------------------
-- 1. IDENTITY DOMAIN (SUPERTYPE / SUBTYPE INFRASTRUCTURE)
-- ----------------------------------------------------------------------------

-- Section 2.2.1: Person Master Table
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    f_name VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(60) NULL,
    upwork_profile_url VARCHAR(255) NULL
);

-- Section 2.2.2: Freelancer Subtype 
CREATE TABLE Freelancer (
    freelancer_id INT PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    hourly_rate DECIMAL(10,2) NULL,
    experience_years INT NULL,
    FOREIGN KEY (freelancer_id) REFERENCES Person(person_id) ON DELETE CASCADE
);

-- Section 2.2.3: Client Subtype
CREATE TABLE Client (
    client_id INT PRIMARY KEY,
    company_name VARCHAR(100) NULL,
    success_rate DECIMAL(5,2) NULL,
    feedback TEXT NULL,
    FOREIGN KEY (client_id) REFERENCES Person(person_id) ON DELETE CASCADE
);

-- Section 2.2.4: Admin Subtype
CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    role VARCHAR(50) NOT NULL,
    joined_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES Person(person_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 2. TALENT, PROFILE METRICS & SKILLS ARCHITECTURE
-- ----------------------------------------------------------------------------

-- Section 2.2.10: Skills Catalog Taxonomy
CREATE TABLE Skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(80) NOT NULL,
    skill_level VARCHAR(20) NULL
);

-- Section 2.2.11: Freelancer Skill Association (M:N Map)
CREATE TABLE Freelancer_Skill_Map (
    freelancer_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (freelancer_id, skill_id),
    FOREIGN KEY (freelancer_id) REFERENCES Freelancer(freelancer_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id) ON DELETE CASCADE
);

-- Section 2.2.9: Freelancer Aggregate Statistics
CREATE TABLE Freelancer_Analytics (
    analytics_id INT PRIMARY KEY,
    freelancer_id INT NOT NULL UNIQUE,
    total_proposals INT DEFAULT 0,
    accepted_proposals INT DEFAULT 0,
    rejected_proposals INT DEFAULT 0,
    success_rate DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (freelancer_id) REFERENCES Freelancer(freelancer_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 3. LIVE MARKETPLACE TRANSACTIONS & TEMPLATING ENGINE
-- ----------------------------------------------------------------------------

-- Section 2.2.6: Proposal Generation Blueprints
CREATE TABLE Proposal_Template (
    template_id INT PRIMARY KEY,
    admin_id INT NULL,
    template_name VARCHAR(100) NOT NULL,
    category VARCHAR(60) NOT NULL,
    template_content TEXT NOT NULL,
    usage_count INT DEFAULT 0,
    success_rate DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id) ON DELETE SET NULL
);

-- Section 2.2.5: Operational Open Demands Listing
CREATE TABLE Job_Posting (
    job_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    job_title VARCHAR(150) NOT NULL,
    job_description TEXT NOT NULL,
    experience_level VARCHAR(30) NOT NULL,
    job_type VARCHAR(20) NOT NULL,
    project_duration VARCHAR(50) NULL,
    budget_amount DECIMAL(12,2) NULL,
    posted_date DATE NOT NULL,
    proposal_count INT DEFAULT 0,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

-- Section 2.2.12: Job Skill Association (M:N Map)
CREATE TABLE Job_Skill_Map (
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES Job_Posting(job_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id) ON DELETE CASCADE
);

-- Section 2.2.8: Evaluated Client Trust Parameters
CREATE TABLE Reliability_Score (
    score_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    risk_level VARCHAR(20) NOT NULL,
    recommendation_level VARCHAR(30) NOT NULL,
    calculated_date DATETIME NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

-- Section 2.2.7: Compiled Application Invocations Records
CREATE TABLE Generated_Proposals (
    proposal_id INT PRIMARY KEY,
    freelancer_id INT NOT NULL,
    client_id INT NOT NULL,
    job_id INT NOT NULL,
    template_id INT NOT NULL,
    proposal_content TEXT NOT NULL,
    generated_date DATETIME NOT NULL,
    proposal_status VARCHAR(20) NOT NULL,
    submission_date DATE NULL,
    FOREIGN KEY (freelancer_id) REFERENCES Freelancer(freelancer_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES Job_Posting(job_id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES Proposal_Template(template_id) ON DELETE CASCADE
);