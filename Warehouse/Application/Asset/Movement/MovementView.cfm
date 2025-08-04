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

<cf_screentop height="100%" scroll="Yes" jquery="Yes" label="Movement Request" layout="webapp" line="no" banner="gray">

<cfparam name="URL.MovementId" default="00000000-0000-0000-0000-000000000000">

<cfform action="MovementViewSubmit.cfm" method="POST" name="movement" id="movement">

<cf_dialogMail>
<cf_dialogProcurement>
<cf_dialogOrganization>
<cf_dialogAsset>
<cfajaximport>

<cfoutput>
	
	<script language="JavaScript">
	
	function movedel(id,asset,sta,tab) {
	     
		 if (confirm("Do you want to remove this item from the list ?"))  {
		   
		   _cf_loadingtexthtml='';	 
	       ColdFusion.navigate('MovementItemsDelete.cfm?id='+id+'&id1='+asset+'&actionStatus='+sta+'&table='+tab,'boxassets')			  
		 }			
		}	
		
	function reloadForm(id,sort,view) {
	    ColdFusion.navigate('MovementItems.cfm?movementId='+id+'&sort='+sort+'&view='+view,'boxassets')		
		}  	
		
	</script>

</cfoutput>

<cfparam name="Form.AssetId" default="'{00000000-0000-0000-0000-000000000000}'">

<cfquery name="Movement" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  M.*, O.OrgUnitName, P.IndexNo, P.LastName, P.FirstName, L.LocationCode, L.LocationName
	
	FROM    AssetMovement M LEFT OUTER JOIN
            Employee.dbo.Person P ON M.PersonNo = P.PersonNo LEFT OUTER JOIN
            Organization.dbo.Organization O ON M.OrgUnit = O.OrgUnit LEFT OUTER JOIN
            Location L ON M.Location = L.Location	
	
	WHERE  M.MovementId = '#URL.MovementId#'
	
</cfquery>

<cfoutput query="Movement">

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="5"></td></tr>
<tr class="labelmedium">
 <td width="20%" class="labelit"><cf_tl id="Status">:</td>
 <td colspan="5"><b><cfif ActionStatus eq "1"><cf_tl id="Cleared"><cfelse><cf_tl id="Pending"></cfif></b></td>
</tr>

<cfquery name="Check" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  top 1 *
    FROM    AssetItemOrganization
    WHERE   MovementId = '#URL.MovementId#'
</cfquery>	

<cfif Check.Requestid neq "">
	
	<cfquery name="Request" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Request 
		 WHERE    RequestId = '#Check.RequestID#'
	</cfquery>
	
	<tr class="labelmedium">
		<td width="100"><cf_tl id="Requester">:</td><td>#Request.OfficerFirstName# #Request.OfficerLastName#</td>
		<td><cf_tl id="Date">:</td><td>#DateFormat(Request.requestDate,CLIENT.DateFormatShow)#</td>
	</tr>
	
	<tr class="labelmedium">
	<td width="100"><cf_tl id="Requistion No">:</td><td>#Request.Reference#</td>
	<td><cf_tl id="Original Quantity">:</td><td>#Request.RequestedQuantity#</td>
	</tr>

</cfif>
<tr class="labelmedium">
 <td width="20%"><cf_tl id="Transaction No">:</td>
 <td colspan="5">#Movement.Reference#</b></td>
</tr>

<cfif DateEffective neq "">
<tr class="labelmedium">
  <td><cf_tl id="Effective date">:</td>
  <td colspan="5">#dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
</tr> 
</cfif>

<tr class="labelmedium">
  <td width="100"><cf_tl id="Move to location">:</td>
  <td><cfif locationCode eq "">Same<cfelse>#LocationCode# #LocationName#</cfif>
  <td width="100"><cf_tl id="Unit">:</td>
  <td><cfif orgunitname eq ""><cf_tl id="Same"><cfelse>#OrgUnitName#</cfif></td>
  <td width="120"><cf_tl id="Employee">:</td>
  <td><cfif firstname eq ""><cf_tl id="Same"><cfelse>#FirstName# #LastName#</cfif></td>
</tr>

<tr><td height="1" class="line" colspan="6"></td></tr>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset1">	

<cfquery name="Step0" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   L.AssetId
INTO     userQuery.dbo.#SESSION.acc#Asset1
FROM     AssetMovement M INNER JOIN
         AssetItemLocation L ON M.MovementId = L.MovementId
WHERE    M.MovementId = '#URL.MovementId#'
UNION
SELECT   L.AssetId
FROM     AssetMovement M INNER JOIN
         AssetItemOrganization L ON M.MovementId = L.MovementId
WHERE M.MovementId = '#URL.MovementId#'
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetMove2">	

<!--- query items involved in the moment --->

<cfquery name="Base" 
  datasource="appsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT     DISTINCT 
             P.Category AS AssetClass, 
             P.ItemDescription AS ParentDescription, 
			 P.DepreciationScale AS DepreciationScale, 
	         P.ItemNo AS WarehouseItemNo, 
			 I.*, 
			 O.OrgUnit AS OrgUnit, 
			 O.PersonNo AS PersonNo, 
			 O.DateEffective AS DateEffective,
			 O.ActionStatus AS OrgStatus,
			 O.MovementId as OrgMovementId,
			 L.Location, 
			 L.DateEffective as LocationEffective, 
			 L.Status as LocationStatus, 
			 L.MovementId as LocationMovementId,   
			 Pur.PurchaseNo
  INTO       userQuery.dbo.#SESSION.acc#AssetMove2	
  FROM       Item P INNER JOIN AssetItem I ON P.ItemNo = I.ItemNo 
             LEFT OUTER JOIN AssetItemOrganization O ON I.AssetId = O.AssetId AND O.MovementId = '#URL.MovementId#'
			 LEFT OUTER JOIN AssetItemLocation L ON I.AssetId = L.AssetId AND L.MovementId = '#URL.MovementId#'
			 LEFT OUTER JOIN Purchase.dbo.PurchaseLine Pur ON I.RequisitionNo = Pur.RequisitionNo   
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset1">	

<tr>
	<td colspan="6" id="boxassets">
		
	<!--- 13/4/2012 adjustment for workflow object --->
	<cfset url.table = "2">		
	<cfinclude template="MovementItems.cfm">   

</td></tr>

<tr><td colspan="6">

<cfajaximport>

<cfset link = "Warehouse/Application/Asset/Movement/MovementView.cfm?movementId=#URL.MovementId#">

	<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObject
	   WHERE   ObjectKeyValue4 = '#URL.MovementId#'	  
	</cfquery>
		
	<cf_ActionListing 
		    EntityCode        = "AssMovement"
			EntityClass       = "#Object.EntityClass#"
			EntityGroup       = ""
			EntityStatus      = ""			
			ObjectReference   = "Equipment movement request"
			ObjectReference2  = "#FirstName# #LastName#"
		    ObjectKey4        = "#URL.MovementId#"
			ObjectURL         = "#link#"
			Show              = "Yes"
			CompleteFirst     = "No">

</td></tr>

</table>

</cfoutput>

</cfform>

<cf_screenbottom layout="webapp">

