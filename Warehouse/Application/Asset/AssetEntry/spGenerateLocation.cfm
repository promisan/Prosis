<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

	