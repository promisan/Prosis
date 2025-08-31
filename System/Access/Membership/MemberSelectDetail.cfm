<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	AND   U.Disabled = 0 <!--- added --->
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

<table width="98.5%" class="navigation_table">

<cfoutput query="select">
	
	<tr class="labelmedium2 line navigation_row fixlengthlist" id="#AccountOwner#_#AccountMission#_#currentrow#">
  	   <td style="width:30px;" align="center"><input type="checkbox" style="height:14px;width:14px" name="Member" id="Member" value="#Account#" onClick="mhl(this,this.checked,'#AccountOwner#_#AccountMission#_#currentrow#')"></td>
	   <!---
	   <td style="padding-top:2px" align="center"><cf_img icon="select" onClick="javascript:ShowUser('#Account#')"></td>
	   --->
	   <td style="padding-left:10px">
	      #AccountMission# <a href="javascript:ShowUser('#Account#')">#LastName#</a> (#Account#) 
	   </td>	   	    	   
	   <td align="right">#OfficerLastName# #dateformat(Created, CLIENT.DateFormatShow)#</td>
	  
	</tr>
	
	<cfif Remarks neq "">
	<tr class="navigation_row_child"><td></td><td colspan="6" style="padding-left:15px" class="labelit">#Remarks#</td></tr>
	</cfif>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>