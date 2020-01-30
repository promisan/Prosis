
<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		  SELECT 	TransactionClass
	      FROM  	Ref_TransactionType
	      <cfif ParameterExists(Form.Update)>WHERE TransactionClass = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>
		  UNION
		  SELECT 	TransactionClass
	      FROM  	ItemWarehouseLocationLoss
	      <cfif ParameterExists(Form.Update)>WHERE TransactionClass = '#Form.CodeOld#'<cfelse>WHERE 1=0</cfif>  
    </cfquery>

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_TransactionClass
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
			INSERT INTO Ref_TransactionClass
		         (Code,
				 Description,
				 ListingOrder,
				 QuantityNegative,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		    VALUES ('#Form.Code#',
		  		  '#Form.Description#',
				  #Form.listingOrder#,
				  #Form.QuantityNegative#,
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
			FROM 	Ref_TransactionClass
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
				UPDATE Ref_TransactionClass
				SET    <cfif #CountRec.recordCount# eq 0>Code           = '#Form.Code#',</cfif>
					   Description    = '#Form.Description#',
					   ListingOrder   = #Form.listingOrder#,
					   QuantityNegative = #Form.QuantityNegative#
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
	    
		   alert("Transaction Class is in use. Operation aborted.")
	     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_TransactionClass
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
