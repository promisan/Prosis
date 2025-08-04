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

<cfquery name="Role"
	datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"> 
   SELECT * 
   FROM Ref_AuthorizationRole 
   WHERE Role = '#URL.ID4#'
</cfquery>

<!--- if user a also Global all mission access, clean the entries that are mission specific and that were manually entered --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT UserAccount
	FROM  OrganizationAuthorization A   
	WHERE A.Role  		= '#URL.ID4#'
	AND   A.UserAccount = '#URL.ID5#'
	AND   A.Source      = '#URL.source#'
	AND   A.AccessLevel < '8'
	AND   A.OrgUnit is NULL
	AND   A.Mission is NULL
</cfquery>

<cfif check.recordcount gte "1" and url.source neq "Manual">

	<cfquery name="Clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM OrganizationAuthorization 
		WHERE Role  	  = '#URL.ID4#'
		AND   UserAccount     = '#URL.ID5#'		
		AND   Mission is not NULL
		AND   Source = 'Manual'
	</cfquery>

</cfif>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT UserAccount, Mission, 'regular' as Type
	FROM  OrganizationAuthorization A   
	WHERE A.Role  		    = '#URL.ID4#'
	AND   A.UserAccount     = '#URL.ID5#'
	AND   A.AccessLevel < '8'
	AND   A.Source      = '#URL.source#'
	AND   A.OrgUnit is NULL
	AND   A.Mission is NOT NULL
	<cfif Role.MissionAsParameter eq "0">
	AND   A.Mission IN (SELECT R.Mission  
						FROM   Ref_MissionModule R
						WHERE  R.SystemModule = '#Role.SystemModule#')
	</cfif>
	UNION	
	SELECT DISTINCT UserAccount, Mission, 'denied' as Type
	FROM  OrganizationAuthorizationDeny A   
	WHERE A.Role  		    = '#URL.ID4#'
	AND   A.UserAccount     = '#URL.ID5#'
	AND   A.AccessLevel < '8'
	AND   A.Source      = '#URL.source#'
	AND   A.OrgUnit is NULL
	AND   A.Mission is NOT NULL
	<cfif Role.MissionAsParameter eq "0">
	AND   A.Mission IN (SELECT R.Mission  
						FROM   Ref_MissionModule R
						WHERE  R.SystemModule = '#Role.SystemModule#')
	</cfif>			
				
</cfquery>

		  
 <cfif Mission.recordcount neq "0">
		 	   
	   <table cellspacing="0" cellpadding="0">
	   <tr><td width="30" align="left">
	        <cfoutput>
	        <img src="#SESSION.root#/Images/join.gif" 
			alt="" border="0" 
			align="absmiddle">
			</cfoutput>
			</td>
	    
		<td>
				
		<cfoutput query="Mission">
		 <cfif type eq "Denied"><font color="FF0000">#Mission#</font><cfelse>#Mission#</cfif><cfif currentRow neq "#Mission.RecordCount#">, </cfif>
		</cfoutput> 
		</td>
		</table> 	

<cfelse>

   &nbsp;Access is NOT limited to one or more trees.		 
		
</cfif>


