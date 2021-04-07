
<cfparam name="grp" default="">

<cfset filter = "">
<cfloop index="itm" list="#grp#">
  <cfif filter eq "">
    <cfset filter = "'#itm#'">
  <cfelse>
     <cfset filter = "#filter#,'#itm#'">	
  </cfif>
</cfloop>

<cfquery name="GroupNew" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT AccountMission, 
	       U.AccountOwner, 
		   U.AccountGroup, 
		   U.Account, 
		   U.LastName, 
		   eMailAddress, 
		   Remarks, 
		   U.OfficerLastName, 
		   U.OfficerFirstName, 
		   U.Created
	FROM  UserNames U
	WHERE U.AccountType = 'Group'
	<cfif grp neq "">
	AND   U.Account NOT IN (#preserveSingleQuotes(filter)#) 
	</cfif>
	AND   U.AccountOwner is not NULL
	<cfif SESSION.isAdministrator eq "No">  
	AND (
			 U.AccountOwner IN (SELECT ClassParameter 
		                       FROM Organization.dbo.OrganizationAuthorization
	                    	   WHERE Role = 'AdminUser' 
							   AND AccessLevel IN ('1','2')
							   AND UserAccount = '#SESSION.acc#'
							   )
		     OR 	
			 				   
		     U.AccountMission IN (SELECT Mission 
			             FROM   Organization.dbo.OrganizationAuthorization 
						 WHERE  UserAccount = '#SESSION.acc#'
						 AND    Role = 'OrgUnitManager') 
		   
		   )
	</cfif>					   
	ORDER BY AccountOwner,AccountMission, LastName					   
</cfquery>

<cfif GroupNew.recordcount gt "0">


	<table height="100" width="100%" align="center">		   
				
		<!---
		
		<tr>
		  <td height="20" width="40"></td>
		  <td class="labelit" width="40%">Group Name</td>
		  <td class="labelit" width="10%">Account</td>
		  <td class="labelit" width="10%">Mission</td>
		  <td class="labelit" width="20%">Officer</td>
		  <td class="labelit" width="10%">Date</td>
		  <td class="labelit" width="5%">Select</td>
		</tr>
		
		--->
					
		<cfoutput query="groupNew" group="AccountOwner">
		
			<tr class="fixrow labelmedium2"><td colspan="7" style="font-size:18px;height:25px;padding-left:3px">#AccountOwner#</td></tr>
		
			<cfoutput group="AccountMission">
			
				<tr class="line labelmedium fixrow2">
				
					<td>
														 
					<img src="#SESSION.root#/Images/icon_close.gif"
					     border="0"
						 id="#currentrow#_exp"
						 align="absmiddle"
					     class="regular"
					     style="cursor:pointer"
					     onClick="javascript:document.getElementById('#currentrow#_exp').className='hide';ptoken.navigate('#SESSION.root#/system/access/membership/MemberSelectDetail.cfm?owner=#accountowner#&mission=#AccountMission#&grp=#grp#','#AccountOwner#_#AccountMission#')">
						
					</td>
					<td height="24" colspan="6" style="padding-left:3px;font-size:20px;width:100%;height:21">
							
						<a href="javascript:document.getElementById('#currentrow#_exp').className='hide';ptoken.navigate('#SESSION.root#/system/access/membership/MemberSelectDetail.cfm?owner=#accountowner#&mission=#AccountMission#&grp=#grp#','#AccountOwner#_#AccountMission#')">
						<cfif AccountMission eq "">&nbsp;<cf_tl id="Global"><cfelse>&nbsp;#AccountMission#</cfif>
						</a>
						
					</td>
					
				</tr>		
				
				<tr>
					<td></td>
					<td colspan="6" id="#AccountOwner#_#AccountMission#"></td>
				</tr>
			
			</cfoutput>
	
		</cfoutput> 
		
	</table>

</cfif>