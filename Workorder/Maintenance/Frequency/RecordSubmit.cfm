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
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Frequency
	WHERE  Code  = '#Form.code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
	 history.back()
     
   </script>  
  
   <cfelse>
	   
	<cfquery name="Insert" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Frequency
	    	     (Code,Description)
		VALUES ('#Form.Code#','#Form.Description#')
	</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfparam name="Form.Code" default="#Form.CodeOld#">

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Frequency
	SET    Code        = '#Form.Code#', 
		   Description = '#Form.Description#'    
	WHERE  Code        = '#Form.CodeOld#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Frequency
		WHERE Code = '#FORM.Code#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
