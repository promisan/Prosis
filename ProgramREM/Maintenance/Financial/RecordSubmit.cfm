
<cfparam name="Form.Mission" default="">
<cfparam name="Form.ProgramCategory" default="">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM  	Ref_ProgramEvent
WHERE 	Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An event with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   	<cftransaction>
	   
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ProgramFinancial
		         (Code,
				 Description,
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#Form.ListingOrder#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>
	  
	  <!--- Categories --->
	  
	  <cfif Form.ProgramCategory neq "">
	  
	  <cfloop index="cat" list="#Form.ProgramCategory#">
	  
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramFinancialCategory
					         (Code,
							 ProgramCategory,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#',
				          '#cat#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
	  
	  </cftransaction>
			  
	 </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ProgramFinancial
	SET 
	    Code           = '#Form.Code#',
	    Description    = '#Form.Description#',
		ListingOrder   = '#Form.ListingOrder#'
	WHERE Code    = '#Form.CodeOld#'
	</cfquery>
	
	<!--- Categories --->
	
	<cfquery name="ClearCats" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ProgramFinancialCategory	
		WHERE Code    = '#Form.CodeOld#'
	</cfquery>
	  
	  <cfif Form.ProgramCategory neq "">
	  
	  <cfloop index="cat" list="#Form.ProgramCategory#">
	  
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramFinancialCategory
					         (Code,
							 ProgramCategory,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#',
				          '#cat#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
	  
	</cftransaction>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<!--- <cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT *
      FROM   ProgramEvent
      WHERE  ProgramEvent  = '#Form.Code#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Financial metric is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse> --->
			
	<cfquery name="Delete" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	DELETE FROM Ref_ProgramFinancial
	    WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	<!--- </cfif> --->
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  
