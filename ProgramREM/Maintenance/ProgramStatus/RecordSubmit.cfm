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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ProgramStatus
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<cfquery name="Insert" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_ProgramStatus
         (code,
		 StatusClass,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
          '#StatusClass#',
          '#Form.Description#', 
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Code" 
ActionType="Update" 
ActionReference="#Form.Code#" 
ActionScript="">   

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ProgramStatus
SET 
    Code           = '#Form.code#',
	StatusClass    = '#Form.StatusClass#',
    Description    = '#Form.Description#'
WHERE code         = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ProgramStatus
      FROM Program
      WHERE ProgramStatus  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Code is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="code" 
ActionType="Remove" 
ActionReference="#Form.codeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_ProgramStatus
WHERE code = '#FORM.codeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
