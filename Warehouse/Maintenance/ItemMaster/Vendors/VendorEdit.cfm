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
<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	V.*,		 			
		 			(
						SELECT 	OrgUnitName 
						FROM 	Organization.dbo.Organization
						WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
						AND 	OrgUnit = V.OrgUnitVendor
					) as VendorName,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = V.UoM) as UoMDescription,
					(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemno#') as ItemDescription
		 FROM      	ItemVendor V
		 WHERE     	V.ItemNo = '#url.itemno#'
		 <cfif url.uom neq "" and url.orgunitvendor neq "">	
		 AND		V.UoM = '#url.uom#'
		 AND		V.OrgUnitVendor = #url.orgunitvendor#
		 <cfelse>
		 AND		1 = 0
		 </cfif>
</cfquery>

<cfquery name="getVendorTree" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	TreeVendor 
		FROM 	Ref_ParameterMission 
		WHERE 	Mission = '#url.mission#'
</cfquery>	

<cfif url.uom neq "" and url.orgunitvendor neq "">	
	<cf_tl id = "Maintain" var = "1">	
	<!---
	<cf_screentop height="100%" scroll="Yes" html="No" label="Vendor Item/UoM" option="#lt_text# #get.VendorName# #get.ItemDescription#/#get.UoMDescription#" layout="webapp" banner="gray" user="no">
	--->
<cfelse> 
	<cf_tl id = "Add Vendor Item/UoM" var = "1">	
	<!---
	<cf_screentop height="100%" scroll="Yes" html="No" label="Vendor Item/UoM" option="#lt_text#" layout="webapp" user="no">
	--->
</cfif>

<table width="95%" align="center">
	<tr>
		<td id="vendorheader">
			<cfinclude template="VendorEditHeader.cfm">
		</td>
	</tr>
	<cfif url.uom neq "" and url.orgunitvendor neq "">
	<tr>
		<td id="vendordetail">
			<cfinclude template="VendorEditDetail.cfm">
		</td>
	</tr>
	</cfif>
</table>