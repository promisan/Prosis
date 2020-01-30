
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

