
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM   Ref_PersonGroupRole
			 WHERE  GroupCode = '#URL.Code#'
			 AND    Role = '#URL.id2#'
	</cfquery>
	
<cfelseif url.action eq "Insert">	

    <cftry>
	<cfquery name="Insert" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_PersonGroupRole
			 (GroupCode,Role,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#URL.Code#','#URL.role#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfquery name="List" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   V.*
    FROM     Ref_PersonGroupRole R, Organization.dbo.Ref_AuthorizationRole V
	WHERE    R.Role = V.Role
	AND      GroupCode = '#URL.Code#'		
</cfquery>

<cfparam name="URL.ID2" default="new">
	
<table width="100%">
						
	    <TR height="18" class="line labelmedium2">
		   <td width="120"><cf_space spaces="50">Role</td>
		   <td width="90%">Description</td>			
		   <td colspan="2" align="right">
		   
		   <cfset link = "Role.cfm?code=#url.code#">
		   						 
			   <cf_selectlookup
			    box          = "#code#_role"
				link         = "#link#"
				button       = "No"
				close        = "No"	
				title        = "Add&nbsp;Role"	
				filter1      = "SystemFunction"
				filter1value = "Staffing"										
				class        = "role"
				des1         = "Role">			    
			
		   </td>		  
	    </TR>
				
		<cfoutput query="List">
					
			<cfset nm = Role>
			<cfset de = Description>
						
			<TR class="line labelmedium2">
			   <td height="15" width="100">#nm#</td>
			   <td width="80%">#de#</td>				 
			   <td align="center" width="25"></td>			  
			   <td align="center" width="25" style="padding-top:4px">

				   <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('Role.cfm?action=delete&Code=#URL.Code#&ID2=#nm#','#url.code#_role');">
										  
			    </td>
					
			</TR>												
								
		</cfoutput>
		
		<tr><td colspan="4" style="height:20px;"></td></tr>
							
</table>		
						

