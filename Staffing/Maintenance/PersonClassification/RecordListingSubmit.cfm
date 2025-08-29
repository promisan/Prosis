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

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_PersonGroup
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 <cfif form.actionCode eq "">
				 ActionCode          = NULL,
				 <cfelse>
				 ActionCode          = '#Form.ActionCode#',
				 </cfif>
				 Context             = '#Form.Context#' 
		  WHERE  Code = '#URL.ID2#'
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_PersonGroup
		WHERE  Code = '#Form.Code#'  
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
		<cfquery name="Insert" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO Ref_PersonGroup
		         (Code,
			     Description,
				 Context,
				 ActionCode,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		      VALUES ('#Form.Code#',
				  '#Form.Description#',
				  '#Form.Context#',
				  <cfif form.actionCode eq "">
					  NULL,
				  <cfelse>
					  '#Form.ActionCode#',
				  </cfif>
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

<cfset url.id2 = "">
<cfinclude template="RecordListingDetail.cfm">
