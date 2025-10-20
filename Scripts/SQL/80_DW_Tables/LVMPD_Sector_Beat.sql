IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.LVMPD_SectorBeat' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.LVMPD_SectorBeat
CREATE TABLE LVMPD_Crime_DW.dbo.LVMPD_SectorBeat
(
    etl_file_key INT NOT NULL
    , etl_file_xid INT NOT NULL PRIMARY KEY
    , Beat CHAR(2)
    , Sector CHAR(1)
    , AreaCommandCode VARCHAR(5)
    , Geom GEOMETRY NOT NULL
)

INSERT INTO LVMPD_Crime_DW.dbo.LVMPD_SectorBeat
(
	etl_file_key, etl_file_xid, Beat, Sector, AreaCommandCode, Geom
)
SELECT
	etl_file_key
	, etl_file_xid
	, Beat
    , Sector
    , AreaCommandCode = AreaCommand
	, Geom
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Sector_Beat_UNQ
WHERE Geom IS NOT NULL

CREATE SPATIAL INDEX SIndx_LVMPD_Sector_Beat_Geom ON LVMPD_Crime_DW.dbo.LVMPD_SectorBeat( Geom )
WITH 
(
    BOUNDING_BOX = ( XMIN = -116, YMIN = 35, XMAX = -114, YMAX = 37 )
    , GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
    , CELLS_PER_OBJECT = 64
)
