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
FROM  Ref_ClaimEvent
WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An event with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
	<cfquery name="Insert" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ClaimEvent
	         (Code,
			 Description,
			 Image,
			 Reference,
			 PointerReference,
			 PointerTerminal,
			 PointerExpress,
			 PointerDefault,
			 PointerTransport,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#',
	          '#Form.Description#', 
			  '#Form.Image#',
			  '#Form.Reference#',
			  '#Form.PointerReference#',
			  '#Form.PointerTerminal#',
			  '#Form.PointerExpress#',
			  '#Form.PointerDefault#',
			  '#Form.PointerTransport#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery>
		  
    </cfif>		  
           
</cfif>



<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ClaimEvent
	SET Code           = '#Form.Code#',
	    Description    = '#Form.Description#',
		Image          = '#Form.Image#',  
		Reference      = '#Form.Reference#', 
		PointerReference = '#Form.PointerReference#', 
		PointerTerminal  = '#Form.PointerTerminal#', 
		PointerExpress   = '#Form.PointerExpress#', 
		PointerDefault   = '#Form.PointerDefault#', 
		PointerTransport = '#Form.PointerTransport#', 
		Operational      = '#Form.Operational#'	
	WHERE Code    = '#Form.CodeOld#'
	</cfquery>
	
	<cfif Form.PointerDefault eq "1">
		
		<cfquery name="Update" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_ClaimEvent
		SET PointerDefault   = 0	
		WHERE Code    != '#Form.CodeOld#'
		</cfquery>
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsTravelClaim" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT EventCode
      FROM ClaimEventTrip
      WHERE EventCode  = '#Form.CodeOld#' 
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
    DELETE FROM Ref_ClaimEvent
    WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
