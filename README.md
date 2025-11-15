Hospital Management System – SQL Project

Overview

This project simulates a Hospital Management System using a relational SQL database. It includes full database design, data insertion, and analytical SQL queries. The dataset contains information on hospitals, doctors, patients, appointments, prescriptions, medications, rooms, and departments. The project demonstrates how SQL can be used to manage healthcare operations, analyse patient flows, and identify trends in medical service delivery. 

sql project report

Project Objectives

The main objective is to create a complete SQL database and use it to extract insights about hospital performance, patient demographics, medication trends, and doctor availability. The project covers database setup, data modelling, and multi-layered SQL analysis.

Dataset Description

The database includes the following tables:

Hospitals: Hospital names, addresses, contact details

Doctors: Doctor profiles, specialties, hospital assignments

Patients: Demographic and contact information

Appointments: Patient–doctor interactions with dates and reasons

Departments: Medical departments in each hospital

Medications: Drug names and descriptions

Prescriptions: Links between doctors, patients, and medications

Rooms: Room capacities and departmental allocation

All tables use primary and foreign keys to maintain referential integrity.

Part 1: Database Setup

Key steps implemented:

Created a new schema for the project.

Designed all tables with clear PK–FK relationships.

Ensured appropriate data types for dates, strings, and numeric fields.

Inserted all data using SQL scripts from the provided dataset.

Validated the structure using test SELECT queries.

This created a clean, consistent, and relational database ready for analysis.

Part 2: SQL Analysis

The project included a wide range of analytical queries covering:

Patient Demographics

Youngest patient: 1 year old

Oldest patient: 90 years old

Wide coverage across pediatric, adult, and geriatric categories. 

sql project report

Appointment Trends

February 2025 had the highest number of appointments (15).

September 2025 had the lowest (1).

Weeks 5 and 7 recorded 5 appointments each.

Checkups made up 28% of all visits; emergencies were 26%. 

sql project report

Medication and Prescription Insights

Frequently prescribed drugs included Simvastatin, Lisinopril, Donepezil, Gabapentin, and Aspirin.

Patients often received prescriptions from multiple doctors, indicating collaborative care. 

sql project report

Hospital and Staff Distribution

Green Valley, Harmony Hill, and Oceanview each had 4 doctors.

Cedar Grove, Northwind Hospital, and Lakeside General had 2.

Departments such as Radiology showed the highest average room capacity (2.67 beds). 

sql project report

Advanced Queries Implemented

Joins across multiple tables

Aggregations, DATE functions, and grouping

Subqueries and CTEs

Window functions

CASE statements to classify age groups and appointment types

Key Insights

Appointments peaked early in the year, with February showing the highest load.

Medication patterns reveal strong use of pain management and chronic condition drugs.

Staffing levels differ sharply across hospitals.

Departments such as Radiology and General Surgery show higher capacity than Pediatrics and Neurology.

Repeated patient visits signal ongoing care requirements.
