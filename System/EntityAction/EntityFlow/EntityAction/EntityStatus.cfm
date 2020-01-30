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
		 <!---
		 <img src="#SESSION.root#/Images/edit.gif" alt="" name="img_#url.entityCode#" 
				  onMouseOver="document.img_#url.entityCode#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img_#url.entityCode#.src='#SESSION.root#/Images/edit.gif'"
				  style="cursor: pointer;" height="12" width="12" alt="" border="0" align="absmiddle" 
				  onClick="entityedit('#url.entityCode#','#url.mission#')">
				  --->
			  
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
