DECLARE @FeedName VARCHAR(100)
DECLARE @FeedNameSQL VARCHAR(100)

SET @FeedName = 'Census Block Groups - GeoJSON'
SET @FeedNameSQL = 'Census_Block_Groups'

--=============================================================================
-- Add an entry in the feed table for the LVMPD Area Commands file
--=============================================================================
INSERT INTO LVMPD_Crime_ETL.dbo.Feeds( feedName, feedNameSQL, feedDescription, feedDataFolder, feedDataFileConvention, externalID, externalIDDescription, activateDT, deActivateDT, activeFlag, ffTableCreated, geometryTypes )
SELECT
	feedName = @FeedName
	, feedNameSQL = @FeedNameSQL
	, feedDescription = 'Census block group geometry polygons'
	, feedDataFolder = 'Z:\Las_Vegas_Crime\Data\LVMPD\Census_Block_Groups\'
	, feedDataFileConvention = 'tl_20*_32_bg.geojson'
	, externalID = 'https://www2.census.gov/geo/tiger/TIGER[YEAR]/BG/tl_[YEAR]_32_bg.zip'
	, externalIDDescription = 'Location downloaded from'
	, activateDT = GETDATE()
	, deActivateDT = NULL
	, activeFlag = 1
	, ffTableCreated = 0
	, geometryTypes = 'Multipolygon'

--=============================================================================
-- Add the fields of the feed into the Fields metadata table
--=============================================================================

INSERT INTO LVMPD_Crime_ETL.dbo.Fields( fieldName, fieldNameSrc, fieldAlias, fieldDatatype, fieldNullable, fieldDescription, fieldTransform, feedID, fieldOrdinalPosition, fieldSrc, insertDT, activeFlag, pkFlag, coordField )
SELECT
	fieldName = 'etl_file_key'
	, fieldNameSrc = 'CONVERT( INT, '' + CONVERT( VARCHAR, @FileID ) + '' )'
	, fieldAlias = 'ETL File Key'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'ETL metadata for the key that ties to the file'
	, fieldTransform = 'etl_file_key'
	, feedID = f.feedID
	, fieldOrdinalPosition = 1
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'etl_file_xid'
	, fieldNameSrc = 'IDENTITY( INT, 1, 1 )'
	, fieldAlias = 'ETL File XID'
	, fieldDataType = 'INT'
	, fieldNullable = 0
	, fieldDescription = 'ETL metadata for the key that ties to the individual record'
	, fieldTransform = 'etl_file_xid'
	, feedID = f.feedID
	, fieldOrdinalPosition = 2
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'STATEFP'
	, fieldNameSrc = 'properties.STATEFP'
	, fieldAlias = 'Census State Code'
	, fieldDataType = 'CHAR(2)'
	, fieldNullable = 0
	, fieldDescription = 'Current state Federal Information Processing Series (FIPS) code'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( STATEFP ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 3
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'COUNTYFP'
	, fieldNameSrc = 'properties.COUNTYFP'
	, fieldAlias = 'Census County Code'
	, fieldDataType = 'CHAR(3)'
	, fieldNullable = 1
	, fieldDescription = 'Current county Federal Information Processing Series (FIPS) code'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( COUNTYFP ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 4
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'TRACTCE'
	, fieldNameSrc = 'properties.TRACTCE'
	, fieldAlias = 'Census Tract Code'
	, fieldDataType = 'CHAR(6)'
	, fieldNullable = 1
	, fieldDescription = 'Current census tract code'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( TRACTCE ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 5
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'BLKGRPCE'
	, fieldNameSrc = 'properties.BLKGRPCE'
	, fieldAlias = 'Census Block Group'
	, fieldDataType = 'CHAR(1)'
	, fieldNullable = 1
	, fieldDescription = 'Current block group number. A block group number of 0 represents a water block group.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( BLKGRPCE ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 6
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GEOID'
	, fieldNameSrc = 'properties.GEOID'
	, fieldAlias = 'Census Full FIPS ID'
	, fieldDataType = 'CHAR(12)'
	, fieldNullable = 1
	, fieldDescription = 'Census block group identifier; a concatenation of the current state Federal Information Processing Series (FIPS) code, county FIPS code, census tract code, and block group number'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GEOID ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 7
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GEOIDFQ'
	, fieldNameSrc = 'properties.GEOIDFQ'
	, fieldAlias = 'GEOIDFQ'
	, fieldDataType = 'CHAR(21)'
	, fieldNullable = 1
	, fieldDescription = 'Fully qualified census block group identifier; a concatenation of census survey summary level information with the census block group identifier. The GEOIDFQ attribute is calculated to facilitate joining census spatial data to census survey summary files.'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GEOIDFQ ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 8
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'NAMELSAD'
	, fieldNameSrc = 'properties.NAMELSAD'
	, fieldAlias = 'Census Area Description'
	, fieldDataType = 'CHAR(13)'
	, fieldNullable = 1
	, fieldDescription = 'Current translated legal/statistical area description and the block group number'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( NAMELSAD ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 9
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'MTFCC'
	, fieldNameSrc = 'properties.MTFCC'
	, fieldAlias = 'MTFCC'
	, fieldDataType = 'CHAR(5)'
	, fieldNullable = 1
	, fieldDescription = 'MAF/TIGER feature class code'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( MTFCC ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 10
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'FUNCSTAT'
	, fieldNameSrc = 'properties.FUNCSTAT'
	, fieldAlias = 'FUNCSTAT'
	, fieldDataType = 'CHAR(1)'
	, fieldNullable = 1
	, fieldDescription = 'Current functional status (S = Statistical entity)'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( FUNCSTAT ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 11
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'ALAND'
	, fieldNameSrc = 'properties.ALAND'
	, fieldAlias = 'Land Area'
	, fieldDataType = 'BIGINT'
	, fieldNullable = 1
	, fieldDescription = 'Current land area (square meters)'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( ALAND ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 12
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'AWATER'
	, fieldNameSrc = 'properties.AWATER'
	, fieldAlias = 'Water Area'
	, fieldDataType = 'BIGINT'
	, fieldNullable = 1
	, fieldDescription = 'Current water area (square meters)'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( AWATER ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 13
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'INTPTLAT'
	, fieldNameSrc = 'properties.INTPTLAT'
	, fieldAlias = 'Latitude - Internal Point'
	, fieldDataType = 'VARCHAR(15)'
	, fieldNullable = 1
	, fieldDescription = 'Current latitude of the internal point'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( INTPTLAT ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 14
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'INTPTLON'
	, fieldNameSrc = 'properties.INTPTLON'
	, fieldAlias = 'Longitude - Internal Point'
	, fieldDataType = 'VARCHAR(15)'
	, fieldNullable = 1
	, fieldDescription = 'Current longitude of the internal point'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( INTPTLON ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 15
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryCRS'
	, fieldNameSrc = '@CRS'
	, fieldAlias = 'CRS'
	, fieldDataType = 'VARCHAR(50)'
	, fieldNullable = 1
	, fieldDescription = 'Coordinate Reference System for geometry coordinates'
	, fieldTransform = 'REPLACE( NULLIF( LTRIM( RTRIM( GeometryCRS ) ), '''' ), ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 16
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryType'
	, fieldNameSrc = 'geometry.type'
	, fieldAlias = 'Geometry Type'
	, fieldDataType = 'VARCHAR(20)'
	, fieldNullable = 1
	, fieldDescription = 'Type of geometry the coordinates represent'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryType ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 17
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'GeometryCoordinates'
	, fieldNameSrc = 'geometry.coordinates'
	, fieldAlias = 'Coordinates'
	, fieldDataType = 'NVARCHAR(MAX)'
	, fieldNullable = 1
	, fieldDescription = 'The coordinates for the geometry that is provided'
	, fieldTransform = 'NULLIF( LTRIM( RTRIM( GeometryCoordinates ) ), '''' )'
	, feedID = f.feedID
	, fieldOrdinalPosition = 18
	, fieldSrc = 'Source'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 1
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1

UNION ALL

SELECT
	fieldName = 'Geom'
	, fieldNameSrc = ''
	, fieldAlias = 'Geom'
	, fieldDataType = 'GEOMETRY'
	, fieldNullable = 1
	, fieldDescription = 'Geometry data type representation of the coordinates'
	, fieldTransform = 'GEOMETRY::STGeomFromText( b.WktString, RIGHT( REPLACE( a.GeometryCRS, ''urn:ogc:def:crs:OGC:1.3:CRS84'', ''EPSG:4326'' ), 4 ) ).MakeValid()'
	, feedID = f.feedID
	, fieldOrdinalPosition = 19
	, fieldSrc = 'Calculated'
	, insertDT = GETDATE()
	, activeFlag = 1
	, pkFlag = 0
	, coordField = 0
FROM LVMPD_Crime_ETL.dbo.Feeds f
WHERE f.feedName = @FeedName
	AND f.activeFlag = 1
