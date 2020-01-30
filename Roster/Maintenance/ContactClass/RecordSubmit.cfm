

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ContactClass
	WHERE 	Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	   </script>  
	  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ContactClass
				(
					Code,
					Description,
					ListingOrder,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES 
				(
					'#Form.Code#',
					'#Form.Description#',
					'#Form.ListingOrder#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
			
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ContactClass
		SET    Description 		= '#Form.Description#',
			   ListingOrder     = '#Form.ListingOrder#'
		WHERE  Code = '#Form.Code#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
     	 SELECT TOP 1 ContactClass
     	 FROM   ApplicantBackgroundContact
    	 WHERE  ContactClass  = '#Form.Code#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Contact class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ContactClass
			WHERE  Code    = '#Form.Code#'
	    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
