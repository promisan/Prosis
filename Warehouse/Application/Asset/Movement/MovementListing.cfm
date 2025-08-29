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
<cfinvoke component = "Service.Process.Materials.Asset"  
	   method           = "AssetList" 
	   mission          = "#URL.Mission#"		
	   role             = "'AssetHolder','AssetUser'"  
	   table            = "#SESSION.acc##URL.Mission#AssetTree"
	   disposal         = "0">	
     		
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   role              = "'AssetHolder','AssetUser'"	   
	   anyunit           = "No"	   
	   returnvariable    = "accessright">	
	      
<cfif accessright eq "DENIED">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
				<tr><td align="center" height="100" class="labelmedium"><cf_tl id="You have been granted only read rights. Option not available"></td></tr>
		</table>
		<cfabort>
	
	</cfif>   

<cfparam name="URL.Mission" default="">

<cfquery name="Reset" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	UPDATE AssetMovement	
	SET    ActionStatus = '9'
	FROM   AssetMovement R
	WHERE  MovementId NOT IN (SELECT MovementId FROM AssetItemOrganization WHERE MovementId = R.MovementId)
	AND    MovementId NOT IN (SELECT MovementId FROM AssetItemLocation     WHERE MovementId = R.MovementId)
</cfquery>

<cfquery name="Listing" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     M.*, 
	           L.LocationName AS LocationName, 
			   O.OrgUnitName AS OrganizationName, 
			   P.LastName AS PersonLastName, 
			   P.FirstName AS PersonFirstName, 
	           P.IndexNo AS PersonIndexNo
	FROM       AssetMovement M LEFT OUTER JOIN
	           Employee.dbo.Person P ON M.PersonNo = P.PersonNo LEFT OUTER JOIN
	           Organization.dbo.Organization O ON M.OrgUnit = O.OrgUnit LEFT OUTER JOIN
	           Location L ON M.Location = L.Location
	WHERE      M.Mission          = '#URL.Mission#' 
	AND        M.MovementCategory = '002' 
	AND        M.ActionStatus     = '0'
	ORDER BY M.Created DESC
</cfquery>
				  
<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">				  

<cfoutput>
<tr><td height="34" colspan="1" class="labellarge"><cf_tl id="Pending Movement Requests"></td></tr>
</cfoutput>

<tr><td height="1" class="linedotted"></td></tr>

<tr><td height="4"></td></tr>
<tr><td>

	<table width="98%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">
		
	<tr>
	  <td></td>
	  <td></td>
	   <td class="labelit"><cf_tl id="Document"></td>
	   <td class="labelit" colspan="3"><b><cf_tl id="Movement to">:</td>
	   <td class="labelit" colspan="2"><b><cf_tl id="Request"></td>
	</tr>	
	
	<tr>
		<td>&nbsp;</td>
		<td width="20"></td>
		<td class="labelit"><cf_tl id="No">:</td>
		<td class="labelit"><cf_tl id="Location"></td>
		<td class="labelit"><cf_tl id="Unit"></td>
		<td class="labelit"><cf_tl id="Employee"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date"></td>
	</tr>	
	
	<tr><td colspan="8" height="1" class="linedotted"></td></tr>
	
	<cfoutput query="Listing">		

		<tr class="navigation_row">
		   
			<td style="height:20;cursor: pointer;" 
			  onClick="more('#currentrow#','#SESSION.root#/warehouse/application/asset/movement/MovementDetail.cfm?movementid=#movementid#')">
				
			<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="#currentrow#Exp" border="0" class="regular" 
				align="middle" style="cursor: pointer;">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="#currentrow#Min" alt="" border="0" 
				align="middle" class="hide" style="cursor: pointer;">
				
			</td>
			<td style="padding-left:4px;padding-top:1px">			
			<cf_img icon="open" navigation="Yes" onClick="javascript:process('#MovementId#')">											
			</td>
			<td class="labelit">#Reference#</td>
			<td class="labelit"><cfif LocationName eq "">Same<cfelse>#LocationName#</cfif></td>
			<td class="labelit">#OrganizationName#</td>
			<td class="labelit"><cfif PersonNo eq "">Same<cfelse>#PersonFirstName# #PersonLastName#</cfif></td>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="labelit">#dateformat(created,CLIENT.DateFormatShow)#</td>
			
		</tr>
		
		<tr id="box#currentrow#" class="hide">
		    <td colspan="2"></td>
			<td colspan="6" id="c#currentrow#"></td>
		</tr>
	
	</cfoutput>
	
	</table>

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	