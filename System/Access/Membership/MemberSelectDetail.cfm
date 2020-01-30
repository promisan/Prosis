
<cfparam name="url.grp" default="">
<cfparam name="url.find" default="">

<cfset filter = "">
<cfloop index="itm" list="#grp#">
  <cfif filter eq "">
    <cfset filter = "'#itm#'">
  <cfelse>
     <cfset filter = "#filter#,'#itm#'">	
  </cfif>
</cfloop>

<cfquery name="select" 
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
	
	<cfif find neq "">
	
		AND   (U.Account LIKE ('%#find#%') OR U.LastName LIKE ('%#find#%'))
		
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
	
	<cfelse>
		AND   U.AccountOwner   = '#URL.Owner#'
		AND   U.AccountMission = '#URL.Mission#'
	</cfif>
	
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

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding navigation_table">

	<tr>
	  <td height="0" width="1%"></td>
	  <td width="50%"></td>	  
	  <td width="10%"></td>
	  <td width="20%"></td>
	  <td width="10%"></td>
	  <td width="5%"></td>
	</tr>

<cfoutput query="select">
	
	<tr class="labelmedium" style="height:20px" class="linedotted navigation_row" id="#AccountOwner#_#AccountMission#_#currentrow#">
  	   <td style="padding-left:4px" align="center"><input type="checkbox" style="height:14px;width:14px" name="Member" id="Member" value="#Account#" onClick="mhl(this,this.checked,'#AccountOwner#_#AccountMission#_#currentrow#')"></td>
	   <!---
	   <td style="padding-top:2px" align="center"><cf_img icon="select" onClick="javascript:ShowUser('#Account#')"></td>
	   --->
	   <td style="padding-left:10px">
	       <a href="javascript:ShowUser('#Account#')"><font color="6688aa">#LastName#</a> (#Account#)
	   </td>	   
	   <td>#AccountMission#</td>	  
	   <td>#OfficerLastName#</td>
	   <td>#dateformat(Created, CLIENT.DateFormatShow)#</td>
	   <td></td>
	</tr>
	
	<cfif Remarks neq "">
	<tr class="navigation_row_child"><td></td><td colspan="6" style="padding-left:15px" class="labelit">#Remarks#</td></tr>
	</cfif>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>