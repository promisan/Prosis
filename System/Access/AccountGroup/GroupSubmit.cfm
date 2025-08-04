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

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
WHERE 
AccountGroup   = '#Form.AccountGroup#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An account group with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   <cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   INSERT INTO Ref_AccountGroup
         (AccountGroup,
		 Description, 
		 Category, 
		 UserInterface,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.AccountGroup#', 
          '#Form.Description#',
		  'Manual',
		  '#Form.UserInterface#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
		  </cfif>
		  
		  
	<script language="JavaScript">
	   
	     opener.history.go()
		 window.close()
	        
	</script>  
          
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_AccountGroup
SET Description    = '#Form.Description#',
    UserInterface      = '#Form.UserInterface#',
	Created = #now()#
WHERE AccountGroup = '#Form.AccountGroup#'
</cfquery>

<script language="JavaScript">
	   
	     opener.history.go()
		 window.close()
	        
	</script>  

</cfif>	


