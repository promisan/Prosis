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
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	ServiceDomain
      FROM  	Request
	  <cfif ParameterExists(Form.Update)>WHERE ServiceDomain = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>
	  UNION
	  SELECT 	ServiceDomain
      FROM  	ServiceItem
      <cfif ParameterExists(Form.Update)>WHERE ServiceDomain = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>
	  UNION
	  SELECT 	ServiceDomain
      FROM  	WorkOrderService
      <cfif ParameterExists(Form.Update)>WHERE ServiceDomain = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>
    </cfquery>

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ServiceitemDomain
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount gt 0>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
		 history.back()
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ServiceitemDomain
		         (Code,
				 Description,
				 ListingOrder,
				 <cfif trim(Form.displayFormat) neq "">DisplayFormat,</cfif>
				 AllowConcurrent,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		  		  '#Form.Description#',
				  #Form.listingOrder#,
				  <cfif trim(Form.displayFormat) neq "">'#Form.displayFormat#',</cfif>
				  '#Form.AllowConcurrent#',
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ServiceitemDomain
		WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount gt 0 and Form.Code neq Form.CodeOld>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
		 history.back()
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_ServiceitemDomain
			SET    <cfif #CountRec.recordCount# eq 0>Code = '#Form.Code#',</cfif>
				   Description    = '#Form.Description#',
				   ListingOrder   = #Form.listingOrder#,
				   DisplayFormat  = <cfif trim(Form.displayFormat) eq "">null<cfelse>'#Form.displayFormat#'</cfif>,
				   AllowConcurrent = '#Form.AllowConcurrent#'
			WHERE  Code           = '#Form.CodeOld#'
		</cfquery>
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Domain is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ServiceitemDomain
			WHERE Code = '#FORM.CodeOld#'
		</cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 window.opener.location.reload()
        
</script>  
