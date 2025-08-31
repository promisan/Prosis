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
<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AddressBuilding
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   

<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_AddressBuilding
         (Code,
		 Name,
		 Description,
		 Levels,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES ('#Form.Code#',
          '#Form.Name#', 
		  '#form.Description#',
		  '#form.Levels#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_AddressBuilding
	SET    Name     = '#Form.Name#',
	       Description     = '#Form.Description#',
		   Levels    = '#form.Levels#'
	WHERE  Code  = '#Form.Code#'
</cfquery>


</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT BuildingCode
      FROM   PersonAddressContact
      WHERE  BuildingCode  = '#Form.Code#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Building is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_AddressBuilding
	WHERE Code = '#FORM.Code#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
