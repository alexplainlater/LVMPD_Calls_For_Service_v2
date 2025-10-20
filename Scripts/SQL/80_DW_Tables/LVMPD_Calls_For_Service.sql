--=============================================================================
-- Combine all the records into a temporary table so we can remove duplicates
--=============================================================================
IF OBJECT_ID( 'tempdb..#tempTable' ) IS NOT NULL
	DROP TABLE #tempTable
SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
INTO #tempTable
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2019_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2020_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2021_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2022_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2023_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_2024_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_All_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_Last_30_Days_UNQ

UNION ALL

SELECT
	etl_file_key
	, etl_file_xid
	, IncidentNumber
	, IncidentDate
	, Classification
	, IncidentTypeCode
	, IncidentTypeDescription
	, Address
	, Disposition
	, ZipCode
	, Geom = GEOMETRY::STGeomFromText( Geom.STAsText(), 4326 )
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Calls_For_Service_Daily_UNQ

--=============================================================================
-- Try to find any differences between duplicate records...
-- So we can figure out the best records to choose when deduping
--=============================================================================
--SELECT *
--FROM #tempTable
--WHERE IncidentNumber IN(
--	SELECT IncidentNumber
--	FROM #tempTable
--	GROUP BY IncidentNumber
--	HAVING COUNT(*) > 1
--)
--ORDER BY IncidentNumber

--SELECT COUNT(*)
--FROM
--(
--	SELECT *
--			, RN = ROW_NUMBER() OVER( 
--				PARTITION BY 
--					IncidentNumber 
--				ORDER BY
--					CASE WHEN Geom IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN IncidentDate IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN Classification IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN IncidentTypeCode IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN IncidentTypeDescription IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN Address IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN Disposition IS NOT NULL THEN 1 ELSE 0 END DESC
--					, CASE WHEN ZipCode IS NOT NULL THEN 1 ELSE 0 END DESC
--					, etl_file_key DESC
--					, etl_file_xid DESC
--			)
--		FROM #tempTable
--) a
--WHERE a.RN = 1
----2,532,755


--=============================================================================
-- Didn't really see anything that stood out, so just going to make sure the
-- fields aren't null and then pick the latest file.
--=============================================================================
IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.LVMPD_Calls_For_Service' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.LVMPD_Calls_For_Service
SELECT
	a.etl_file_key
	, a.etl_file_xid
	, a.IncidentNumber
	, a.IncidentDate
	, CrimeCategory = lkp_i.CrimeCategory
	, Classification = lkp_i.Classification
	, IncidentTypeCode = a.IncidentTypeCode
	, IncidentTypeDescription = lkp_i.IncidentTypeDescription
	, Address = CASE
					WHEN a.address = '' THEN NULL
					WHEN a.address = '<Null>' THEN NULL
					WHEN a.address = 'UNK LV LOC ' THEN NULL
					WHEN a.address = 'UNK LOC ' THEN NULL
					WHEN a.address = 'UNK LV AREA ' THEN NULL
					WHEN a.address = 'UNKNOWN LOCATION' THEN NULL
					WHEN a.address = ':S I 15 / SR 161' THEN NULL
					ELSE a.address
				END
	, a.Disposition
	, DispositionDescription = lkp_d.DispositionDescription
	, ZipCode = CASE
					WHEN ISNUMERIC( a.ZipCode ) = 0 
						THEN NULL
					WHEN CONVERT( INT, a.ZipCode ) < 89000
						THEN NULL
					WHEN CONVERT( INT, a.ZipCode ) > 89199
						THEN NULL
					ELSE
						a.ZipCode
				END
	, a.Geom
	, ac.Agency
	, ac.Name
	, ac.AreaCommandCode
	, ac.FullName
	, sb.Beat
	, sb.Sector
	, Census_Block_Group_2018 = cb_2018.GEOID
	, Census_Block_Group_2019 = cb_2019.GEOID
	, Census_Block_Group_2020 = cb_2020.GEOID
	, Census_Block_Group_2021 = cb_2021.GEOID
	, Census_Block_Group_2022 = cb_2022.GEOID
	, Census_Block_Group_2023 = cb_2023.GEOID
	, Census_Block_Group_2024 = cb_2024.GEOID
INTO LVMPD_Crime_DW.dbo.LVMPD_Calls_For_Service
FROM
(
	SELECT *
		, RN = ROW_NUMBER() OVER( 
			PARTITION BY 
				IncidentNumber 
			ORDER BY
				CASE WHEN Geom IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN IncidentDate IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN Classification IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN IncidentTypeCode IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN IncidentTypeDescription IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN Address IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN Disposition IS NOT NULL THEN 1 ELSE 0 END DESC
				, CASE WHEN ZipCode IS NOT NULL THEN 1 ELSE 0 END DESC
				, etl_file_key DESC
				, etl_file_xid DESC
		)
	FROM #tempTable
) a
LEFT JOIN LVMPD_Crime_DW.dbo.lkpDispositionCodes lkp_d
	ON lkp_d.DispositionCode = a.Disposition
LEFT JOIN LVMPD_Crime_DW.dbo.lkpIncidentType lkp_i
	ON lkp_i.IncidentTypeCode = a.IncidentTypeCode
LEFT JOIN LVMPD_Crime_DW.dbo.LVMPD_Area_Commands ac
	WITH 
	( 
		INDEX( SIndx_LVMPD_Area_Commands_Geom )
	)
	ON a.Geom.STWithin( ac.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN LVMPD_Crime_DW.dbo.LVMPD_SectorBeat sb
	WITH 
	( 
		INDEX( SIndx_LVMPD_Sector_Beat_Geom )
	)
	ON a.Geom.STWithin( sb.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2018'
		AND COUNTYFP = '003'
) cb_2018
	ON a.Geom.STWithin( cb_2018.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2019'
		AND COUNTYFP = '003'
) cb_2019
	ON a.Geom.STWithin( cb_2019.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2020'
		AND COUNTYFP = '003'
) cb_2020
	ON a.Geom.STWithin( cb_2020.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2021'
		AND COUNTYFP = '003'
) cb_2021
	ON a.Geom.STWithin( cb_2021.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2022'
		AND COUNTYFP = '003'
) cb_2022
	ON a.Geom.STWithin( cb_2022.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2023'
		AND COUNTYFP = '003'
) cb_2023
	ON a.Geom.STWithin( cb_2023.Geom ) = 1
	AND a.Geom IS NOT NULL
LEFT JOIN 
(
	SELECT *
	FROM LVMPD_Crime_DW.dbo.Census_Block_Groups
	WHERE ExtractYear = '2024'
		AND COUNTYFP = '003'
) cb_2024
	ON a.Geom.STWithin( cb_2024.Geom ) = 1
	AND a.Geom IS NOT NULL
WHERE a.RN = 1

--2,532,755
--2:38:26

--(2,532,755 rows affected)
-- 3:01:05