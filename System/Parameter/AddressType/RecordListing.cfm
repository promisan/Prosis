<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	*
		FROM 	Ref_AddressType
		ORDER BY ListingOrder ASC
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderParameter.cfm"> 	

<table width="97%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

	<script>
	
		function recordedit(id1) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAddressType", "left=80, top=80, width=900, height= 550, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordadd() {
			recordedit('');
		}
	
	</script>

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td align="center">Selfservice</td>
		<td align="center">Order</td>
		<td>Enabled Entities</td>
		<td align="left">Officer</td>
	    <td align="left">Entered</td>
	</tr>
	
		<cfoutput query="SearchResult">
		    
		    <tr class="line labelmedium navigation_row"> 
				<td align="center" style="padding-top:3px">
				   <cf_img icon="select" onclick="recordedit('#Code#');" navigation="yes">
				</td>
				<td>#Code#</td>
				<td>#Description#</td>
				<td align="center"><cfif selfservice eq 1>Yes<cfelse>No</cfif></td>
				<td align="center">#listingOrder#</td>
				<td>
					<cfquery name="GetMissions" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	Mission 
							FROM 	Ref_AddressTypeMission 
							WHERE 	Code = '#Code#'
					</cfquery>
					<cfset MissionList = "">
					<cfloop query="GetMissions">
						<cfset MissionList = MissionList & ", " & Mission>
					</cfloop>
					<cfif len(MissionList) gt 0>
						<cfset MissionList = mid(MissionList, 3, len(MissionList))>
					</cfif>
					#MissionList#
				</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
				
		    </tr>
		
		</cfoutput>
	
</table>

</td>

</tr>

</table>

</cf_divscroll>