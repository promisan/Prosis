<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM UserMission
	  WHERE  OrgUnit = '#url.orgunit#'
	  <!---  disabled to allow selection of several units per account/mission : insight 
	  WHERE Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Organization 
						WHERE  OrgUnit = '#url.orgunit#')
	  --->					
	  AND    Account = '#URL.Account#'	   
	</cfquery>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Organization 
	   WHERE  OrgUnit = '#url.orgunit#'	   
	</cfquery>

	<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO UserMission
		    (Account,
			 Mission,
			 OrgUnit,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES
		  ('#URL.Account#',
			'#Org.Mission#',
			'#Org.OrgUnit#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#') 
	</cfquery>
	
	
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM UserMission
	  WHERE  Account  =  '#url.account#'
	  AND    OrgUnit  = '#URL.OrgUnit#'
	</cfquery>
		
</cfif>

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT U.*
	  FROM UserNames U, UserMission M
	  WHERE orgUnit   = '#URL.OrgUnit#' 
	  AND U.Account = M.Account
	</cfquery>
	
    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">		
		
    <tr class="labelmedium line">
	   <td></td>
       <td height="15"><cf_tl id="Account"></td>
	   <TD height="15"><cf_tl id="Name"></TD>	   	 
	   <td></td>   
   </TR>
   		   
   <cfoutput query="User">
      
   <tr class="navigation_row linedotted labelmedium">
   	  <td style="padding-left:5px" height="20">#currentrow#.</td>
      <td>#Account#</td>
	  <td>#FirstName# #LastName#</td>	 	
	  <td>
	  <cf_img icon="delete" onclick="ptoken.navigate('#SESSION.root#/system/organization/application/OrganizationUserList.cfm?action=delete&OrgUnit=#URL.OrgUnit#&Account=#Account#','user')">		 
	  </td>
   </tr>        
     
   </CFOUTPUT> 
   
   <cfset ajaxOnload("doHighlight")>
      