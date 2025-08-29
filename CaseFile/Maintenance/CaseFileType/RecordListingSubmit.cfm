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
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Description"        default="">

<cfif URL.code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_ClaimType
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#' 
		  WHERE  Code = '#URL.code#'
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsCaseFile" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_ClaimType
		WHERE   Code = '#Form.Code#'  
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsCaseFile" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_ClaimType
			         (Code,
				     Description,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.Code#',
					  '#Form.Description#',
			      	  '#Form.Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		<cf_tl id = "Sorry, but" var = "1">
		<cfset vSorry = lt_text>

		<cf_tl id = "already exists" var = "1">
		<cf_tl vAlready = "already exists" var = "1">
		
		alert("#vSorry# #Form.Code# #vAlready#")
		</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">
