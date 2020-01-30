

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Contact
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
			INSERT INTO Ref_Contact 
				(
					Code,
					Description,
					CallSignMask,
					ListingOrder,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES 
				(
					'#Form.Code#',
					'#Form.Description#',
					'#Form.CallSignMask#',
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
		UPDATE Ref_Contact
		SET    Description 		= '#Form.Description#',
	    	   CallSignMask     = '#Form.CallSignMask#',
			   ListingOrder     = '#Form.ListingOrder#'
		WHERE  Code = '#Form.Code#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
     	 SELECT TOP 1 ContactCode
     	 FROM   ApplicantBackgroundContact
    	 WHERE  ContactCode  = '#Form.Code#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Call sign is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Contact
			WHERE  Code    = '#Form.Code#'
	    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
