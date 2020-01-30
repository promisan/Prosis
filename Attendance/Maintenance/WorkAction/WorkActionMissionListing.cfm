<cfquery name="missionlist"
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	PM.*,
				M.MissionName,
				(SELECT Mission FROM Ref_WorkActionMission WHERE Mission = M.Mission AND ActionClass = '#url.id1#') as Selected
		FROM 	Ref_ParameterMission PM
				INNER JOIN Organization.dbo.Ref_Mission M
					ON PM.Mission = M.Mission
		WHERE   M.Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule wHERE SystemModule = 'Staffing')
</cfquery>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Entity" 
			  option="Add" 
			  banner="gray"
			  line="no"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#"
			  user="no">		  
			  
<cfset maxCols = 4>
<table width="93%" align="center" cellspacing="0">
	<tr>
		<td height="25" colspan="<cfoutput>#maxCols#</cfoutput>" id="missionSubmit"></td>
	</tr>
	<tr>
	<cfset cnt = 0>
	<cfoutput query="missionList">
		<cfset cnt = cnt + 1>
		
		<cfset selectedStyle = "">
		<cfif mission eq Selected>
			<cfset selectedStyle = "background-color:C5FDC1;">
		</cfif>
		
		<td class="labelit" id="td_#replace(mission,' ','','ALL')#" title="#MissionName#" style="#selectedStyle#">
		  <table>
		  <tr>
		  <td>
			   <input type="Checkbox" 
					name="mission_#replace(mission,' ','','ALL')#" 
					id="mission_#replace(mission,' ','','ALL')#" 
					onclick="selectMission('#replace(mission,' ','','ALL')#','#mission#','C5FDC1');" 
				<cfif mission eq Selected>checked</cfif>>
				</td>
				<td style="padding-left:5px" class="labelmedium">#Mission#</td>
				</tr>
			</table>			
		</td>
		
		<cfif cnt eq maxCols>
			</tr>
			<tr>
			<cfset cnt = 0>
		</cfif>
	</cfoutput>
	</tr>
</table>