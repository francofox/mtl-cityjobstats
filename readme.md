# Montreal City Job Stats (Statistiques de postulation des offres d'emploi de la Ville de Montréal)
This project uses the data from the [Montréal Open Data site (Données ouvertes de la Ville de Montréal)](https://donnees.montreal.ca) on their [SimenLigne]() Oracle job posting system. This data is available here:
https://donnees.montreal.ca/dataset/offres-demploi-et-postulation

This project is a capstone project in the DataTalksClub free Data Engineering Zoomcamp. A huge thank you to all of the contributors to this course, it is really insane that this sort of resource can be offered for free to the general public. 

### Problem this solves
This data contains almost all of the data of job postings and their applicants for jobs at the City of Montreal Government. This is one of the main employers in Montreal, and is reputed for the stability, pay, and benefits afforded to its employees, as well as the upward and sideways mobility possible within the organization. For this reason, City jobs are highly coveted and competitive. If one would like to build their career at the City, any and all information on the availability of and competition for different jobs is very useful.

### General information on the data
This data is only available in French, so some of my data transformation will be aimed at making it more understandable for an English-speaking audience.

The data is updated on a weekly basis, and consists of one CSV file of denormalized data.

#### Data dictionary
(Translated from the data dictionary [here](https://donnees.montreal.ca/dataset/offres-demploi-et-postulation#methodology))
| Field | Type | Description |
| - | - | - | 
| `Unite_Niveau1` | numeric | (Unit Level 1) The service unit or borough ID |
| `Description_Unite_Niveau1` | varchar | (en: Description_Unit_L1) Name of the Unit Level 1 service unit or borough |
| `Unite`| numeric | (en: Administrative Unit) The administrative unit is the business unit where the job posting was created. It is represented by 12 significant digits, of which the first two represent the service unit or borough. The numbering represents a structured hierarchy(ex: Service, director, division, section) |
| `Description_Unite`| varchar | Description of the administrative unit. |
| `Accreditation`| numeric | (en: Work classification) The work classification of the job being advertised. It is represented by two digits. |
| `Description_Accreditation`| varchar | (en: Name of the work classification) Name of the work classification. |
| `Titre`| varchar | (en: Title) Job title being advertised. |
| `Emploi`| numeric | (en: Job code) Code of the job being advertised. It is represented by 6 digits.  |
| `No_Affichage`| varchar | (en: Post number) Job posting number. It is an alphanumeric field with a defined standard for its nomenclature. Ex.: FIN-16-TEMP-344210-1 means that it is a job posting in the financial services unit in 2016 for a temporary position for the job code 344210. In certain cases, the position number is also indicated.  |
| `Debut`| Date | (en: Start) Starting date of the posting. |
| `Fin` | Date | (en: End) End date for the posting. |
| `Interne_Externe` | varchar | (en: Internal External) Indicator showing whether the posting is only open to internal applicants or not. |
| `Nombre_Postulant` | numeric | (en: Number Applying) Total number of applicants having applied for this job posting. |
| `Nombre_Femme` | numeric | (en: Number Women) Number of women having applied for this posting. |
| `Nombre_Handicape` | numeric | (en: Number Disabled) Number of applicants self-identifying as disabled. |
| `Nombre_Minorite_Visible` | numeric | (en: Number Visible Minority) Number of applicants self-identifying as a visible minority. |
| `Nombre_Autochtone` | numeric | (en: Number Indigenous) Number of applicants self-identifying as indigenous. |
| `Nombre_Minorite_Ethnique` | numeric | (en: Number Ethnic Minority) Number of applicants self-identifying as an ethnic minority. |
