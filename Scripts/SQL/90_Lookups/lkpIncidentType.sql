IF OBJECT_ID( 'LVMPD_Crime_DW.dbo.lkpIncidentType' ) IS NOT NULL
	DROP TABLE LVMPD_Crime_DW.dbo.lkpIncidentType
CREATE TABLE LVMPD_Crime_DW.dbo.lkpIncidentType
(
	IncidentTypeCode VARCHAR(5) NOT NULL
	, IncidentTypeDescription VARCHAR(75) NULL
	, Classification VARCHAR(50) NULL
	, CrimeCategory VARCHAR(50) NULL
 )

INSERT LVMPD_Crime_DW.dbo.lkpIncidentType( IncidentTypeCode, IncidentTypeDescription, Classification ) 
VALUES 
	( '401', 'ACCIDENT', 'Traffic Accident' )
	, ( '401A', 'HIT AND RUN', 'Traffic Accident' )
	, ( '401AU', 'HIT AND RUN -UNHOUSED', 'Traffic Accident' )
	, ( '401B', 'ACCIDENT WITH INJURY', 'Traffic Accident' )
	, ( '401BU', 'ACCIDENT WITH INJURY - UNHOUSED', 'Traffic Accident' )
	, ( '401C', 'ACCIDENT (PRIVATE PROPERTY)', 'Traffic Accident' )
	, ( '401CU', 'ACCIDENT (PRIVATE PROPERTY) - UNHOUSED', 'Traffic Accident' )
	, ( '401M', 'USED TO CLEAR 401S WHERE VEHS MOVED TO', 'Traffic Accident' )
	, ( '401P', 'ACCIDENT (TRAFFIC-PROPERTY DAMAGE ONLY)', 'Traffic Accident' )
	, ( '401S', 'ACCIDENT - SCHOOL', 'Traffic Accident' )
	, ( '401U', 'ACCIDENT - UNHOUSED', 'Traffic Accident' )
	, ( '402', 'FIRE', 'Fire' )
	, ( '402A', 'FIRE ALARM AT SCHOOL', 'Fire' )
	, ( '402D', 'FIRE - INVOLVES DOMESTIC VIOLENCE', 'Fire' )
	, ( '402U', 'FIRE - UNHOUSED', 'Fire' )
	, ( '402Z', 'ATTEMPT FIRE', 'Fire' )
	, ( '403', 'PROWLER', 'Prowler' )
	, ( '403U', 'PROWLER - UNHOUSED', 'Prowler' )
	, ( '404', 'UNKNOWN TROUBLE', 'Unknown Trouble' )
	, ( '404A', '9-1-1 DISCONNECT', 'Unknown Trouble' )
	, ( '404AU', '9-1-1 DISCONNECT - UNHOUSED', 'Unknown Trouble' )
	, ( '404S', 'UKNOWN TROUBLE - SCHOOL', 'Unknown Trouble' )
	, ( '404U', 'UNKNOWN TROUBLE - UNHOUSED', 'Unknown Trouble' )
	, ( '405', 'SUICIDE', 'Suicide' )
	, ( '406', 'BURGLARY', 'Burglary' )
	, ( '406A', 'BURGLARY ALARM', 'Burglary' )
	, ( '406AD', 'BURGLARY ALARM - INVOLVES DOMESTIC VIOLENCE', 'Burglary' )
	, ( '406AU', 'BURGLARY ALARM - UNHOUSED', 'Burglary' )
	, ( '406D', 'BURGLARY - INVOLVES DOMESTIC VIOLENCE', 'Burglary' )
	, ( '406U', 'BURGLARY - UNHOUSED', 'Burglary' )
	, ( '406V', 'AUTO BURGLARY', 'Burglary' )
	, ( '406VU', 'AUTO BURGLARY - UNHOUSED', 'Burglary' )
	, ( '406Z', 'ATTEMPTED BURGLARY', 'Burglary' )
	, ( '407', 'ROBBERY', 'Robbery' )
	, ( '407A', 'ROBBERY ALARM', 'Robbery' )
	, ( '407B', 'ROBBERY INVOLVING A B-PACK OR GPS', 'Robbery' )
	, ( '407D', 'ROBBERY - INVOLVES DOMESTIC VIOLENCE', 'Robbery' )
	, ( '407U', 'ROBBERY - UNHOUSED', 'Robbery' )
	, ( '407Z', 'ATTEMPTED ROBBERY', 'Robbery' )
	, ( '408', 'DRUNK', 'Inoxicated Person' )
	, ( '408U', 'DRUNK - UNHOUSED', 'Inoxicated Person' )
	, ( '409', 'DRUNK DRIVER', 'DUI' )
	, ( '409S', 'DRUNK DRIVER - SCHOOL', 'DUI' )
	, ( '409U', 'DRUNK DRIVER - UNHOUSED', 'DUI' )
	, ( '410', 'RECKLESS DRIVER', 'Reckless Driver' )
	, ( '410U', 'RECKLESS DRIVER - UNHOUSED', 'Reckless Driver' )
	, ( '411', 'STOLEN MOTOR VEHICLE', 'Stolen Vehicle' )
	, ( '411A', 'RECOVERED STOLEN VEHICLE', 'Stolen Vehicle' )
	, ( '411AU', 'RECOVERED STOLEN VEHICLE - UNHOUSED', 'Stolen Vehicle' )
	, ( '411B', 'STOLEN DEPARTMENT BAIT CAR', 'Stolen Vehicle' )
	, ( '411D', 'STOLEN MOTOR VEHICLE - INVOLVES DOMESTIC VIOLENCE', 'Stolen Vehicle' )
	, ( '411E', 'EMBEZZLED VEHICLE', 'Stolen Vehicle' )
	, ( '411S', 'STOLEN MOTOR VEHICLE - SCHOOL', 'Stolen Vehicle' )
	, ( '411U', 'STOLEN MOTOR VEHICLE - UNHOUSED', 'Stolen Vehicle' )
	, ( '411Z', 'ATTEMPTED STOLEN MOTOR VEHICLE', 'Stolen Vehicle' )
	, ( '413', 'PERSON WITH A GUN', 'Person With a Weapon' )
	, ( '413A', 'PERSON WITH A KNIFE', 'Person With a Weapon' )
	, ( '413AD', 'PERSON WITH A KNIFE - INVOLVES DOMESTIC VIOLENCE', 'Person With a Weapon' )
	, ( '413AU', 'PERSON WITH A KNIFE - UNHOUSED', 'Person With a Weapon' )
	, ( '413B', 'PERSON WITH OTHER DEADLY WEAPON', 'Person With a Weapon' )
	, ( '413BD', 'PERSON WITH OTHER DEADLY WEAPON - INVOLVES DOMESTIC VIOLENCE', 'Person With a Weapon' )
	, ( '413BU', 'PERSON WITH OTHER DEADLY WEAPON - UNHOUSED', 'Person With a Weapon' )
	, ( '413D', 'PERSON WITH A GUN - INVOLVES DOMESTIC VIOLENCE', 'Person With a Weapon' )
	, ( '413G', 'PERSON WITH A WEAPON - GANG RELATED', 'Person With a Weapon' )
	, ( '413S', 'PERSON WITH A GUN - SCHOOL', 'Person With a Weapon' )
	, ( '413U', 'PERSON WITH A GUN - UNHOUSED', 'Person With a Weapon' )
	, ( '414', 'GRAND LARCENY', 'Larceny' )
	, ( '414A', 'PETIT LARCENY', 'Larceny' )
	, ( '414AU', 'PETIT LARCENY - UNHOUSED', 'Larceny' )
	, ( '414B', 'LARCENY INVOLVING B-PACK or GPS BAIT', 'Larceny' )
	, ( '414C', 'LARCENY FROM PERSON', 'Larceny' )
	, ( '414CU', 'LARCENY FROM PERSON - UNHOUSED', 'Larceny' )
	, ( '414D', 'GRAND LARCENY - INVOLVES DOMESTIC VIOLENCE', 'Larceny' )
	, ( '414S', 'GRAND LARCENY - SCHOOL', 'Larceny' )
	, ( '414U', 'GRAND LARCENY - UNHOUSED', 'Larceny' )
	, ( '414Z', 'ATTEMPTED LARCENY', 'Larceny' )
	, ( '415', 'ASSULT/BATTERY', 'Assault/Battery' )
	, ( '415A', 'ASSULT/BATTERY WITH A GUN', 'Assault/Battery' )
	, ( '415AD', 'ASSULT/BATTERY WITH A GUN - INVOLVES DOMESTIC VIOLENCE', 'Assault/Battery' )
	, ( '415AU', 'ASSULT/BATTERY WITH A GUN - UNHOUSED', 'Assault/Battery' )
	, ( '415B', 'ASSULT/BATTERY WITH OTHER DEADLY WEAPON', 'Assault/Battery' )
	, ( '415BD', 'ASSULT/BATTERY WITH OTHER DEADLY WEAPON - INVOLVES DOMESTIC VIOLENCE', 'Assault/Battery' )
	, ( '415BU', 'ASSULT/BATTERY WITH OTHER DEADLY WEAPON - UNHOUSED', 'Assault/Battery' )
	, ( '415C', 'ASASULT/BATTERY NEGATIVE INJURY DRIVE BY SHOOTING', 'Assault/Battery' )
	, ( '415D', 'ASSULT/BATTERY - INVOLVES DOMESTIC VIOLENCE', 'Assault/Battery' )
	, ( '415G', 'ASSULT/BATTERY - GANG RELATED', 'Assault/Battery' )
	, ( '415S', 'ASSULT/BATTERY - SCHOOL', 'Assault/Battery' )
	, ( '415U', 'ASSULT/BATTERY - UNHOUSED', 'Assault/Battery' )
	, ( '415Z', 'ATTEMPTED ASSAULT', 'Assault/Battery' )
	, ( '416', 'FIGHT', 'Fight' )
	, ( '416A', 'JUVENILE DISTURBANCE', 'Fight' )
	, ( '416AD', 'JUVENILE DISTURBANCE - INVOLVES DOMESTIC VIOLENCE', 'Fight' )
	, ( '416AU', 'JUVENILE DISTURBANCE - UNHOUSED', 'Fight' )
	, ( '416B', 'OTHER DISTURBANCE', 'Fight' )
	, ( '416BD', 'OTHER DISTURBANCE - INVOLVES DOMESTIC VIOLENCE', 'Fight' )
	, ( '416BU', 'OTHER DISTURBANCE - UNHOUSED', 'Fight' )
	, ( '416D', 'FIGHT - INVOLVES DOMESTIC VIOLENCE', 'Fight' )
	, ( '416F', 'FIREWORKS DISTURBANCE', 'Fight' )
	, ( '416S', 'FIGHT - SCHOOL', 'Fight' )
	, ( '416U', 'FIGHT - UNHOUSED', 'Fight' )
	, ( '417', 'FAMILY DISTURBANCE', 'Family Disturbance' )
	, ( '417D', 'FAMILY DISTURBANCE - INVOLVES DOMESTIC VIOLENCE', 'Family Disturbance' )
	, ( '417S', 'FAMILY DISTURBANCE - SCHOOL', 'Family Disturbance' )
	, ( '417U', 'FAMILY DISTURBANCE - UNHOUSED', 'Family Disturbance' )
	, ( '418', 'MISSING PERSON', 'Missing Person' )
	, ( '418A', 'FOUND PERSON', 'Missing Person' )
	, ( '418AU', 'FOUND PERSON - UNHOUSED', 'Missing Person' )
	, ( '418B', 'RUNAWAY', 'Missing Person' )
	, ( '418S', 'MISSING PERSON - SCHOOL', 'Missing Person' )
	, ( '418U', 'MISSING PERSON - UNHOUSED', 'Missing Person' )
	, ( '419', 'DEAD BODY', 'Dead Body' )
	, ( '419U', 'DEAD BODY - UNHOUSED', 'Dead Body' )
	, ( '420', 'HOMICIDE', 'Homicide' )
	, ( '420D', 'HOMICIDE - INVOLVES DOMESTIC VIOLENCE', 'Homicide' )
	, ( '420Z', 'ATTEMPTED HOMICIDE', 'Homicide' )
	, ( '421', 'SICK OR INJURED PERSON', 'Sick or Injured Person' )
	, ( '421A', 'MENTALLY ILL PERSON', 'Sick or Injured Person' )
	, ( '421C', 'SICK OR INJURED PERSON WITH COMMUNICABLE DISEASE', 'Sick or Injured Person' )
	, ( '422', 'INJURED OFFICER', 'Injured Officer' )
	, ( '422S', 'INJURED OFFICER - SCHOOL', 'Injured Officer' )
	, ( '423', 'SEE PERSON FOR INFO', 'See Person for Info' )
	, ( '424', 'ABUSE/NEGLECT', 'Abuse/Neglect' )
	, ( '425', 'SUSPICIOUS SITUATION', 'Suspicious Activity' )
	, ( '425A', 'SUSPICIOUS PERSON', 'Suspicious Activity' )
	, ( '425AD', 'SUSPICIOUS PERSON - INVOLVES DOMESTIC VIOLENCE', 'Suspicious Activity' )
	, ( '425AU', 'SUSPICIOUS PERSON - UNHOUSED', 'Suspicious Activity' )
	, ( '425B', 'SUSPICIOUS VEHICLE', 'Suspicious Activity' )
	, ( '425BD', 'SUSPICIOUS VEHICLE - INVOLVES DOMESTIC VIOLENCE', 'Suspicious Activity' )
	, ( '425BU', 'SUSPICIOUS VEHICLE - UNHOUSED', 'Suspicious Activity' )
	, ( '425D', 'SUSPICIOUS SITUATION - INVOLVES DOMESTIC VIOLENCE', 'Suspicious Activity' )
	, ( '425H', 'SUSPICIOUS SUBSTANCE', 'Suspicious Activity' )
	, ( '425S', 'SUSPICIOUS SITUATION - SCHOOL', 'Suspicious Activity' )
	, ( '425U', 'SUSPICIOUS SITUATION - UNHOUSED', 'Suspicious Activity' )
	, ( '426', 'SEXUAL ASSAULT', 'Sexual Assault' )
	, ( '427', 'KIDNAPPING', 'Kidnapping' )
	, ( '427D', 'KIDNAPPING - INVOLVES DOMESTIC VIOLENCE', 'Kidnapping' )
	, ( '427G', 'KIDNAPPING - GANG RELATED', 'Kidnapping' )
	, ( '427S', 'KIDNAPPING - SCHOOL', 'Kidnapping' )
	, ( '427Z', 'ATTEMPTED KIDNAPPING', 'Kidnapping' )
	, ( '428', 'CHILD MOLEST', 'Child Molest' )
	, ( '428L', 'LURING', 'Child Molest' )
	, ( '429', 'INDECENT EXPOSURE', 'Indecent Exposure' )
	, ( '429S', 'INDECENT EXPOSURE - SCHOOL', 'Indecent Exposure' )
	, ( '429U', 'INDECENT EXPOSURE - UNHOUSED', 'Indecent Exposure' )
	, ( '430', 'ANIMAL COMPLAINT', 'Animal Complaint' )
	, ( '430S', 'ANIMAL COMPLAINT - SCHOOL', 'Animal Complaint' )
	, ( '430U', 'ANIMAL COMPLAINT - UNHOUSED', 'Animal Complaint' )
	, ( '431', 'MISSING/FOUND PROPERTY', 'Missing/Found Property' )
	, ( '431S', 'MISSING/FOUND PROPERTY - SCHOOL', 'Missing/Found Property' )
	, ( '431U', 'MISSING/FOUND PROPERTY - UNHOUSED', 'Missing/Found Property' )
	, ( '432', 'FRAUD', 'Fraud' )
	, ( '432S', 'FRAUD - SCHOOL', 'Fraud' )
	, ( '432U', 'FRAUD - UNHOUSED', 'Fraud' )
	, ( '432Z', 'ATTEMPTED FRAUD', 'Fraud' )
	, ( '433', 'STOLEN PROPERTY', 'Stolen Property' )
	, ( '433S', 'STOLEN PROPERTY - SCHOOL', 'Stolen Property' )
	, ( '433U', 'STOLEN PROPERTY - UNHOUSED', 'Stolen Property' )
	, ( '434', 'ILLEGAL SHOOTING', 'Illegal Shooting' )
	, ( '434A', 'SHOT SPOTTER', 'Illegal Shooting' )
	, ( '434U', 'ILLEGAL SHOOTING - UNHOUSED', 'Illegal Shooting' )
	, ( '437', 'KEEP THE PEACE', 'Keeping the Peace' )
	, ( '437D', 'KEEP THE PEACE - INVOLVES DOMESTIC VIOLENCE', 'Keeping the Peace' )
	, ( '437S', 'KEEP THE PEACE - SCHOOL', 'Keeping the Peace' )
	, ( '437U', 'KEEP THE PEACE - UNHOUSED', 'Keeping the Peace' )
	, ( '438', 'TRAFFIC PROBLEM', 'Traffic Problem' )
	, ( '438S', 'TRAFFIC PROBLEM - SCHOOL', 'Traffic Problem' )
	, ( '438U', 'TRAFFIC PROBLEM - UNHOUSED', 'Traffic Problem' )
	, ( '439', 'ASSIST A CITIZEN', 'Assist Citizen' )
	, ( '439D', 'ASSIST A CITIZEN - INVOLVES DOMESTIC VIOLENCE', 'Assist Citizen' )
	, ( '439S', 'ASSIST A CITIZEN - SCHOOL', 'Assist Citizen' )
	, ( '439U', 'ASSIST A CITIZEN - UNHOUSED', 'Assist Citizen' )
	, ( '440', 'WANTED SUSPECT', 'Wanted Subject' )
	, ( '440D', 'WANTED SUSPECT - INVOLVES DOMESTIC VIOLENCE', 'Wanted Subject' )
	, ( '440G', 'WANTED SUSPECT - GANG RELATED', 'Wanted Subject' )
	, ( '440S', 'WANTED SUSPECT - SCHOOL', 'Wanted Subject' )
	, ( '440U', 'WANTED SUSPECT - UNHOUSED', 'Wanted Subject' )
	, ( '441', 'MALICIOUS DESTRUCTION OF PROPERTY', 'Malicious Destruction of Property' )
	, ( '441D', 'MALICIOUS DESTRUCTION OF PROPERTY - INVOLVES DOMESTIC VIOLENCE', 'Malicious Destruction of Property' )
	, ( '441G', 'MALICIOUS DESTRUCTION OF PROPERTY - GANG RELATED', 'Malicious Destruction of Property' )
	, ( '441S', 'MALICIOUS DESTRUCTION OF PROPERTY - SCHOOL', 'Malicious Destruction of Property' )
	, ( '441U', 'MALICIOUS DESTRUCTION OF PROPERTY - UNHOUSED', 'Malicious Destruction of Property' )
	, ( '441Z', 'ATTEMPTED VANDALIZM', 'Malicious Destruction of Property' )
	, ( '442', 'AIRPLANE EMERGENCY', 'Airplane Emergency' )
	, ( '443', 'ASSIST AN OFFICER', 'Assist An Officer' )
	, ( '443S', 'ASSIST AN OFFICER - SCHOOL', 'Assist An Officer' )
	, ( '443U', 'ASSIST AN OFFICER - UNHOUSED', 'Assist An Officer' )
	, ( '444', 'OFFICER NEEDS HELP - EMERGENCY', 'Assist An Officer' )
	, ( '444A', 'PANIC ALARM AT METRO FACILITY', 'Assist An Officer' )
	, ( '445', 'EXPLOSIVE DEVICE', 'Explosive Device' )
	, ( '446', 'NARCOTICS', 'Narcotics' )
	, ( '446G', 'NARCOTICS - GANG RELATED', 'Narcotics' )
	, ( '446S', 'NARCOTICS - SCHOOL', 'Narcotics' )
	, ( '446U', 'NARCOTICS - UNHOUSED', 'Narcotics' )
	, ( '447', 'CIVIL MATTER', 'Civil Matter' )
	, ( '447D', 'CIVIL MATTER - INVOLVES DOMESTIC VIOLENCE', 'Civil Matter' )
	, ( '447S', 'CIVIL MATTER - SCHOOL', 'Civil Matter' )
	, ( '447U', 'CIVIL MATTER - UNHOUSED', 'Civil Matter' )

UPDATE a
SET CrimeCategory = CASE
						WHEN Classification IN (
						  'Homicide'
						  , 'Sexual Assault'
						  , 'Child Molest'
						  , 'Abuse/Neglect'
						  , 'Robbery'
						  , 'Assault/Battery'
						  , 'Kidnapping'
						  , 'Illegal Shooting'
						  , 'Person With a Weapon'
						  , 'Indecent Exposure'
						)
						THEN 'Violent Crimes'
						WHEN Classification IN (
						  'Burglary'
						  , 'Larceny'
						  , 'Stolen Vehicle'
						  , 'Fraud'
						  , 'Malicious Destruction of Property'
						  , 'Stolen Property'
						)
						THEN 'Property Crimes'
						WHEN Classification IN (
						  'Family Disturbance'
						  , 'Fight'
						  , 'Narcotics'
						  , 'Inoxicated Person'
						  , 'Keeping the Peace'
						  , 'Prowler'
						)
						THEN 'Public Order & Disturbance'
						WHEN Classification IN (
						  'Traffic Accident'
						  , 'DUI'
						  , 'Reckless Driver'
						  , 'Traffic Problem'
						)
						THEN 'Traffic Incidents'
						WHEN Classification IN (
						  'Assist Citizen'
						  , 'Assist An Officer'
						  , 'See Person for Info'
						  , 'Sick or Injured Person'
						  , 'Suspicious Activity'
						  , 'Unknown Trouble'
						  , 'Missing Person'
						  , 'Suicide'
						  , 'Wanted Subject'
						  , 'Animal Complaint'
						  , 'Civil Matter'
						  , 'Dead Body'
						  , 'Fire'
						  , 'Missing/Found Property'
						  , 'Airplane Emergency'
						  , 'Explosive Device'
						  , 'Injured Officer'
						)
						THEN 'General Service & Admin'
						ELSE 'Other'
					END
FROM LVMPD_Crime_DW.dbo.lkpIncidentType a

CREATE UNIQUE CLUSTERED INDEX UC_IDX_IncidentTypeCode ON LVMPD_Crime_DW.dbo.lkpIncidentType( IncidentTypeCode )
