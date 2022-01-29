
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM   Ref_EntityClassMission
			 WHERE  EntityCode       = '#URL.EntityCode#'
			 AND    EntityClass      = '#URL.EntityClass#'
			 AND    Mission 		 = '#URL.mission#'
	</cfquery>
	
<cfelseif url.action eq "Insert">	

    <cftry>
	<cfquery name="Insert" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_EntityClassMission
			 (EntityCode,EntityClass,Mission,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#URL.EntityCode#','#URL.EntityClass#','#URL.mission#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfquery name="List" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  M.*,
			R.MissionName
    FROM    Ref_EntityClassMission M
			INNER JOIN Ref_Mission R
				ON M.Mission = R.Mission
	WHERE   M.EntityCode       = '#URL.EntityCode#'
	AND     M.EntityClass      = '#URL.EntityClass#'
</cfquery>

<cfset row = 0>
	
<table width="100%">
						
		<cfif List.recordcount eq "0">
			
			<tr style="height:20px;" class="labelmedium"><td style="padding-left:6px"><font color="gray">Available to all entities</font></td></tr>
		
		<cfelse>		
						
			<tr bgcolor="f1f1f1">
			<td>
			   <table>
				   <tr class="labelit fixlengthlist">			  
				   <cfoutput query="List">
				   
				    <cfset row = row+1>
				   
				    <cfset mis = Mission>
					<cfset nme = MissionName>
			     	  
				   <td style="padding-left:6px">

				   	   <cfset vMission = URLEncodedFormat(mission)>
				          <img src="#SESSION.root#/Images/delete5.gif" 
						   onclick="_cf_loadingtexthtml='';	ptoken.navigate('ActionClassMission.cfm?action=delete&entitycode=#url.entitycode#&entityclass=#url.entityclass#&mission=#vMission#','#url.entityclass#_entity')"
						   height="9" width="9" title="Delete #mis#" border="0" align="absmiddle">
					  
											  
				    </td>
					<td class="fixlength" style="padding-left:2px">#mis#</td>	
					<cfif row eq "5">
					</tr><tr class="labelit fixlengthlist">	
					<cfset row = 0>
					</cfif>
					</cfoutput>						
					</tr>
				</table>	
			</TR>	
														
		</cfif>
							
</table>				

