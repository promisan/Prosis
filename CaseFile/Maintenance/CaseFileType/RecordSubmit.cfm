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


<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ClaimType
WHERE Code  = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
	
    <cfoutput>
	   <cf_tl id = "A record with this code has been registered already!" var = "1" class="Message">
	   <script language="JavaScript">
	     alert("#lt_text#")
	   </script> 
    </cfoutput> 
  
   <CFELSE>
     
<cfquery name="Insert" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_ClaimType
         (Code,
		 Description, 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#', 
          '#Form.Description#',
	  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  '#SESSION.first#',
	  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ClaimType
SET Description  = '#Form.Description#',
Code='#Form.Code#'
WHERE Code = '#Form.CodeOld#'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     Claim
     WHERE    ClaimType = '#Form.Code#' 
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >
	 <cfoutput>
	 
	 <cf_tl id = "Claim Type is in use. Operation aborted." var = "1"> 		 
	     <script language="JavaScript">
		   alert(" #lt_text#")
	     </script>  
	 </cfoutput>	 
		 
    <cfelse>
	
		
	<cfquery name="Delete" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ClaimType
	WHERE Code   = '#Form.code#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  