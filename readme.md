# Montreal City Job Stats (Statistiques de postulation des offres d'emploi de la Ville de Montréal)
This project uses the data from the [Montréal Open Data site (Données ouvertes de la Ville de Montréal)](https://donnees.montreal.ca) on their SimenLigne job posting system. This data is available here:
https://donnees.montreal.ca/dataset/offres-demploi-et-postulation

This project is a capstone project in the [DataTalksClub](https://datatalks.club/) free [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp). A huge thank you to all of the contributors to this course. It is really insane that this sort of high-quality resource can be offered free of charge to the general public.

### Problem this solves
This data contains almost all of the data of job postings and their applicants for jobs at the City of Montreal Government. This is one of the main employers in Montreal, and is reputed for the stability, pay, and benefits afforded to its employees, as well as the upward and sideways mobility possible within the organization. For this reason, City jobs are highly competitive. If one would like to build their career at the City, any and all information on the availability of and competition for different jobs is very useful.

The analysis of this data will help to show which particular jobs are most frequently posted, have the most amount of competition, when City Government hiring is likely to be slowest vs most dynamic, and which jobs tend to have the highest amount of diversity in their applicants.

### Final dashboard product
Here is a link to the final dashboard product:
https://lookerstudio.google.com/reporting/694eaf63-3b28-491b-8957-aafcdfb1425c
![Screenshot of pg 1](/pg1.png)

![Screenshot of pg 2](/pg2.png)
The first page contains monthly averages for different jobs and administrative units. This can be expanded with other models I created in SQL, to allow for other factors to be taken into account, such as administrative unit. Please use the dropdown menus to choose which Lv 1 Unit and Job Titles you want to compare.

The second page contains demographic information per job title, which can be selected and compared using the dropdown menus.

### General information on the data
This data is only available in French, so some of my data transformation will be aimed at making it more understandable for an English-speaking audience using the Google Translate API. (Quality of the translation is entirely up to Google Translate. If there is doubt about what something means, please refer to the French version)

The data is updated on a weekly basis (Mondays or Tuesdays), and consists of one CSV file of denormalized data that is constantly updated. Data is fetched early each Wednesday morning, and is brought into the Data Lake (GCS Bucket) and then transformed and loaded into the Data Warehouse, BigQuery. This is done by merging in new data based on hashes calculated to determine whether each row is new or not, and if it is not, whether or not the number of applicants has changed. Then, the job titles and administrative unit names and corresponding IDs are extracted (and generated, in the case of the admin units, as the 'admin unit number' given is not unique), the new ones that have not yet been translated are extracted into TSV files, sent to the GCS Data Lake, processed by the Google Translate API, and imported into BigQuery. This batch processing is orchestrated using Kestra.

Shorter translation of Work Classifications and Level 1 Units was done manually by me, as they will not likely be added to or changed, and is provided using seeds in dbt.

#### Data dictionary
(Translated from the data dictionary [here](https://donnees.montreal.ca/dataset/offres-demploi-et-postulation#methodology))
| Field | Type | Description |
| - | - | - | 
| `Unite_Niveau1` | int | (Unit Level 1) The service unit or borough ID |
| `Description_Unite_Niveau1` | varchar | (en: Description_Unit_L1) Name of the Unit Level 1 service unit or borough |
| `Unite`| int | (en: Administrative Unit) The administrative unit is the business unit where the job posting was created. It is represented by 12 significant digits, of which the first two represent the service unit or borough. The numbering represents a structured hierarchy(ex: Service, director, division, section) |
| `Description_Unite`| varchar | Description of the administrative unit. |
| `Accreditation`| int | (en: Work classification) The work classification of the job being advertised. It is represented by two digits. |
| `Description_Accreditation`| varchar | (en: Name of the work classification) Name of the work classification. |
| `Titre`| varchar | (en: Title) Job title being advertised. |
| `Emploi`| int | (en: Job code) Code of the job being advertised. It is represented by 6 digits.  |
| `No_Affichage`| varchar | (en: Post number) Job posting number. It is an alphanumeric field with a defined standard for its nomenclature. Ex.: FIN-16-TEMP-344210-1 means that it is a job posting in the financial services unit in 2016 for a temporary position for the job code 344210. In certain cases, the position number is also indicated.  |
| `Debut`| date | (en: Start) Starting date of the posting. |
| `Fin` | date | (en: End) End date for the posting. |
| `Interne_Externe` | varchar | (en: Internal External) Indicator showing whether the posting is only open to internal applicants or not. |
| `Nombre_Postulant` | int | (en: Number Applying) Total number of applicants having applied for this job posting. |
| `Nombre_Femme` | int | (en: Number Women) Number of women having applied for this posting. |
| `Nombre_Handicape` | int | (en: Number Disabled) Number of applicants self-identifying as disabled. |
| `Nombre_Minorite_Visible` | int | (en: Number Visible Minority) Number of applicants self-identifying as a visible minority. |
| `Nombre_Autochtone` | int | (en: Number Indigenous) Number of applicants self-identifying as indigenous. |
| `Nombre_Minorite_Ethnique` | int | (en: Number Ethnic Minority) Number of applicants self-identifying as an ethnic minority. |

### Tech stack
* Terraform - cloud infrastructure provisioning
* Python - glue code
* Kestra - Ingestion of batch data, transfer to data lake, then transform and loading of data into data warehouse, general orchestration of Google Translate API conversion
* GCS - Data Lake
* BigQuery - Data warehouse
* dbt - Data modeling
* Google Looker Studio - Analytics

*A unix-based OS, or at least the ability to run shell scripts and store things in the `~` folder, is assumed. If you are using Windows, please run this project using WSL2, or ideally in a Linux VM.*

## Instructions
#### Setup
1. Clone this git repo and make sure it is in your GitHub (will make it easier for DBT Cloud in the future).
2. Create a GCP project, add the Google Translate API to your project, create a service user for your tenant with owner permissions (Needs to be able to manage BigQuery, GCS, and Google Translate API), and save the JSON and the project ID and other relevant variables.
3. Fill out `terraform/variables.tf` with your GCP info
4. Put your JSON with credentials to GCP at `~/.pki/gcp/creds.json`
5. In the "kestra" folder, create `.env` file with the following contents filled in with your GCP info:
```
GCP_BUCKET_NAME=yourbucket
GCP_DATASET=yourdataset
GCP_PROJECT_ID=yourprojid
GCP_LOCATION=yourlocation
```

6. Run the `kestra/convert_env_to_encoded.py` script to create the `.env_encoded` file with the required secrets for Kestra
#### Terraforming our environment
7. Run `terraform init`, then `terraform apply` in the `terraform` folder
#### Loading into Data Lake and moving into DWH by batch processing
8. Run `docker compose up` in the `kestra` folder
9. Connect to Kestra at [localhost:8080](http://localhost:8080) and find the "villedemontreal_ingestion" flow, which should already be available there.
10. Go to the "Triggers" tab of the flow, and execute a backfill covering the last Wednesday.
11. Verify that everything ran correctly and that there were no errors.
#### Data Modeling with dbt
12. Set up a new dbt Cloud project with the BigQuery connection we created previously, and a GitHub connection to your clone of this repo with the subdirectory `dbt` selected.
13. Change the variables in the `dbt_project.yml` file so that they point to your BigQuery database and dataset. Alternatively, build the models using `dbt build --vars '{bq_db: your_bq_database, bq_ds: your_bq_dataset}'`, corresponding to the dataset containing the `jobdata` table.
14. Optionally, set up a production deployment environment in your dbt Cloud account to build and run every so often. 
#### Analytics with Looker Studio
15. Open Looker Studio and create a new dashboard with the fact models `fct_applicant_demography_per_job`, `fct_yearly_trends_per_lv1unit`, and `fct_yearly_trends_per_jobtitle` attached from BigQuery.
16. Create the line and bar charts in my [final product](https://lookerstudio.google.com/reporting/694eaf63-3b28-491b-8957-aafcdfb1425c), with the dropdowns to select Level 1 Units and Job titles: 
![Screenshot of pg 1](/pg1.png)

![Screenshot of pg 2](/pg2.png)

