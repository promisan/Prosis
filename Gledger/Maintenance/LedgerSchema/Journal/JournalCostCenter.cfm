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

<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Journal
	WHERE  Journal = '#URL.ID1#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   Ref_Mandate
	WHERE  Mission = '#get.Mission#'
	ORDER BY MandateDefault DESC	
</cfquery>

<table width="100%">

<tr>
		
		<td style="height:30px" class="labelmedium"> 
				
			<cfset link = "#SESSION.root#/Gledger/Maintenance/LedgerSchema/Journal/JournalCostCenterList.cfm?id1=#url.id1#">
			
			<cf_selectlookup
			    class        = "Organization"
			    box          = "myprocess"
				modal        = "false"
				close		 = "yes"				
				title        = "Add Cost center"
				height		 = "150"
				width		 = "500"
				style        = "height:22;width:250"
				label        = "Add cost center"
				button       = "yes"							
				link         = "#link#"			
				dbtable      = "Organization.dbo.Organization"
				des1         = "OrgUnit"
				filter1      = "Mission"
				filter1Value = "#get.Mission#"
				filter2      = "MandateNo"
				filter2Value = "#Mandate.MandateNo#">
		</td>
		
</tr>

<tr>		
		
		<td id="myprocess" width="100%">							
			<cfinclude template="JournalCostCenterList.cfm">		
		</td>
		
</tr>

</table>
	
<cfset ajaxonload("doHighlight")>
	