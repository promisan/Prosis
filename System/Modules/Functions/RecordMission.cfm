<cfparam name="url.mission" default="">
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ModuleControlRoleMission
			    (SystemFunctionId,
				 Role,
				 Mission,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
			  ('#URL.functionId#',
				'#URL.Role#',
				'#URL.Mission#',
				'#SESSION.acc#',
		   		'#SESSION.last#',
		   		'#SESSION.first#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM Ref_ModuleControlRoleMission
		  WHERE  SystemFunctionId = '#URL.functionId#' 
		  AND    Role = '#URL.Role#'
		  AND	 Mission = '#URL.Mission#'
	</cfquery>
		
</cfif>

<cfquery name="MissionRole" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*, R.MissionName, R.MissionType				 	
		  FROM   Ref_ModuleControlRoleMission M,
		  		 Organization.dbo.Ref_Mission R
		  WHERE  M.Mission = R.Mission
		  AND    M.SystemFunctionId = '#URL.functionId#' 
		  AND    M.Role = '#URL.Role#'
		  AND	 M.Mission is not null
		  ORDER BY R.MissionType, M.Mission
</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
  
   <tr class="labelmedium line">
   		<td width="20"></td>
   		<td width="30">No.</td>
		<td>Mission</td>
		<td>Officer</td>
		<td>Created</td>
		<td></td>
   </tr>			
    			   
   <cfif MissionRole.recordCount eq 0>
   <tr><td style="height:40px" colspan="5" align="center" class="labelmedium"><font color="gray"><b>Enabled for any entities</b></font></td></tr>
   </cfif>
   
   <cfoutput query="MissionRole" group="MissionType">
	  
	  <tr><td colspan="6" class="labelmedium"><b>#MissionType#</b></td></tr>
	  
	  <cfoutput>
		
	   <tr class="line labelmedium navigation_row" bgcolor="FFFFFF">
	   	  <td></td>
	   	  <td height="17" width="30">#currentrow#.</td>
	      <td>[#Mission#] #MissionName#</td>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#dateformat(created,CLIENT.DateFormatShow)#</td>			   
		  <td style="padding-top:5px"><cf_img icon="delete" onclick="javascript:ColdFusion.navigate('#SESSION.root#/System/Modules/Functions/RecordMission.cfm?action=delete&functionId=#URL.functionId#&role=#url.Role#&mission=#URLEncodedFormat(Mission)#','MissionRole')"></td>		  
	   </tr>  
	   
       </cfoutput>
   </cfoutput>
   
   
   <tr><td height="10"></td></tr>
   <tr>
   		<td colspan="6" align="center">		
		<cfoutput>
		<table class="formspacing"><tr><td>
			<input type="Button" value="Clear" class="button10g" onclick="javascript: if (confirm('This action will remove all entities assigned, continue ?')) { ColdFusion.navigate('RecordMissionAssignAll.cfm?ID=#URL.functionId#&ID1=#url.role#&type=Remove','MissionRole') }">			
			</td>
			<td>
   			<input type="Button" value="Close" class="button10g" onclick="ColdFusion.navigate('#SESSION.root#/System/Modules/Functions/Role_Mission.cfm?ID=#URL.functionId#&role=#url.role#', 'divRoleMission_#URL.functionId#_#url.role#'); ColdFusion.Window.hide('mydialog');">						
			</td>
			</tr>
		</table>	
		</cfoutput>
		</td>
	</tr>
   
   </table>
   
   <cfset ajaxonload("doHighlight")>