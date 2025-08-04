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

<cfparam name="URL.DisposalId" default="00000000-0000-0000-0000-000000000000">

<cfparam name="Form.AssetId" default="'{00000000-0000-0000-0000-000000000000}'">

<cfquery name="Disposal" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
 	FROM      AssetDisposal A INNER JOIN
    	      Ref_Disposal R ON A.DisposalMethod = R.Code
	WHERE     A.DisposalId = '#URL.DisposalId#'
</cfquery>

<cfif Disposal.recordcount eq "0">
 <script>
 window.close()
 </script>
</cfif>

<cfquery name="Workflow" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
 	FROM      OrganizationObject
	WHERE     ObjectKeyValue4 = '#URL.DisposalId#'
</cfquery>

<cf_screentop height="100%" scroll="Yes" label="Disposal Request" 
			systemmodule="Warehouse"
			FunctionClass="Window"
			FunctionName="Asset Disposal" layout="webapp" line="no" banner="gray" bannerforce="Yes" menuaccess="context">

<cfoutput query="Disposal">

	<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>
	 <td height="20" class="labelmedium" width="10%">&nbsp;<cf_tl id="Status">:</td>
	 <td colspan="5" class="labelmedium"><cfif ActionStatus eq "1"><cf_tl id="Cleared"><cfelse><cf_tl id="Pending"></cfif></b></td>
	</tr>
	
	<tr>
	 <td height="20" class="labelmedium" width="10%">&nbsp;<cf_tl id="Reference No">:</td>
	 <td colspan="5" class="labelmedium">#DisposalReference#</b></td>
	</tr>
	
	<tr>
	  <td height="20" class="labelmedium">&nbsp;<cf_tl id="Memo">:</td>
	  <td colspan="5" class="labelmedium">#DisposalRemarks#</td>
	</tr> 
	
	<tr><td height="1" class="linedotted" colspan="6"></td></tr>
		
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset2">	
	
		<cfquery name="Prepare" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT 
	             P.Category AS AssetClass, 
	             P.ItemDescription AS ParentDescription, 
				 P.DepreciationScale AS DepreciationScale, 
		         P.ItemNo AS WarehouseItemNo, 
				 I.*,			
				 O.OrgUnit,
				 PL.PurchaseNo,			  
				 O.PersonNo AS PersonNo, 
				 O.DateEffective AS DateEffective,
				 O.ActionStatus AS OrgStatus,
				 O.MovementId as OrgMovementId,
				 L.Location, 
				 L.DateEffective as LocationEffective, 
				 L.Status as LocationStatus, 
				 L.MovementId as LocationMovementId
				 
	  	INTO     userQuery.dbo.#SESSION.acc#Asset2 
				 
	  	FROM     AssetItem I INNER JOIN
	             AssetItemLocation L ON I.AssetId = L.AssetId INNER JOIN
	             Item P ON I.ItemNo = P.ItemNo INNER JOIN
	             AssetItemOrganization O ON I.AssetId = O.AssetId LEFT OUTER JOIN Purchase.dbo.PurchaseLine PL ON I.RequisitionNo = PL.RequisitionNo
							 
	    WHERE      I.AssetId IN (SELECT AssetId FROM AssetItemDisposal WHERE DisposalId = '#URL.disposalid#')		 
	
	    AND       (L.MovementId =
	                          (SELECT     TOP 1 MovementId
	                            FROM          AssetItemLocation
	                            WHERE      AssetId = I.AssetId
	                            ORDER BY DateEffective)) 
	    AND       (O.MovementId =
	                          (SELECT     TOP 1 MovementId
	                            FROM          AssetItemOrganization
	                            WHERE      AssetId = I.AssetId
	                            ORDER BY DateEffective)) 
								
	</cfquery>							
	
	<tr>
	<td colspan="6">
	
	<iframe src="DisposalItems.cfm?ts=#now()#&disposalid=#URL.disposalid#&actionStatus=#Disposal.ActionStatus#&table=2"
	    id="items" name="items" width="100%" height="20" scrolling="no" frameborder="0"></iframe>
		
	</td></tr>
		
	<tr><td colspan="6">
	
	<cfset link = "Warehouse/Application/Asset/Disposal/DisposalView.cfm?disposalid=#URL.DisposalId#">
		
	<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObject
	   WHERE   ObjectKeyValue4 = '#URL.DisposalId#'	  
	</cfquery>
		
	<cf_ActionListing 
			EntityCode       = "assDisposal"
			EntityClass      = "#Object.EntityClass#"
			Mission          = "#Disposal.mission#"		
			ObjectReference  = "Disposal request under No:#Disposal.DisposalReference#"
			ObjectKey4       = "#url.disposalid#"
			ObjectURL        = "#link#"
			Show             = "Yes"		
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "Yes">	
					
			
	</td></tr>
	
	</table>

</cfoutput>

<cf_screenbottom layout="webapp">

