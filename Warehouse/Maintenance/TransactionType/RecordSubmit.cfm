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

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#"> 
		  SELECT 	TransactionType
	      FROM  	ItemTransaction
	      <cfif ParameterExists(Form.Update)>WHERE TransactionType = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>	 
		  UNION
		  SELECT 	TransactionType
	      FROM  	ItemWarehouseLocationTransaction
	      <cfif ParameterExists(Form.Update)>WHERE TransactionType = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>	 
		  UNION
		  SELECT 	TransactionType
	      FROM  	WarehouseBatch
	      <cfif ParameterExists(Form.Update)>WHERE TransactionType = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>	 
    </cfquery>

	
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_TransactionType
			WHERE 	TransactionType  = '#Form.Code#' 
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
			INSERT INTO Ref_TransactionType
		         (
				 <cfif trim(form.description) neq "">Description,</cfif>
				 <cfif trim(form.TransactionClass) neq "">TransactionClass,</cfif>
				 <cfif trim(form.Area) neq "">Area,</cfif>
 				 <cfif trim(form.ReportTemplate) neq "">ReportTemplate,</cfif>
				 TransactionType
				 )
		  	VALUES (
		  		  <cfif trim(form.description) neq "">'#Form.Description#',</cfif>
				  <cfif trim(form.TransactionClass) neq "">'#Form.TransactionClass#',</cfif>
		          <cfif trim(form.Area) neq "">'#Form.Area#',</cfif>
  		          <cfif trim(form.ReportTemplate) neq "">'#Form.ReportTemplate#',</cfif>
				  '#Form.Code#'
				  )
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
			FROM 	Ref_TransactionType
			WHERE 	TransactionType  = '#Form.Code#' 
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
				UPDATE Ref_TransactionType
				SET    <cfif #CountRec.recordCount# eq 0>TransactionType  = '#Form.Code#',</cfif>
					   Description       = <cfif trim(form.description) neq "">'#Form.Description#'<cfelse>NULL</cfif>,
					   TransactionClass  = <cfif trim(form.TransactionClass) neq "">'#Form.TransactionClass#'<cfelse>NULL</cfif>,
					   Area              = <cfif trim(form.Area) neq "">'#Form.Area#'<cfelse>NULL</cfif>,
					   ReportTemplate    = <cfif trim(form.reportTemplate) neq "">'#Form.reportTemplate#'<cfelse>NULL</cfif>
				WHERE  TransactionType   = '#Form.CodeOld#'
		</cfquery>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     	 action="Update" 
						 	 content="#Form#">
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Transaction Type is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_TransactionType
			WHERE TransactionType = '#FORM.CodeOld#'
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
