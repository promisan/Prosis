 <cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityMission
		WHERE  EntityCode = '#url.EntityCode#'
		AND    Mission    = '#url.Mission#'
</cfquery>

<cfoutput>

<table cellspacing="0" cellpadding="0">
	<tr>
    	<td style="padding-top:2px">	
		 <cf_img icon="edit" onClick="entityedit('#url.entityCode#','#url.mission#')">		 			  
		</td>
		<td>&nbsp;</td>
		<td height="21" class="labelmedium">			 
		 <a href="javascript:entityedit('#url.entityCode#','#url.mission#')">
		 <cfif check.WorkflowEnabled eq "1"><font color="008000">Enabled<cfelse><font color="gray">Disabled</cfif>
		 </a>
		</td>
				
	</tr>
</table>
</cfoutput>		  
