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
<cfparam name="url.action" default="">
<cfparam name="url.role"   default="">
<cfparam name="url.mode"   default="edit">

<cfif url.action eq "Insert">

	<cfloop index="itm" list="#url.list#" delimiters=":">
	
		<cfquery name="Member" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   RequisitionLineAuthorization
		  WHERE  RequisitionNo = '#url.RequisitionNo#'
		  AND    UserAccount   = '#URL.Account#'
		  AND    Role          = '#itm#' 
		</cfquery>
							
		<cfif Member.recordcount eq "0">		
		
			<cfquery name="Employee" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineAuthorization
				    (RequisitionNo,
					 UserAccount,
					 Role,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			VALUES(	'#url.RequisitionNo#',
					'#URL.Account#',
					'#itm#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 					
			</cfquery>
			
		</cfif>
		
		<cfoutput>
		
		<script>
			_cf_loadingtexthtml='';		
			ColdFusion.navigate('../Authorization/AuthorizationList.cfm?mode=#url.mode#&requisitionNo=#url.RequisitionNo#&role=#itm#','#itm#')		
		</script>
		
		</cfoutput>
			
	</cfloop>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM RequisitionLineAuthorization
	  WHERE  RequisitionNo =  '#url.RequisitionNo#'
	  AND    UserAccount   = '#URL.Account#'
	  AND    Role = '#URL.Role#' 
	</cfquery>
	
	<cfinclude template="AuthorizationList.cfm">
	
<cfelse>

	<cfinclude template="AuthorizationList.cfm">	
	
</cfif>