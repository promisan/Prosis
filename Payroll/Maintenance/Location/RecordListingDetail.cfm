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

<table width="100%" align="center">
	<cfoutput query="SearchResult">
		<tr class="labelmedium linedotted" style="height:22px">
			<td width="1%" align="center" style="padding-top:1px">
			
			 <cf_img icon="edit" onclick="recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">
			 
			</td>
			
			<td width="8%" align="center"><a href="javascript:recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">#LocationCode#</a></td>	
			<td width="18%" align="center"><a href="javascript:recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">#LocationCountry#</a></td>
			<td width="20%"><a href="javascript:recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">#Description#</a></td>
			<td width="15%" align="center"><a href="javascript:recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">#dateformat(dateeffective,CLIENT.DateFormatShow)#</a></td>
			<td width="15%" align="center"><a href="javascript:recordedit('#LocationCode#', '#url.mission#', '#url.layoutmode#')">#dateformat(dateexpiration,CLIENT.DateFormatShow)#</a></td>
			
			<cfset designationsWidth = "20%">
			<cfif url.layoutmode eq "listing">
				<cfset designationsWidth = "10%">
				<td align="center" width="10%" class="regular">
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
	
	

