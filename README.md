# Hospital-Beds-Star-Schema-Analysis

## Project Overview
Designed and queried a star schema database of U.S. hospital bed data to identify the top-performing hospitals by ICU and SICU capacity. The analysis supports healthcare leadership in selecting optimal pilot program sites for critical care staffing initiatives.

## Tools & Technologies
- SQL (MySQL): Schema design, data modeling, and querying
- MySQL Workbench: ERD creation via Reverse Engineering Wizard
- Star Schema Design: Fact and dimension table modeling

## Database Schema
Built a star schema with one fact table and two dimension tables:
- bed_fact (Fact Table): license_beds, census_beds, staffed_beds — linked to both dimension tables via foreign keys
- business (Dimension Table): Hospital identifiers, names, and total bed aggregates
- bed_type (Dimension Table): Bed type codes and descriptions (e.g., ICU, SICU, Burn, CCU)

<img width="393" height="725" alt="Hospital beds star schema" src="https://github.com/user-attachments/assets/1ca48e0e-028a-4871-978a-8fa3b9c3d4eb" />

## Analysis Process
Step 1: Identified the top 10 hospitals by ICU/SICU license beds, census beds, and staffed beds across all hospitals in the dataset.
Step 2: Narrowed the analysis to hospitals that operate both ICU and SICU units simultaneously, using a subquery with HAVING COUNT(DISTINCT bed_id) = 2 to enforce this filter.

## Key Business Insights
1. Top Hospitals by ICU/SICU Capacity (All hospitals)
- License Beds: Phoenix Children's Hospital (247) and University of Maryland Medical Center (220) hold the most state-approved beds
- Census Beds: Shands Hospital at the University of Florida (167) and Dallas County Hospital Association (145) show the highest active patient load
- Staffed Beds: Vidant Medical Center (203) and Rady Children's Hospital and Health Center (200) lead in staffing readiness

2. Hospitals with Both ICU & SICU Units
After drilling down, the same hospitals rise to the top consistently across all three bed metrics — indicating genuine operational strength, not just capacity on paper.

## Final Recommendation
University of Maryland Medical Center and Shands Hospital at the University of Florida are recommended as pilot program sites. Both hospitals rank at the top across license, census, and staffed bed metrics when filtered to facilities running both ICU and SICU units — demonstrating the scale, staffing, and patient volume needed to make a critical care staffing intervention cost-effective.

## Dataset
- Source: Provided course dataset (IMS hospital bed data)
- Tables: bed_type.csv, business.csv, bed_fact.csv
- Schema: hospital_beds

## Future Improvements
- Incorporate geographic filters to analyze regional ICU capacity gaps
- Add time-series data to track bed utilization trends over time
- Expand drill-down to other critical bed types (e.g., Burn, CCU, Detox ICU)
