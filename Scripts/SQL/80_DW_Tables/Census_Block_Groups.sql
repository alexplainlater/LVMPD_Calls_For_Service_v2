IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.Census_Block_Groups' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.Census_Block_Groups
CREATE TABLE LVMPD_Crime_DW.dbo.Census_Block_Groups
(
    UNIQUEID INT IDENTITY( 1, 1 ) NOT NULL PRIMARY KEY
    , ExtractYear CHAR(4)
    , STATEFP CHAR(2)
    , COUNTYFP CHAR(3)
    , TRACTCE CHAR(6)
    , BLKGRPCE CHAR(1)
    , GEOID CHAR(12)
    , NAMELSAD CHAR(13)
    , ALAND BIGINT
    , AWATER BIGINT
    , INTPTLAT VARCHAR(15)
    , INTPTLON VARCHAR(15)
    , Geom GEOMETRY NOT NULL
)

INSERT INTO LVMPD_Crime_DW.dbo.Census_Block_Groups
(
	ExtractYear, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, GEOID, NAMELSAD, ALAND, AWATER, INTPTLAT, INTPTLON, Geom
)
SELECT
	ExtractYear
    , STATEFP
    , COUNTYFP
    , TRACTCE
    , BLKGRPCE
    , GEOID
    , NAMELSAD
    , ALAND
    , AWATER
    , INTPTLAT
    , INTPTLON
	, Geom
FROM LVMPD_Crime_FF.dbo.vwCensus_Block_Groups
WHERE Geom IS NOT NULL

CREATE SPATIAL INDEX SIndx_Census_Block_Groups_Geom ON LVMPD_Crime_DW.dbo.Census_Block_Groups( Geom )
WITH 
(
    BOUNDING_BOX = ( XMIN = -116, YMIN = 35, XMAX = -114, YMAX = 37 )
)
