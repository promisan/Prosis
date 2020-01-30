<cfoutput>

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	
		<tr><td height="5"></td></tr>		
	 	
		<cfset link = "#SESSION.root#/programRem/application/program/ActivityPerson/EmployeeListing.cfm?activityid=#url.activityid#">
				
		<tr><td height="40" colspan="6" align="left" style="padding-left:14px" class="labellarge">
		
		<table cellspacing="0" cellpadding="0">
		<tr>
		
		<td style="width:40px"> <cf_tl id="Add Employee" var="1">
			
		   <cf_selectlookup
		    class    = "Employee"
		    box      = "member"
			button   = "yes"
			icon     = "add1.png"
			iconwidth = "25"
			iconheight = "25"
			title    = "#lt_text#"
			link     = "#link#"			
			dbtable  = "Program.dbo.ProgramActivityPerson"
			des1     = "PersonNo"></td>
		
		<td class="labellarge"><cf_tl id="Assigned Personnel"></td></tr>
		<tr><td></td><td colspan="1" class="labelit" style="padding-left:3px"><font color="808080">This will allow these below personnel to access and update the timesheet </td></tr>
		</table>
		  
					
		</td>
		</tr> 			
		
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2">
		
			<cfdiv bind="url:#link#" id="member"/>
		
		</td>
		</tr>  
		
		<tr><td colspan="6" class="linedotted"></td></tr> 		
	
    </table>
      
</cfoutput>