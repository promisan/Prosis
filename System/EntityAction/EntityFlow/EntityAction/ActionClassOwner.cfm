
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM   Ref_EntityClassOwner
			 WHERE  EntityCode       = '#URL.EntityCode#'
			 AND    EntityClass      = '#URL.EntityClass#'
			 AND    EntityClassOwner = '#URL.owner#'
	</cfquery>
	
<cfelseif url.action eq "Insert">	

    <cftry>
	<cfquery name="Insert" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_EntityClassOwner
			 (EntityCode,EntityClass,EntityClassOwner,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#URL.EntityCode#','#URL.EntityClass#','#URL.owner#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfquery name="List" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  V.*, R.OfficerUserId as Officer
    FROM    Ref_EntityClassOwner R, Ref_AuthorizationRoleOwner V
	WHERE   R.EntityClassOwner = V.Code
	AND     EntityCode       = '#URL.EntityCode#'
	 AND    EntityClass      = '#URL.EntityClass#'
</cfquery>
	
<table width="100%">
						
		<cfif List.recordcount eq "0">
			<tr style="height:20px;" class="labelmedium"><td colspan="5" style="padding-left:6px"><font color="gray">Available to all owners</font></td></tr>
		<cfelse>			
								
			<TR bgcolor="ffffcf"><td>
			
			  <table>
				   <tr class="labelit fixlengthlist">			  
				   <cfoutput query="List">
				   
				    <cfset nm = Code>
					<cfset de = Description>
			
				   <td style="padding-left:6px">#nm#</td>
				    
				   <td style="padding-left:3px;padding-right:3px">
				   
					   <cfset vCode = URLEncodedFormat(code)>
				       <A href="javascript:_cf_loadingtexthtml='';ptoken.navigate('ActionClassOwner.cfm?action=delete&entitycode=#url.entitycode#&entityclass=#url.entityclass#&owner=#vCode#','#url.entityclass#_owner')">
						   <img src="#SESSION.root#/Images/delete5.gif" height="9" width="9" title="Delete #nm#" border="0" align="absmiddle">
					   </a>
					   <cfif currentrow neq recordcount>,</cfif>
											  
				    </td>
					
					</cfoutput>
				  </tr>
			   
			  </table>
			  
			  </td> 	
					
			</TR>	
		
		</cfif>						
							
</table>	