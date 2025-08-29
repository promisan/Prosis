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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Resource
	WHERE 
	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   				
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Resource
         (Code,
		  Name,
		  Description,
		  ListingOrder,
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,	
		  Created)
		 VALUES ('#Form.Code#',
		  '#Form.Name#',
          '#Form.Description#', 
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
		  <cf_LanguageInput
			TableCode       = "Ref_Resource" 
			Mode            = "Save"
			Key1Value       = "#Form.Code#"
			Name1           = "Description">
		  
    </cfif>		
	    	          
</cfif>

<cfif ParameterExists(Form.Update)>

				
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_Resource
		SET   Name             = '#form.Name#',
			  Description      = '#Form.Description#',
			  ListingOrder     = '#Form.ListingOrder#',
			  ExecutionDetail  = '#Form.ExecutionDetail#'
		WHERE Code         = '#Form.CodeOld#'
		</cfquery>
		
		  <cf_LanguageInput
			TableCode       = "Ref_Resource" 
			Mode            = "Save"
			Key1Value       = "#Form.CodeOld#"
			Name1           = "Description">
        
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Resource
      FROM Ref_Object
      WHERE Resource  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Code is in use for one or more Object Code. Operation aborted.")
		        
	     </script>  
	 
    <cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Resource
			WHERE code = '#FORM.codeOld#'
	    </cfquery>
		
	</cfif>	
    		
</cfif>	

<!--- language provision --->



<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
