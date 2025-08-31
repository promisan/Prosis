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
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ObjectUsage
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ObjectUsage
		         (code,
				 Description,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		window.close()        
		</script>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ObjectUsage
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# gt 0 and Form.Code neq Form.CodeOld>
   
	   <script language="JavaScript">	   
			alert("A record with this code has been registered already!")	     
	   </script>  
  
   <cfelse>

		<cfquery name="Update" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_ObjectUsage
		SET 
		    Code           = '#Form.code#',
		    Description    = '#Form.Description#'
		WHERE Code         = '#Form.CodeOld#'
		</cfquery>
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		window.close()        
		</script>
		
	</cfif>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      		SELECT TOP 1 ObjectUsage
      		FROM 	Ref_Object
      		WHERE 	ObjectUsage  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     	<script language="JavaScript">    
			alert("Object Usage is in use. Operation aborted.")	        
	    </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ObjectUsage
			WHERE 	Code = '#FORM.codeOld#'
	    </cfquery>
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		window.close()        
		</script>
	
	</cfif>	
	
</cfif>	  
