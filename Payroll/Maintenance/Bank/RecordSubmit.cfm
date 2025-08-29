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
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_Bank
WHERE  Code   = '#Form.Code#'  
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record for this account has been registered already!")
     
   </script>  
  
   <cfelse>
   
        <cf_assignId>
   
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Bank
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

<cfparam name="form.operational" default="0">

<cfquery name="Update" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_Bank
	SET Description       = '#Form.Description#', Operational = '#form.Operational#'
	WHERE Code       = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
			
	<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Bank
		WHERE Code = '#Form.CodeOld#'
	</cfquery>
	
</cfif>
	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
