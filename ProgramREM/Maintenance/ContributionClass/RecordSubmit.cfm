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
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ContributionClass
		WHERE  Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!");
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_ContributionClass
			       	(
						Code,
					   	Description,
						Mission,
						Execution,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
			  VALUES  
			  		(	'#Form.Code#',
			           	'#Form.Description#', 
						'#Form.Mission#',
						'#Form.Execution#',
					   	'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		 
    </cfif>		  
           
<cfelse>
	
	<cfquery name="Update" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_ContributionClass
			SET   	Description = '#Form.Description#',
					Mission     = '#Form.Mission#',
					Execution   = '#Form.Execution#'
			WHERE 	Code        = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">		 

</cfif>	

<script>
	window.close();
	opener.location.reload();
</script>
