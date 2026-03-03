-- Create the database schema
CREATE DATABASE IF NOT EXISTS hospital_beds;
USE hospital_beds;

-- Drop existing tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS bed_fact;
DROP TABLE IF EXISTS business;
DROP TABLE IF EXISTS bed_type;

-- Create bed_type dimension table
CREATE TABLE bed_type (
	bed_id INT PRIMARY KEY,
    bed_code VARCHAR(10),
    bed_desc VARCHAR(100));
    
-- Create business dimension table
CREATE TABLE business (
    ims_org_id VARCHAR(50) PRIMARY KEY,
    business_name VARCHAR(255),
    ttl_license_beds INT,
    ttl_census_beds INT,
    ttl_staffed_beds INT,
    bed_cluster_id INT
);

-- Create bed_fact table
CREATE TABLE bed_fact (
	ims_org_id VARCHAR(50),
    bed_id INT,
    license_beds INT,
    census_beds INT,
    staffed_beds INT,
    PRIMARY KEY (ims_org_id, bed_id),
    FOREIGN KEY (ims_org_id) REFERENCES business(ims_org_id),
    FOREIGN KEY (bed_id) REFERENCES bed_type(bed_id));
    
-- Step 6a: Analysis - Top 10 Hospitals by Bed Type
-- Top 10 Hospitals by ICU/SICU License Beds 
SELECT 
	b.business_name AS hospital_name,
    SUM(bf.license_beds) AS total_license_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN bed_type bt ON bf.bed_id = bt.bed_id
WHERE bf.bed_id IN (4,15) -- ICU (bed_id = 4) or SICU (bed_id = 15)
GROUP BY b.business_name
ORDER BY total_license_beds DESC
LIMIT 10; 

-- Top 10 Hospitals by ICU/SICU Census Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.census_beds) AS total_census_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN bed_type bt ON bf.bed_id = bt.bed_id
WHERE bf.bed_id IN (4, 15) 
GROUP BY b.business_name
ORDER BY total_census_beds DESC
LIMIT 10;

-- Top 10 Hospitals by ICU/SICU Staffed Beds
SELECT
	b.business_name AS hospital_name,
    SUM(bf.staffed_beds) AS total_staffed_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN bed_type bt ON bf.bed_id = bt.bed_id
WHERE bf.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY total_staffed_beds DESC
LIMIT 10;

-- Step 7a: Drill Down - Hospitals with BOTH ICU AND SICU
-- Top 10 with Both ICU & SICU - License Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.license_beds) AS total_license_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
WHERE bf.bed_id IN (4, 15)
AND bf.ims_org_id IN (
    SELECT ims_org_id
    FROM bed_fact
    WHERE bed_id IN (4, 15)
    GROUP BY ims_org_id
    HAVING COUNT(DISTINCT bed_id) = 2  -- Must have BOTH ICU and SICU
)
GROUP BY b.business_name
ORDER BY total_license_beds DESC
LIMIT 10;

-- Top 10 with Both ICU & SICU - Census Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.census_beds) AS total_census_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
WHERE bf.bed_id IN (4, 15)
AND bf.ims_org_id IN (
    SELECT ims_org_id
    FROM bed_fact
    WHERE bed_id IN (4, 15)
    GROUP BY ims_org_id
    HAVING COUNT(DISTINCT bed_id) = 2
)
GROUP BY b.business_name
ORDER BY total_census_beds DESC
LIMIT 10;

-- Top 10 with Both ICU & SICU - Staffed Beds
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.staffed_beds) AS total_staffed_beds
FROM bed_fact bf
INNER JOIN business b ON bf.ims_org_id = b.ims_org_id
WHERE bf.bed_id IN (4, 15)
AND bf.ims_org_id IN (
    SELECT ims_org_id
    FROM bed_fact
    WHERE bed_id IN (4, 15)
    GROUP BY ims_org_id
    HAVING COUNT(DISTINCT bed_id) = 2
)
GROUP BY b.business_name
ORDER BY total_staffed_beds DESC
LIMIT 10;
	