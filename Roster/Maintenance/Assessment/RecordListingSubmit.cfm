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
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_AssessmentCategory
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#' 
		  WHERE  Code = '#URL.code#'
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_AssessmentCategory
		WHERE  Code = '#Form.Code#'  
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_AssessmentCategory
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
		alert("Sorry, but #Form.Code# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">
