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
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_ClaimPurpose
WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<cfquery name="Insert" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_ClaimPurpose
         (Code,
		 Description,
		 ListingOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
          '#Form.Description#', 
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ClaimPurpose
SET 
    Code           = '#Form.Code#',
    Description    = '#Form.Description#',
	ListingOrder   = '#Form.ListingOrder#'
WHERE Code    = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsTravelClaim" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT ActionPurpose
      FROM ClaimRequest
      WHERE ActionPurpose  = '#Form.CodeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Code is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
    datasource="AppsTravelClaim" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM Ref_ClaimPurpose
    WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
