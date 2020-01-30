
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM   Ref_PersonGroupOwner
			 WHERE  GroupCode = '#URL.Code#'
			 AND    Owner = '#URL.id2#'
	</cfquery>
	
<cfelseif url.action eq "Insert">	

    <cftry>
	<cfquery name="Insert" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_PersonGroupOwner
			 (GroupCode,Owner,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#URL.Code#','#URL.owner#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfquery name="List" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   V.*
    FROM     Ref_PersonGroupOwner R, Organization.dbo.Ref_AuthorizationRoleOwner V
	WHERE    R.Owner = V.Code
	AND      GroupCode = '#URL.Code#'		
</cfquery>

<cfparam name="URL.ID2" default="new">
	
<table width="100%" cellspacing="0" cellpadding="0">		
				
	    <TR height="18" class="labelmedium line">
		   <td width="120"><cf_space spaces="50">Owner</b></td>
		   <td width="90%">Name</b></td>			
		   <td colspan="2" align="right">
		   
		   <cfset link = "Owner.cfm?code=#url.code#">
		   						 
			   <cf_selectlookup
			    box          = "#code#_owner"
				link         = "#link#"				
				button       = "No"
				close        = "No"	
				title        = "Add&nbsp;Owner"											
				class        = "owner"
				des1         = "Owner">			    
			
		   </td>		  
	    </TR>
						
		<cfoutput query="List">
					
			<cfset nm = Code>
			<cfset de = Description>
						
			<TR bgcolor="fcfcfc" class="labelmedium line">
			   <td height="15" width="100">#nm#</td>
			   <td width="80%">#de#</td>				 
			   <td align="center" width="25"></td>			  
			   <td align="center" width="25">
				    <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('Owner.cfm?action=delete&Code=#URL.Code#&ID2=#nm#','#url.code#_owner')">										  
			    </td>
					
			</TR>	
											
		</cfoutput>
							
</table>		
						

