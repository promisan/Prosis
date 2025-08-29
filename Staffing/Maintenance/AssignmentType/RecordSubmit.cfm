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


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AssignmentType
WHERE 
AssignmentType  = '#Form.AssignmentType#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Assignment type" 
ActionType="Enter" 
ActionReference="#Form.AssignmentType#" 
ActionScript="">   

<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_AssignmentType
         (AssignmentType,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.AssignmentType#',
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
ActionClass="AssignmentType" 
ActionType="Update" 
ActionReference="#Form.AssignmentType#" 
ActionScript="">   

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_AssignmentType
SET 
    AssignmentType   = '#Form.AssignmentType#',
    Description = '#Form.Description#'
WHERE AssignmentType  = '#Form.AssignmentTypeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AssignmentType
      FROM PersonAssignment
      WHERE AssignmentType  = '#Form.AssignmentTypeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Assignment type is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="AssignmentType" 
ActionType="Remove" 
ActionReference="#Form.AssignmentTypeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_AssignmentType
WHERE AssignmentType = '#FORM.AssignmentTypeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
