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

<cf_compression>

<cfparam name="Form.Code"               default="">
<cfparam name="Form.Description"        default="">

<cfif URL.Code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_ClaimTypeClass
		  SET    Description         = '#FORM.Description#',
		 		 EntityClass		 = '#Form.EntityClass#'
		  WHERE  Code                = '#URL.Code#'		 	   
		  AND    ClaimType          = '#URL.ClaimType#' 
	</cfquery>
		
	<cfset url.code = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsCaseFile" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		  FROM  Ref_ClaimTypeClass
		  WHERE  Code                = '#FORM.Code#'		 	   
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsCaseFile" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_ClaimTypeClass
			         (ClaimType,
					 Code,
					 Description,
					 EntityClass,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES (
				      '#URL.ClaimType#',
				      '#Form.Code#',
					  '#Form.Description#',			
					  '#Form.EntityClass#',		 
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#'
					  )
			</cfquery>
			
	<cfelse>
			
		<cfoutput>	
		<script>
			alert("Sorry, but #Form.Code# already exists")
		</script>
		</cfoutput>
				
	</cfif>		
	
	<cfset url.code = "new">
			   	
</cfif>

<cfoutput>
  <script>
    ptoken.navigate('RecordListingDelete.cfm?Code=#URL.ClaimType#','del_#url.claimtype#')	
    ptoken.navigate('List.cfm?ClaimType=#URL.ClaimType#&code=#url.code#','#url.claimtype#_list')	
  </script>	
</cfoutput>

