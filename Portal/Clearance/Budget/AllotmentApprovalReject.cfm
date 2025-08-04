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

<cfset st = "0">

<cf_busy message="Updating....">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cftransaction>

<!--- update amounts by edition --->

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       Ref_AllotmentEdition
WHERE      ControlEdit = '1'	   
AND        Fund = '#URL.Fund#'
</cfquery>

<cfoutput query="Edition">

	<!--- create a header logging action record --->
	
	<cfquery name="Method" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     EntryMethod
	FROM       Ref_AllotmentEdition
	WHERE      EditionId = '#EditionId#'
	</cfquery>
  
	
	<cfquery name="Header" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     AllotmentId
	FROM       ProgramAllotment
	WHERE      ProgramCode = '#program#'	   
	AND        EditionId = '#EditionID#'
	</cfquery>
	
	
	<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramAllotmentAction
				(ActionClass, 
				 ActionReference,
				 ActionType, 
				 Status,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName, 
				 Created)
		VALUES ('#Method.EntryMethod#', 
				'#Header.AllotmentId#', 
				'Rejected',
				'9',
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#', 
				getDate())
     </cfquery>  

      
	   <cfquery name="ApproveHeader" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE     ProgramAllotment
		SET        Status = '9'
		WHERE      ProgramCode = '#URL.Program#'	   
		AND        EditionId = '#EditionID#' 
	   </cfquery>
	  									
	  <cfquery name="ApproveTransaction" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentDetail
		SET Status = '9'
		WHERE      ProgramCode = '#URL.Program#'	   
		AND        EditionId = '#EditionID#'
	  </cfquery>  
	
</cfoutput>

</cftransaction>

<cfoutput>

<cfif URL.caller eq "External">

	<script language="JavaScript">
	
	    window.close();
		<cfif st eq "1">
		    opener.history.go()
		</cfif>
		
	</script>

<cfelse>

	<script language="JavaScript">
		
		window.location = "AllotmentInquiry.cfm?Program=#URL.Program#&Fund=#URL.Fund#&period=#URL.period#"
		
	</script>

</cfif>

</cfoutput>
