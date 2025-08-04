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

<cfif url.assetId eq "">
 <cfset url.assetid = CLIENT.assetid>
<cfelse>
	<cfset CLIENT.assetid = url.assetid>
</cfif>
<cfset url.assetid = replace(url.assetid,"'","","all")>

<cfquery name="SearchResult" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT     O.AssetId, 
             O.MovementId, 
			 O.ActionStatus, 
			 O.OrgUnit, 
			 O.PersonNo, 
			 O.DateEffective, 
			 M.MovementCategory, 
			 M.Reference, 
			 R.Description,
			 O.OfficerUserId,
			 O.OfficerLastName,
			 O.OfficerFirstName
  FROM       AssetItemOrganization O INNER JOIN
             AssetMovement M ON O.MovementId = M.MovementId INNER JOIN
             Ref_Movement R ON M.MovementCategory = R.Code
  WHERE      O.AssetId = '#URL.AssetId#' 			 
  ORDER BY   O.DateEffective DESC  
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<tr><td class="labellarge" style="height:30px"><cf_tl id="Movement Log"></td></tr>
<tr class="labelmedium line">
	<td style="padding-left:10px"><cf_tl id="Effective"></td>
	<td><cf_tl id="Movement"></td>
	<td><cf_tl id="Unit"></td>
	<td><cf_tl id="Holder"></td>
	<td><cf_tl id="Reference"></td>
	<td><cf_tl id="Status"></td>	
	<td><cf_tl id="Officer"></td>	
</tr>

<cfoutput query="Searchresult">
	<tr class="labelit line navigation_row">
	<td style="padding-left:10px">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
	<td>#Description#</td>
	
		<cfquery name="Org" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM       Organization
		  WHERE    OrgUnit = '#OrgUnit#'
		</cfquery>
		
	<td>#Org.OrgUnitName#</td>
	
		<cfquery name="Per" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM     Person
		  WHERE    PersonNo = '#PersonNo#'
		</cfquery>
	
	<td><cfif per.fullname eq ""><cf_tl id="Undefined"><cfelse><a href="javascript:EditPerson('#PersonNo#')">#Per.FullName#</a></cfif></td>
	<td>#Reference#</td>
	<td><cfif actionStatus eq "1"><cf_tl id="Confirmed"><cfelse><cf_tl id="Pending"></cfif></td>
	<td>#OfficerLastName#</td>
	</tr>
</cfoutput>
</table>

<cfset ajaxonLoad("doHighlight")>