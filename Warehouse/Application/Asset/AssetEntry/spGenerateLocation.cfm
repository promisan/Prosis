
<cfquery name="MovementRecord" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 INSERT INTO AssetMovement
 (MovementCategory, OfficerUserId, OfficerLastName, OfficerFirstName) 
 VALUES ('001','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
</cfquery>

<cfquery name="SelectMovement" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT TOP 1 MovementId
 FROM AssetMovement
 WHERE OfficerUserId = '#SESSION.acc#'
 ORDER BY Created DESC
</cfquery>

<cfquery name="Select" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  INSERT INTO AssetItemOrganization
				 (AssetId, 
				  MovementId, 
				  OrgUnit, 
				  DateEffective, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
	   SELECT     I.AssetId, 
	              '#SelectMovement.MovementId#', 
				  M.ReceiptOrgUnit, 
				  '#DateFormat(now(),CLIENT.DateSQL)#', 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#'
	 FROM         AssetItem I INNER JOIN
                  Ref_ParameterMission M ON I.Mission = M.Mission
	 WHERE     (I.AssetId NOT IN
                   (SELECT     AssetId
                    FROM          AssetItemOrganization))
</cfquery>					

<cfquery name="Select" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  INSERT INTO AssetItemLocation
				 (AssetId, 
				  MovementId,
				  Location, 
				  Status,
				  DateEffective, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
				
	   SELECT     I.AssetId, 
	              '#SelectMovement.MovementId#', 
				  M.ReceiptLocation, 
				  '1',
				  '#DateFormat(now(),CLIENT.DateSQL)#', 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#'
	 FROM         AssetItem I INNER JOIN
                  Ref_ParameterMission M ON I.Mission = M.Mission
	 WHERE     (I.AssetId NOT IN
                   (SELECT     AssetId
                    FROM          AssetItemLocation))
</cfquery>					

	