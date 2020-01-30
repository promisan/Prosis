
<!--- enabled custom fields for a service item --->

<cfquery name="Topic" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT	ASI.*,
		(
			SELECT	entityClassName
			FROM	organization.dbo.Ref_EntityClass
			WHERE	EntityCode = 'Workorder'
			AND		Operational = 1
			AND		EntityClass = ASI.entityClass
		) as entityClassName,
		A.mission,
		A.description as actionDescription
FROM	Ref_ActionServiceItem ASI,
		Ref_Action A
WHERE	ASI.Code = A.Code
AND		ASI.ServiceItem = '#URL.ID1#'
Order by A.mission
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="7"></td></tr>

 <TR height="18">
	   <td width="5%"></td>	  
	   <td width="15%" class="labelit">Code</td>	  
	   <td width="30%" class="labelit">Name</td>
	   <td class="labelit">Workflow</td>
	   <td class="labelit">Officer</td>	  
	   <td width="10%" class="labelit">Created</td>		
	   <td width="40"></td>			  	  
    </TR>	
	
	<tr><td height="1" colspan="7" class="line"></td></tr>
	
	<cfif Topic.recordcount eq "0">
	
	<tr><td colspan="7" height="32" class="labelmedium" style="padding-top:10px" align="center">There are no actions defined</td></tr>
	
	</cfif>

<cfoutput query="Topic" group="mission">

	<TR><td></td><td colspan="6" height="25"><b>#mission#</b></td></TR>
	
	<cfoutput>

	<TR onMouseOver="this.bgColor = 'FFFFCF'" onMouseOut = "this.bgColor = 'FFFFFF'" bgcolor="FFFFFF">			
			  			   
	   <td height="20"></td>	  	      
	   <td>#Code#</td>	  
	   <td>#ActionDescription#</td>
	   <td><cfif EntityClass neq "">#EntityClass# - #EntityClassName#</cfif></td>
	   <td>#OfficerFirstName# #OfficerLastName#</td>	   	     
	   <td>#dateformat(created,CLIENT.DateFormatShow)#</td>
	   <td align="center" width="40"></td>  
	   		   
   </tr>	
   
   <tr><td colspan="7" class="line"></td></tr>
   
   </cfoutput>
   
</cfoutput>   

</table>
