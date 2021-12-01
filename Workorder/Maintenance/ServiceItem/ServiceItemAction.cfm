
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

<table width="100%" align="center">

<tr><td height="7"></td></tr>

 <TR height="18" class="line labelmedium2 fixlengthlist">
	   <td></td>	  
	   <td><cf_tl id="Code"></td>	  
	   <td><cf_tl id="Name"></td>
	   <td><cf_tl id="Workflow"></td>
	   <td><cf_tl id="Officer"></td>	  
	   <td><cf_tl id="Created"></td>		
	   <td></td>			  	  
    </TR>	
		
	<cfif Topic.recordcount eq "0">
	
	<tr><td colspan="7" height="32" class="labelmedium2" style="padding-top:10px" align="center">There are no actions defined</td></tr>
	
	</cfif>
	
	<cfoutput query="Topic" group="mission">
	
		<TR><td></td><td colspan="6" height="25"><b>#mission#</b></td></TR>
		
		<cfoutput>
	
		<TR onMouseOver="this.bgColor = 'FFFFCF'" onMouseOut = "this.bgColor = 'FFFFFF'" bgcolor="FFFFFF" class="line">			
				  			   
		   <td height="20"></td>	  	      
		   <td>#Code#</td>	  
		   <td>#ActionDescription#</td>
		   <td><cfif EntityClass neq "">#EntityClass# - #EntityClassName#</cfif></td>
		   <td>#OfficerFirstName# #OfficerLastName#</td>	   	     
		   <td>#dateformat(created,CLIENT.DateFormatShow)#</td>
		   <td align="center" width="40"></td>  
		   		   
	   </tr>	
	      
	   </cfoutput>
	   
	</cfoutput>   

</table>
