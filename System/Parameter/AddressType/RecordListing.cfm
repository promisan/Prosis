
<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	*
		FROM 	Ref_AddressType
		ORDER BY ListingOrder ASC
</cfquery>


<cfset Header       = "address type">
<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderParameter.cfm"></td></tr>

<cfoutput>

	<script>
	
		function recordedit(id1) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAddressType", "left=80, top=80, width=900, height= 550, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordadd() {
			recordedit('');
		}
	
	</script>

</cfoutput> 

<tr><td colspan="2">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

	<tr class="labelmedium2 line fixlengthlist">
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
		    
		    <tr class="line labelmedium2 navigation_row fixlengthlist"> 
				<td align="center" style="padding-top:1px">
				   <cf_img icon="open" onclick="recordedit('#Code#');" navigation="yes">
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

</cf_divscroll>

</td>

</tr>

</table>
