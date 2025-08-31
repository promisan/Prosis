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
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ProgramFinancial
	ORDER 	BY ListingOrder
</cfquery>

<cfset Header = "Project Financial Metrics">

<cfinclude template="../HeaderMaintain.cfm">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddFinancial", "left=80, top=80, width=700, height=500, toolbar=no, status=no, scrollbars=yes, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditFinancial", "left=80, top=80, width=700, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Order</td>
		<td>Categories</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>

<cfoutput query="SearchResult">    
 
	<tr class="navigation_row">
	    <td width="2%" style="padding-left:4px;padding-top:2px">
		    <cf_img icon="select" onclick="recordedit('#Code#')" navigation="Yes">
		</td>
		<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>	
		<td>#Description#</td>
		<td>#ListingOrder#</td>
		<td>
		
			<cfquery name="Category"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*,
						(SELECT Description FROM Ref_ProgramCategory WHERE Code = C.ProgramCategory) as ProgramCategoryDescription
				FROM 	Ref_ProgramFinancialCategory C
				WHERE 	Code = '#Code#'	
			</cfquery>
		
			<cfset vCategories = "">
			
			<cfloop query="Category">
				<cfset vCategories = vCategories & ProgramCategoryDescription & ", ">
			</cfloop>
			<cfif len(vCategories) gt 0>
				<cfset vCategories = mid(vCategories,1,len(vCategories)-2)>
			</cfif>
			
			#vCategories#
		
		</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>
</tbody>

</table>

