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
<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	ShipToMode
      FROM  	RequestTask
	  <cfif ParameterExists(Form.Update)>WHERE ShipToMode = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>	  
    </cfquery>

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ShipToMode
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount gt 0>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
		 history.back()
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ShipToMode
			         (Code,
					 Description,
					 ListingOrder,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.Code#',
			  		  '#Form.Description#',
					  #Form.listingOrder#,
			          '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		  
		 <cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#Form#">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ShipToMode
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount gt 0 and Form.Code neq Form.CodeOld>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
		 history.back()
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ShipToMode
				SET    <cfif #CountRec.recordCount# eq 0>Code           = '#Form.Code#',</cfif>
					   Description    = '#Form.Description#',
					   ListingOrder   = #Form.listingOrder#
				WHERE  Code        = '#Form.CodeOld#'
		</cfquery>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Mode of shipment is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ShipToMode
			WHERE Code = '#FORM.CodeOld#'
		</cfquery>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 opener.location.reload()
        
</script>  
