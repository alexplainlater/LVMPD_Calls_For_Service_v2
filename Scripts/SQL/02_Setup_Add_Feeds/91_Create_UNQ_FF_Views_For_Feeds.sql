GO
USE LVMPD_Crime_FF
GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2019_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2019_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2019_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2019 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2020_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2020_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2020_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2020 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2021_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2021_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2021_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2021 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2022_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2022_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2022_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2022 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2023_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2023_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2023_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2023 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_2024_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_2024_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_2024_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		, b.UpdatedDate
		--, b.incDtUTC
		--, b.upDtUTC
		--, b.GlobalID
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.UpdatedDate DESC, a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_2024 a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_All_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_All_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_All_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_All a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_Last_30_Days_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_Last_30_Days_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_Last_30_Days_UNQ
AS
	SELECT 
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		, b.UpdatedDate
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.UpdatedDate DESC, a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_Last_30_Days a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Calls_For_Service_Daily_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Calls_For_Service_Daily_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Calls_For_Service_Daily_UNQ
AS
	SELECT
		b.etl_file_key
		, b.etl_file_xid
		--, b.OBJECTID
		, b.IncidentNumber
		, b.IncidentDate
		, b.Classification
		, b.IncidentTypeCode
		, b.IncidentTypeDescription
		, b.Address
		, b.Disposition
		--, b.Latitude
		--, b.Longitude
		--, b.Weekday
		--, b.Hour
		--, b.Month
		--, b.Day
		--, b.Year
		--, b.QuarterOfYear
		, b.ZipCode
		, b.UpdatedDate
		--, b.GeometryCRS
		--, b.GeometryType
		--, b.GeometryCoordinates
		, b.Geom
	FROM
	(
		SELECT a.*
			, RN = ROW_NUMBER() OVER( PARTITION BY a.IncidentNumber ORDER BY a.UpdatedDate DESC, a.etl_file_key DESC, a.etl_file_xid )
		FROM LVMPD_Crime_FF.dbo.LVMPD_Calls_For_Service_Daily a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.IncidentNumber IS NOT NULL
		AND b.RN = 1

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Area_Commands_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Area_Commands_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Area_Commands_UNQ
AS
	SELECT
		etl_file_key
		, etl_file_xid
		, Name
		, Agency
		, AreaCommandCode
		, FullName
		, Geom
	FROM LVMPD_Crime_FF.dbo.LVMPD_Area_Commands
	WHERE etl_file_key = ( 
		SELECT MAX( etl_file_key ) 
		FROM LVMPD_Crime_FF.dbo.LVMPD_Area_Commands a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	)

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwLVMPD_Sector_Beat_UNQ', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwLVMPD_Sector_Beat_UNQ
GO
CREATE VIEW dbo.vwLVMPD_Sector_Beat_UNQ
AS
	SELECT
		etl_file_key
		, etl_file_xid
		, Beat
		, Sector
		, AreaCommand
		, Geom
	FROM LVMPD_Crime_FF.dbo.LVMPD_Sector_Beat
	WHERE etl_file_key = ( 
		SELECT MAX( etl_file_key ) 
		FROM LVMPD_Crime_FF.dbo.LVMPD_Sector_Beat a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	)	

GO

--=============================================================================
--=============================================================================
IF OBJECT_ID( 'dbo.vwCensus_Block_Groups', 'V' ) IS NOT NULL
	DROP VIEW dbo.vwCensus_Block_Groups
GO
CREATE VIEW dbo.vwCensus_Block_Groups
AS	
	SELECT
		b.ExtractYear
		, b.STATEFP
		, b.COUNTYFP
		, b.TRACTCE
		, b.BLKGRPCE
		, b.GEOID
		, b.NAMELSAD
		, b.ALAND
		, b.AWATER
		, b.INTPTLAT
		, b.INTPTLON
		, b.Geom
	FROM
	(
		SELECT 
			a.*
			, ExtractYear = SUBSTRING( f.fileName, 4, 4 )
			, RN = ROW_NUMBER() OVER( PARTITION BY SUBSTRING( f.fileName, 4, 4 ), a.GEOID ORDER BY a.etl_file_key DESC )
		FROM LVMPD_Crime_FF.dbo.Census_Block_Groups a
		INNER JOIN LVMPD_Crime_ETL.dbo.Files f
			ON a.etl_file_key = f.fileID
		WHERE f.activeFlag = 1
	) b
	WHERE b.RN = 1

