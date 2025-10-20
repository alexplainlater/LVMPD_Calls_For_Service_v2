IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.lkpDispositionCodes' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.lkpDispositionCodes
CREATE TABLE LVMPD_Crime_DW.dbo.lkpDispositionCodes
(
	DispositionCode CHAR(1) NULL
	, DispositionDescription VARCHAR(35) NULL
) 

INSERT LVMPD_Crime_DW.dbo.lkpDispositionCodes (DispositionCode, DispositionDescription) 
VALUES 
	( 'A', 'Arrested' )
	, ( 'B', 'Citation Issued' )
	, ( 'C', 'Report Taken' )
	, ( 'D', 'Station Report' )
	, ( 'E', 'Refused To Sign Complaint' )
	, ( 'F', 'Unfounded' )
	, ( 'G', 'Dispatch Cancelled' )
	, ( 'H', 'Gone On Arrival' )
	, ( 'I', 'Unable To Locate' )
	, ( 'J', 'Settled At Scene' )
	, ( 'K', 'Detail Completed' )
	, ( 'L', 'Handled By Other Jurisdiction' )
	, ( 'M', 'Warning/Subjects Advised' )
	, ( 'N', 'No Disposition' )
	, ( 'O', 'False Alarm - Guard At Scene' )
	, ( 'P', 'False Alarm - No Guard At Scene' )
	
CREATE UNIQUE CLUSTERED INDEX UC_IDX_DispositionCode ON LVMPD_Crime_DW.dbo.lkpDispositionCodes( DispositionCode )