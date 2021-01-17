<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	<cfif url.layoutmode eq "listing">
		SELECT 	*
		FROM	Ref_PayrollLocation
		ORDER BY LocationCode
	<cfelseif url.layoutmode eq "missions">
		SELECT 	L.*, M.Mission
		FROM   	Ref_PayrollLocation L
				LEFT OUTER JOIN Ref_PayrollLocationMission M
					ON L.LocationCode = M.LocationCode
		<cfif url.mission eq "">
		WHERE	M.Mission is null
		<cfelse>
		WHERE	M.Mission = '#url.mission#'
		</cfif>
		ORDER BY M.Mission
	</cfif>
   
</cfquery>

<cfquery name="Designations" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_PayrollLocationDesignation
</cfquery>

<cfset vNumberCols = 7>

<cfif url.layoutmode eq "listing">
	<cfset vNumberCols = 8>
</cfif>

<table width="100%" align="center" class="navigation_table">

	<cfoutput query="SearchResult">
	
		<tr class="labelmedium2 line navigation_row">
			<td width="1%" align="center" style="padding-top:1px">			
			 <cf_img icon="select" onclick="recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">			 
			</td>			
			<td width="8%" align="center">#LocationCode#</td>	
			<td width="18%" align="center">#LocationCountry#</td>
			<td width="20%">#Description#</td>
			<td width="15%" align="center">#dateformat(dateeffective,CLIENT.DateFormatShow)#</td>
			<td width="15%" align="center">#dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>
			
			<cfset designationsWidth = "20%">
			<cfif url.layoutmode eq "listing">
				<cfset designationsWidth = "10%">
				<td align="center" width="10%">
				
					<cfquery name="LocationMissions" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM 	Ref_PayrollLocationMission
						WHERE 	LocationCode = '#locationcode#'
						ORDER BY Mission DESC
					</cfquery>
					
					<cfset missionsList = quotedValueList(LocationMissions.mission)>
					<cfset missionsList = replace(missionsList,"'","","ALL")>
					<cfset missionsList = replace(missionsList,",",", ","ALL")>
					
					#missionsList#
					
				</td>
			</cfif>
			<td align="center" width="#designationsWidth#">
			
				<cfquery name="qDesignations" dbtype="query">
					SELECT 	*
					FROM 	Designations
					WHERE 	LocationCode = '#locationcode#'
				</cfquery>
				#qDesignations.recordCount#
				
			</td>
		</tr>
		
	</cfoutput>
</table>

<cfset ajaxonload("doHighlight")>
	
	

