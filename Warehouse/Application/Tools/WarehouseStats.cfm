<!--
    Copyright © 2025 Promisan

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


<CF_DropTable dbName="AppsMaterials"  full="true" tblName="skAssetItem">	

<cf_verifyOperational 
         module="Procurement" 
		 Warning="No">
		 		 
<cfquery name="Base" 
  datasource="appsMaterials">
  
  SELECT     DISTINCT 
             P.Category AS AssetClass, 
             P.ItemDescription AS ParentDescription, 
			 P.DepreciationScale AS DepreciationScale, 
	         P.ItemNo AS WarehouseItemNo, 
			 I.*,
			 <cfif operational eq "1">
			 PL.PurchaseNo,
			 </cfif>
			 O.OrgUnit AS OrgUnit, 
			 O.PersonNo AS PersonNo, 
			 O.DateEffective AS DateEffective,
			 O.ActionStatus AS OrgStatus,
			 O.MovementId as OrgMovementId,
			 L.Location, 
			 L.DateEffective as LocationEffective, 
			 L.Status as LocationStatus, 
			 L.MovementId as LocationMovementId
			 
	INTO       dbo.skAssetItem			 
			 
  FROM       AssetItem I INNER JOIN
             AssetItemLocation L ON I.AssetId = L.AssetId INNER JOIN
             Item P ON I.ItemNo = P.ItemNo INNER JOIN
             AssetItemOrganization O ON I.AssetId = O.AssetId
			 <cfif operational eq "1">
			 LEFT OUTER JOIN Purchase.dbo.PurchaseLine PL ON I.RequisitionNo = PL.RequisitionNo
			 </cfif>   

  WHERE     (L.MovementId =
                 (SELECT     TOP 1 MovementId
                   FROM          AssetItemLocation
                   WHERE      AssetId = I.AssetId
                   ORDER BY DateEffective DESC)) 
   AND      (O.MovementId =
                 (SELECT     TOP 1 MovementId
                  FROM          AssetItemOrganization
                  WHERE      AssetId = I.AssetId
                  ORDER BY DateEffective DESC)
			)
  
	ORDER BY ItemDescription 
	
</cfquery>

