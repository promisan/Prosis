
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_StatusReason
	WHERE Code  = '#Form.Code#' 	
	</cfquery>

    <cfif #Verify.recordCount# is 1>	   
	
	   <script language="JavaScript">	   
	     alert("A record with this code has been registered already!")	     
	   </script>  
  
   	<CFELSE>
     
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_StatusReason
		         (Code,
				 Description, 
				 Status,
				 Mission,
				 IncludeSpecification,
				 ListingOrder, 
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#', 
		          '#Form.Description#',
				  '#Form.Status#',
				  <cfif form.mission eq "">
				  NULL,
				  <cfelse>
				  '#Form.Mission#',
				  </cfif>
				  '#Form.Specification#',
				  '#Form.ListingOrder#',
				  '#Form.Operational#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>

	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_StatusReason
	SET   Description    = '#Form.Description#',
		  Status 		 = '#Form.Status#',
		  IncludeSpecification = '#Form.Specification#',
		  Operational    = '#Form.Operational#',
		  <cfif form.mission eq "">
		  Mission =  NULL,
		  <cfelse>
		  Mission = '#Form.Mission#',
		  </cfif>
		  ListingOrder   = '#Form.ListingOrder#',
	      Code           = '#Form.Code#'
	WHERE Code    = '#Form.CodeOld#'
	</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_StatusReason
	WHERE Code   = '#Form.codeOld#'
    </cfquery>
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  