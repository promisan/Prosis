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
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Settlement
	WHERE  
	Code   = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Settlement
		         (Code,
				 Description,
				 <cfif trim(form.mode) neq "">Mode,</cfif>
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.Code#',
		          '#Form.Description#',
				  <cfif trim(form.mode) neq "">'#form.mode#',</cfif> 
				  '#Form.Operational#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		  
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#Form#">

    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Settlement
	SET 
	    Code           = '#Form.code#',
	    Description    = '#Form.Description#',
		Operational    = '#Form.Operational#',
		Mode		   = <cfif trim(form.mode) neq "">'#form.mode#'<cfelse>null</cfif>
	WHERE code         = '#Form.CodeOld#'
	</cfquery>

	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                 action="Update" 
						 content="#Form#">
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

<!--- <cfquery name="CountRec" 
      datasource="AppsWorkorder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT SettleCode
      FROM   WarehouseBatchSettlement
      WHERE  SettleCode  = '#Form.codeOld#' 
    </cfquery>
 --->
  <!---   <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Make is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse> --->
			
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Settlement
			WHERE  Code = '#FORM.codeOld#'
	    </cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Delete" 
							 content="#Form#">
	
	<!--- </cfif> --->
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
