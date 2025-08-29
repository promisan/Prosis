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
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Designation
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     window.close()
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="appsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Designation
		         (code,
				 Description,
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		          '#Form.Description#',
				  #Form.ListingOrder#,
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<script language="JavaScript">
   
		     window.close()
			 opener.location.reload()
        
		</script> 
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	<cfquery name="CountRec" 
      datasource="appsPayroll" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT 		Designation
      	FROM 		Ref_PayrollLocationDesignation
      	WHERE 		Designation  = '#Form.codeOld#' 
    </cfquery>

	<cfquery name="Update" 
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Designation
	SET 
	    	<cfif #CountRec.recordCount# eq 0>Code = '#Form.code#',</cfif>
	    	Description    = '#Form.Description#',
			ListingOrder   = #Form.ListingOrder#
	WHERE 	Code           = '#Form.CodeOld#'
	</cfquery>
	
	<script language="JavaScript">
   
    	 window.close()
		 opener.location.reload()
        
	</script> 

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsPayroll" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT 		Designation
      	FROM 		Ref_PayrollLocationDesignation
      	WHERE 		Designation  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Designation is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Designation
			WHERE Code = '#FORM.codeOld#'
	    </cfquery>
		
		<script language="JavaScript">
   
	     	window.close()
		 	opener.location.reload()
        
		</script> 
	
	</cfif>
	
	
</cfif>	 
