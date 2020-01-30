
<cfoutput>

	<cfif MissionOrgUnitId neq "">
	
		<cfquery name="Unit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM Organization
		WHERE MissionOrgUnitId = '#MissionOrgUnitId#'
		AND Mission = '#Mission#'
		ORDER BY Created 
		</cfquery>
	
		<cfset orgunit 		= "#Unit.OrgUnit#">
		<cfset orgunitname  = "#Unit.OrgUnitName#">
	
	<cfelse>
	
		<cfset orgunit     = "">
		<cfset orgunitname = "">
	
	</cfif>
	
	<tr class="labelmedium navigation_row">

	<td width="20" style="height:20px;padding-right:6px;padding-top:1px;padding-left:#indent#px">	
		<cf_img icon="select" navigation="Yes" onclick="Selected('#Location#','#LocationCode#','#LocationName#','#OrgUnit#','#OrgUnitName#','#PersonNo#','');">			
	</td>
	<td style="padding-right:5px">#LocationCode#</td>
	<TD width="60%">#LocationName#</TD>
	<td width="30%">#AddressCity#</td>
	<td align="right" style="padding-right:3px">
	
		<cfif latitude neq "" and longitude neq "">		
		   <input type="hidden" name="location_#locationcode#" id="location_#locationcode#" value="#latitude#:#longitude#">		   
		   <cf_img icon="open" onclick="openmap('location_#locationcode#')">			
		
		</cfif>
	
	</td>	
	</tr>
		  
</cfoutput>