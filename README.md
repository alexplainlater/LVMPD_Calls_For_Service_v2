# LVMPD_Calls_For_Service_V2
A look at Las Vegas Metro Police Calls for Service Data

The Las Vegas Metropolitan Police Department releases yearly datasets of their calls for service and I thought this might be some interesting data to analyze in another project.  The scripts in this repository are how I cleaned up and enriched the data that is available from https://opendata-lvmpd.hub.arcgis.com/.  They culminate with how I loaded the data into Microsoft SQL Server 2019.

## How to use this repository?
Included in this repository are the raw data and spatial files I acquired from LVMPD and the US Census.  You can use these or download your own copies.

### Data Files:
* Nevada Census (shapefile): https://www2.census.gov/geo/tiger/TIGER2023/TABBLOCK20/tl_2023_32_tabblock20.zip
* LVMPD Area Command (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/0803e2a7a8e44517b6eb9aa8071df996_0/explore </br>
* LVMPD Sector Beat (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/48516778560747e28d69be39813157a9_0/explore </br>
* LVMPD 2019 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/d89da047c8ec44b88b1afe34cabf7f43_0/explore </br>
* LVMPD 2020 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/c61febca7d5d4fb1a4bd5c7c33e8e2c0_0/explore </br>
* LVMPD 2021 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/fce7c93c6ec94c06b8c1b128ecfe89e7_0/explore </br>
* LVMPD 2022 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/e9c41bfd11454010a535cf02fb4a3ac3_0/explore </br>
* LVMPD 2023 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/c0ea564d32f54450af8218d8e962934a_10/explore </br>
* LVMPD 2024 Calls for Service (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/8bd45bf26d1d471c89e875c0c1366dbf_3/explore </br>
* LVMPD Calls for Service (Last 30 Days) (GEOJSON): https://opendata-lvmpd.hub.arcgis.com/datasets/6a371d1a491a4a0794578b031859c768_0/explore </br>

### Jupyter Notebook
The next step, is to run the code in the Jupyter Notebook, Download_LVMPD_Calls_For_Service.ipynb.  This will grab the most recent 30-day extract and pull out the requested dates and export into individual daily files to be loaded by the ETL system.

### SQL Scripts
* 01_Setup_Infrastructure
  * 01_Setup_Databases.sql - Set up the staging and ETL databases for the LVMPD Crime project: LVMPD_Crime_ETL, LVMPD_Crime_Staging, LVMPD_Crime_FF, LVMPD_Crime_DW
  * 02_Setup_ETL_Metadata_Tables.sql
* 02_Setup_Add_Feeds
  * Add a script to set up the ETL fields for each feed.  Create FF (fixed file) tables for each feed.  Create a unique view for each feed.
* 03_Setup_ETL_Stored_Procedures
  * spFindNewFilesForFeed.sql - Stored procedure that looks for new files given the feed attributes.
  * spLoadGEOJSONFilesFromMeta.sql - Loads the GEOJSON files using attributes from the ETL metadata table.
* 04_Ongoing_Find_Files_And_Load
  * 01_Find_Files_In_Feed_File_Folders.sql - cycles through all the fields looking for new files.
  * 02_Load_Files_Using_Metadata.sql - loads the files that were found.
  * 03_Insert_FF_From_Staging.sql - inserts the files into the FF tables.
* 80_DW_Tables
  * LVMPD_Calls_For_Service.sql - creates a warehouse of the Calls For Service data.  Joins to census block groups, area commands, and sector beat files.
* 90_Lookups
  * lkpDispositionCodes.sql - creates lookup tables for the disposition codes.
  * lkpIncidentType.sql - creates lookup tables for the incident types.
