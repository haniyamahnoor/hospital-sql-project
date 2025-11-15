-- part 1: 

CREATE SCHEMA hospital_mgmt;

-- hospitals
CREATE TABLE hospital_mgmt.hospitals (
  hospital_id    INT PRIMARY KEY,
  name           VARCHAR(255) NOT NULL,
  address        TEXT,
  phone          VARCHAR(50)
);

-- departments
CREATE TABLE hospital_mgmt.departments 
(department_id INT PRIMARY KEY,
  hospital_id INT NOT NULL REFERENCES hospital_mgmt.hospitals(hospital_id),
  name VARCHAR(100) NOT NULL);

-- doctors
CREATE TABLE hospital_mgmt.doctors
(doctor_id INT PRIMARY KEY,
  name  VARCHAR(255) NOT NULL,
  specialty VARCHAR(100),
  hospital_id INT NOT NULL REFERENCES hospital_mgmt.hospitals(hospital_id),
  email VARCHAR(255));

-- patients
CREATE TABLE hospital_mgmt.patients 
(patient_id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  dob DATE,
  address TEXT,
  phone VARCHAR(50));

-- medications
CREATE TABLE hospital_mgmt.medications
( medication_id  INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT );

-- prescriptions
CREATE TABLE hospital_mgmt.prescriptions 
(prescription_id INT PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES hospital_mgmt.patients(patient_id),
  doctor_id INT NOT NULL REFERENCES hospital_mgmt.doctors(doctor_id),
  medication_id INT NOT NULL REFERENCES hospital_mgmt.medications(medication_id),
  prescribed_date DATE);

-- rooms
CREATE TABLE hospital_mgmt.rooms 
(room_id INT PRIMARY KEY,
  room_no VARCHAR(20) NOT NULL,
  department_id INT NOT NULL REFERENCES hospital_mgmt.departments(department_id),
  capacity INT);

-- appointments
CREATE TABLE hospital_mgmt.appointments 
(appointment_id INT PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES hospital_mgmt.patients(patient_id),
  doctor_id INT NOT NULL REFERENCES hospital_mgmt.doctors(doctor_id),
  appointment_date DATE,
  reason VARCHAR(100));
  
-- integrity checking 
SELECT d.doctor_id, d.name, d.hospital_id
FROM doctors d
LEFT JOIN hospitals h ON d.hospital_id = h.hospital_id
WHERE h.hospital_id IS NULL;

SELECT pr.prescription_id
FROM prescriptions pr
LEFT JOIN patients p ON pr.patient_id = p.patient_id
LEFT JOIN doctors d ON pr.doctor_id = d.doctor_id
LEFT JOIN medications m ON pr.medication_id = m.medication_id
WHERE p.patient_id IS NULL
   OR d.doctor_id IS NULL
   
   -- data insertion checking 

   OR m.medication_id IS NULL;
   
-- integrity check shows that nothing is wrong since empty result grid
   
-- confirming data insertion:
   
SELECT * FROM hospitals;
      
SELECT COUNT(*) FROM hospitals;
SELECT COUNT(*) FROM doctors;
SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM appointments;

-- PART 2 
-- queries 
-- Find all patients born after the year 2000

SELECT * FROM patients
WHERE dob > '2000-12-31'
ORDER BY dob;

-- find all prescriptons for patient ID 5 
SELECT pr.*, m.name AS medication_name, d.name AS doctor_name
FROM prescriptions pr
JOIN medications m ON pr.medication_id = m.medication_id
JOIN doctors d ON pr.doctor_id = d.doctor_id
WHERE pr.patient_id = 5
ORDER BY pr.prescribed_date; 

-- show the number of appointments per month: 
 SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS number_of_appointments FROM appointments
GROUP BY month ORDER BY month;

-- List all medications that include the keywords pain or infection in the description
SELECT * FROM medications
WHERE LOWER(description) LIKE '%pain%' OR LOWER(description) LIKE '%infection%';

-- Show all doctors with their hospital name
SELECT d.doctor_id, d.name AS doctors_name, d.specialty, h.name AS hospitals_name FROM doctors d
JOIN hospitals h ON d.hospital_id = h.hospital_id ORDER BY h.name, d.name; 

-- Find the names, phones and appointment_dates of all patients with appointments in August 2025
SELECT DISTINCT p.name, p.phone, a.appointment_date FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_date BETWEEN '2025-08-01' AND '2025-08-31'
ORDER BY a.appointment_date;

-- Show all room numbers and their capacities from the Neurology departments
SELECT r.room_no, r.capacity, d.name AS department, h.name AS hospital FROM rooms r
JOIN departments d ON r.department_id = d.department_id
JOIN hospitals h ON d.hospital_id = h.hospital_id
WHERE d.name = 'Neurology'
ORDER BY h.name, r.room_no;

-- Count how many doctors work in each hospital
SELECT h.name AS hospital_name, COUNT(d.doctor_id) AS doctor_count FROM hospitals h
LEFT JOIN doctors d ON d.hospital_id = h.hospital_id
GROUP BY h.hospital_id, h.name
ORDER BY doctor_count DESC;

-- Find patients who have more than 3 appointments
SELECT p.patient_id, p.name, COUNT(a.appointment_id) AS appointments_count FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.name
HAVING COUNT(a.appointment_id) > 3
ORDER BY appointments_count DESC;

-- List appointments with patient and doctor names
SELECT a.appointment_id, a.appointment_date, p.name AS patients_name, d.name AS doctors_name, a.reason FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;

-- PART 2 QUERIES 
-- For all the emergency appointments, show patient name, date of birth as well as age-group: 18 or below - Pediatric 19 to 64 - Adult 65 or above - Geriatric
SELECT a.appointment_id,
p.name AS patient_name,
p.dob,
TIMESTAMPDIFF(YEAR, p.dob, a.appointment_date) AS age,
CASE WHEN TIMESTAMPDIFF(YEAR, p.dob, a.appointment_date) <= 18 THEN 'Pediatric' WHEN TIMESTAMPDIFF(YEAR, p.dob, a.appointment_date) BETWEEN 19 AND 64 THEN 'Adult'
ELSE 'Geriatric'
END AS age_group FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
WHERE LOWER(a.reason) = 'emergency'
ORDER BY p.name;

-- Show all departments of Green Valley Medical Center
SELECT d.department_id, d.name FROM departments d
JOIN hospitals h ON d.hospital_id = h.hospital_id
WHERE h.name = 'Green Valley Medical Center'
ORDER BY d.name;

-- Find patients who have never had a prescription
SELECT p.* FROM patients p
LEFT JOIN prescriptions pr ON pr.patient_id = p.patient_id
WHERE pr.prescription_id IS NULL;

--  Patients who have appointments in more than one hospital
SELECT p.name, p.address, p.phone FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY p.patient_id, p.name, p.address, p.phone HAVING COUNT(DISTINCT d.hospital_id) > 1;

-- Show the latest appointment for each patient
SELECT a.* FROM appointments a
JOIN (
  SELECT patient_id, MAX(appointment_date) AS latest_appt FROM appointments
  GROUP BY patient_id
) t ON a.patient_id = t.patient_id AND a.appointment_date = t.latest_appt
ORDER BY a.patient_id;

--  Find the 3rd most frequently prescribed medication(s)

CREATE TABLE med_counts AS
SELECT medication_id, COUNT(*) AS cnt FROM prescriptions
GROUP BY medication_id;
CREATE TABLE rank_counts AS
SELECT DISTINCT cnt FROM med_counts
ORDER BY cnt DESC;
SET @third := (
    SELECT cnt FROM rank_counts
    LIMIT 1 OFFSET 2
);
SELECT m.medication_id, m.name, mc.cnt FROM med_counts mc
JOIN medications m ON mc.medication_id = m.medication_id
WHERE mc.cnt = @third;

--  Show hospitals with the lowest doctor count
SELECT h.name, COUNT(d.doctor_id) AS doctor_count FROM hospitals h
LEFT JOIN doctors d ON d.hospital_id = h.hospital_id
GROUP BY h.name
HAVING COUNT(d.doctor_id) = (
    SELECT MIN(doc_count) FROM (
        SELECT COUNT(d2.doctor_id) AS doc_count
        FROM hospitals h2
        LEFT JOIN doctors d2 ON d2.hospital_id = h2.hospital_id
        GROUP BY h2.hospital_id
    ) AS sub
);

-- Find the department with the second largest room capacity in each hospital

CREATE TABLE dept_cap AS
SELECT d.hospital_id, d.department_id, d.name AS department_name,
       COALESCE(SUM(r.capacity), 0) AS total_capacity FROM departments d
LEFT JOIN rooms r ON d.department_id = r.department_id
GROUP BY d.hospital_id, d.department_id, d.name;

CREATE TABLE max_cap AS
SELECT hospital_id, MAX(total_capacity) AS max_capacity FROM dept_cap
GROUP BY hospital_id;

CREATE TABLE second_cap AS
SELECT dc.hospital_id, MAX(dc.total_capacity) AS second_capacity FROM dept_cap dc
JOIN max_cap mc ON dc.hospital_id = mc.hospital_id WHERE dc.total_capacity < mc.max_capacity GROUP BY dc.hospital_id;

SELECT dc.hospital_id, dc.department_id, dc.department_name, dc.total_capacity FROM dept_cap dc
JOIN second_cap sc ON dc.hospital_id = sc.hospital_id WHERE dc.total_capacity = sc.second_capacity ORDER BY dc.hospital_id;


-- bonus points: 
-- Average room capacity per department
SELECT d.name AS department_name, AVG(r.capacity) AS avg_capacity FROM departments d
LEFT JOIN rooms r ON d.department_id = r.department_id
GROUP BY d.name
ORDER BY avg_capacity DESC;

-- Appointments per day
SELECT appointment_date, COUNT(*) AS number_of_appointments
FROM appointments
GROUP BY appointment_date
ORDER BY appointment_date;
-- Appointments per week 
SELECT YEAR(appointment_date) AS year, WEEK(appointment_date) AS week, COUNT(*) AS number_of_appointments
FROM appointments
GROUP BY year, week
ORDER BY year, week;

-- Appointments per month
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS num_appointments
FROM appointments
GROUP BY month
ORDER BY month;

-- Most frequent appointment reasons
SELECT reason, COUNT(*) AS times_booked
FROM appointments
GROUP BY reason
ORDER BY times_booked DESC;