
<cfquery name="Topic" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_GroupMission
	  WHERE  Code IN (SELECT GroupCode FROM Ref_GroupMissionList)
	  
	  AND    Code IN (SELECT GroupCode FROM Ref_GroupMissionType WHERE MissionType = '#url.missionType#')
	  
</cfquery>
	
<cfif Topic.recordcount gt "0">

	<table cellspacing="0" cellpadding="0" class="formpadding">

	<cfoutput query="topic">
		
	<tr class="labelmedium">
		<td style="min-width:200px;padding-left:40px">#Description#: <font color="FF0000">*</font><cf_space spaces="40"></td>
		<td style="width:100%">
		
			<cfquery name="List" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT *
			   FROM    Ref_GroupMissionList
			   WHERE   GroupCode = '#Code#'
			</cfquery>
			
			<cfquery name="MissionTopic" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  TOP 1 *
			  FROM    Ref_MissionGroup
			  WHERE   Mission  = '#URL.Mission#'
			  AND     GroupCode = '#Code#'
		    </cfquery>
							
			<select name="ListCode_#Code#" id="ListCode_#Code#" class="enterastab regularxl">
			    <option value=""><cf_tl id="N/A"></option>
				<cfloop query="List">
				<option value="#GroupListCode#" <cfif MissionTopic.GroupListCode eq GroupListCode>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
		
		</td>
	</tr>
	
	</cfoutput>
	
	</table>
	
	
</cfif>