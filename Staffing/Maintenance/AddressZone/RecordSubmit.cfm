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
<cfparam name="Form.CustomDialog" default="">


<cfquery name="CountRec" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	SELECT TOP 1 addressZone
	FROM	vwPersonAddress
	<cfif ParameterExists(Form.Update)>
		WHERE AddressZone = '#Form.CodeOld#'
	<cfelse>
		WHERE 1 = 0
	</cfif>
		
 </cfquery>		

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AddressZone
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>
	
	<cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <CFELSE>
	    
	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_AddressZone
	         (Code,
			 Mission,
			 Description, 
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#', 
	  		  '#Form.Mission#',
	          '#Form.Description#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_AddressZone
			WHERE Code  = '#Form.Code#' 
	</cfquery>
	
   <cfif Verify.recordCount gt 0 and form.code neq form.codeOld>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>   				    
   
		<cfquery name="Update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_AddressZone
		SET   <cfif CountRec.recordCount eq 0>Code = '#Form.Code#',</cfif>
			  Mission	          = '#Form.Mission#',
			  Description         = '#Form.Description#'      
		WHERE Code = '#Form.CodeOld#' 
		</cfquery>	
		
	</cfif>
	
</cfif>


<cfif ParameterExists(Form.Delete)>     
	
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Address zone is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_AddressZone
			WHERE Code   = '#Form.codeOld#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  