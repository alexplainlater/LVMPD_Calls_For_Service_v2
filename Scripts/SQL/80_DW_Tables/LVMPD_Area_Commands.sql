IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.LVMPD_Area_Commands' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.LVMPD_Area_Commands
CREATE TABLE LVMPD_Crime_DW.dbo.LVMPD_Area_Commands
(
    etl_file_key INT NOT NULL
    , etl_file_xid INT NOT NULL PRIMARY KEY
    , Name VARCHAR(5)
    , Agency VARCHAR(5)
    , AreaCommandCode VARCHAR(5)
    , FullName VARCHAR(50)
    , Geom GEOMETRY NOT NULL
)

INSERT INTO LVMPD_Crime_DW.dbo.LVMPD_Area_Commands
(
	etl_file_key, etl_file_xid, Name, Agency, AreaCommandCode, FullName, Geom
)
SELECT
	etl_file_key
	, etl_file_xid
	, Name
	, Agency
	, AreaCommandCode
	, FullName
	, Geom = Geom.MakeValid()
FROM LVMPD_Crime_FF.dbo.vwLVMPD_Area_Commands_UNQ
WHERE Geom IS NOT NULL

CREATE SPATIAL INDEX SIndx_LVMPD_Area_Commands_Geom ON LVMPD_Crime_DW.dbo.LVMPD_Area_Commands( Geom )
WITH 
(
    BOUNDING_BOX = ( XMIN = -116, YMIN = 35, XMAX = -114, YMAX = 37 )
	, GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
    , CELLS_PER_OBJECT = 64
)
