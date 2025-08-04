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

<!--- configuration file --->
			
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   role              = "'AssetHolder','AssetUser'"	   
	   anyunit           = "No"	   
	   returnvariable    = "accessright">	
	   
	<cfif accessright eq "DENIED">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
				<tr><td align="center" height="100" class="labelmedium"><cf_tl id="You have not been granted rights to this function. Option not available"></td></tr>
		</table>
		<cfabort>
	
	</cfif>   

<cfoutput>

<cfsavecontent variable="myquery">
SELECT   R.RequestId,
          R.Reference, 
          R.Warehouse, 
		  R.RequestDate, 
		  O.OrgUnitName as OrgUnit, 
		  R.OfficerUserId, 
		  R.OfficerLastName, 
		  R.OfficerFirstName,
		  R.RequestedQuantity, 
		  I.ItemDescription, 
		  I.Category
 FROM     Request R INNER JOIN Item I ON R.ItemNo = I.ItemNo INNER JOIN Organization.dbo.Organization O ON  R.OrgUnit = O.OrgUnit
 WHERE    R.ItemClass = 'Asset' 
 AND      R.Status >= '2' 
 AND      R.Status < '3'
 AND      R.Mission = '#URL.Mission#' 
  
 <cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
 <cfelse> 
 
 AND      I.Category IN (SELECT  DISTINCT ClassParameter 
			     		 FROM    Organization.dbo.OrganizationAuthorization 
					     WHERE   UserAccount = '#SESSION.acc#'
					     AND     Mission = '#URL.Mission#' 
					     AND     Role IN ('AssetManager', 'AssetHolder'))				
 </cfif>				
</cfsavecontent>

<cfset fields=ArrayNew(1)>
<cf_tl id="Reference" var = "1">
<cfset fields[1] = {label   = "#lt_text#",                   
					field   = "Reference",
					search  = "text"}>
					
<cf_tl id="Date" var = "1">
<cfset fields[2] = {label   = "#lt_text#",                 			
					field   = "RequestDate",
					formatted  = "dateformat(RequestDate,CLIENT.DateFormatShow)",
					search  = "date"}>									

<cf_tl id="Unit" var = "1">					
<cfset fields[3] = {label   = "#lt_text#",                   
					field   = "OrgUnit",
					search  = "text"}>		

<cf_tl id="Requester" var = "1">							
<cfset fields[4] = {label   = "",                   
					alias   = "R",
					field   = "OfficerLastName",
					search  = "text"}>								

<cf_tl id="Item" var = "1">												
<cfset fields[5] = {label   = "#lt_text#",                  
					field   = "ItemDescription",
					search  = "text"}>										

<cf_tl id="Quantity" var = "1">							
<cfset fields[6] = {label   = "#lt_text#", 					
					field   = "RequestedQuantity",
					formatted  = "numberformat(RequestedQuantity,'__,__.__')"}>						
									
<cf_listing
    box            = "setting"
	link           = "#SESSION.root#/Warehouse/Application/Asset/Request/RequestListing.cfm?mission=#url.mission#"
    html           = "No"	
	datasource     = "AppsMaterials"
	tablewidth     = "99%"	
	filterShow     = "Hide"
	excelShow      = "Yes"
	listquery      = "#myquery#"
	listkey        = "RequestId"		
	listorder      = "RequestDate"
	listorderalias = "R"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	drillmode      = "window"
	drillargument  = "680;860;false;false"	
	drilltemplate  = "Warehouse/Application/Asset/Request/RequestEntry.cfm?requestid="
	drillkey       = "RequestId">	
	
</cfoutput>	
