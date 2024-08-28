## Description
Please include a summary of the changes and the related issue. 

## Checklist
- [ ] My code follows the style guidelines of this project.
- [ ] I have performed a self-review of my code.
- [ ] I have commented my code, particularly in hard-to-understand areas.
- [ ] I have made corresponding changes to the documentation.
- [ ] My changes generate no new warnings.
- [ ] I have added tests that prove my fix is effective or that my feature works.
- [ ] New and existing unit tests pass locally with my changes.


General Project Architecture
Data Extraction Layer:
   APIs to fetch financial data about countries and commodities.
   Python scripts to handle API requests.
Data Transformation Layer:
   Python scripts to transform raw data into structured tables.
   SQL scripts to assist in data transformation.
Data Loading Layer:
   SQL database to store transformed data.
   Python scripts to load data into the database.
Automation and Orchestration:
   Airflow DAGs to manage ETL workflows.
   Automated functions for checkpoints and end-to-end testing.
CI/CD Pipeline:
  GitHub Actions for continuous integration and deployment.
  Docker to containerize services.
Maintenance:
  Scripts to manage database size by removing old data.