# user-retention-cohort-analysis
User Retention and Cohort Analysis using SQL (PostgreSQL) for data cleaning and Google Sheets for dynamic pivot tables and Retention Rate visualization.

Google Sheets: https://docs.google.com/spreadsheets/d/10DJQueLtOfmeu6-5s012UgB0BrnVhlduuzYRuvXnHJ4/edit?usp=sharing


Markdown
# User Retention Analysis using SQL and Google Sheets (Cohort Analysis)

## 📌 Project Overview
This is my graduation project focused on evaluating user retention patterns. The main goal was to analyze how well a company retains its users and compare the behavior of two different acquisition groups: **Promo Users** (attracted via marketing campaigns) and **Organic Users**. 

By calculating **Retention Rate** through **Cohort Analysis**, I discovered key insights into acquisition quality and user engagement.

---

## 🛠️ Tools & Technologies Used
* **SQL (PostgreSQL / DBeaver)** – for database connection, complex data cleaning, and processing inconsistent date formats using advanced string functions and CTEs.
* **Google Sheets** – for building dynamic Cohort Tables, calculating Retention Rates, implementing conditional formatting, and setting up an interactive Slicer.

---

## 💾 Dataset Structure
The analysis was performed on two raw tables from the `project` schema:
1. `cohort_users_raw` – Basic user profiles (ID, name, country, signup source, and a promo flag). **Challenge:** The `signup_datetime` field had highly inconsistent text formats and required thorough cleaning.
2. `cohort_events_raw` – User activity logs (logins, views, purchases). **Challenge:** Had to filter out test events, handle missing values (NULLs), and normalize dates.

---

## 🚀 Key Tasks Completed

### Part 1: SQL Data Preparation
* Investigated raw tables and identified data issues (broken date formats with different separators like `-`, `.`, `/`, and double-digit years).
* Built robust **CTEs** using `CASE` statements, `split_part`, and regular expressions to clean text strings and convert them into proper timestamps via `to_date()`.
* Joined user and event tables to calculate the `month_offset` (user lifetime stage from month 0 to 5).
* Filtered out test events and NULL values, leaving only clean behavioral data.
* Aggregated the final dataset by `promo_signup_flag`, `cohort_month`, and `month_offset` for the observation window (Jan–Jun 2025), then exported it to a CSV file.

### Part 2: Google Sheets Visualization & Analysis
* Imported the clean SQL data into Google Sheets.
* Built an interactive **Pivot Table** showing the total number of unique users per cohort.
* Created a **Retention Rate Table** that automatically calculates percentages relative to Month 0 (where Retention = 100%).
* Added a **Slicer (Filter)** by `promo_signup_flag` to easily switch between viewing All Users, Promo Users, or Organic Users.
* Wrote a data-driven conclusion analyzing the difference between paid and organic growth.

---

## 📊 Project Structure in this Repository
* `cohort_retention_script.sql` – My complete, ready-to-run SQL script with date parsing logic.
* `User_Retention_Analysis.pdf` (or Google Sheets link) – The final interactive spreadsheet with charts, cohort tables, and business conclusions.

---

## 💡 Key Takeaway
Through this project, I mastered how to turn chaotic, unformatted raw logs into clean business metrics and present them in a clear, interactive way for team decision-making.
