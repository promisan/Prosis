<cfparam name="Form.CustomDialog" default="">


<cfquery name="CountRec" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM	PersonAddressContact
	<cfif ParameterExists(Form.Update)>
		WHERE ContactCode = '#Form.CodeOld#'
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
		FROM 	Ref_Contact
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
	INSERT INTO Ref_Contact
	         (Code,
			 Description, 
			 CallSignMask,
			 SelfService,
			 ListingOrder,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#', 
	  		  '#Form.Description#',
	          '#Form.CallSignMask#',
			  '#Form.SelfService#',
			  '#Form.ListingOrder#',
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
		UPDATE Ref_Contact
		SET   <cfif CountRec.recordCount eq 0>Code = '#Form.Code#',</cfif>
		    Description         = '#Form.Description#',      
		    CallSignMask        = '#Form.CallSignMask#',     			
		    SelfService         = '#Form.SelfService#',     						
		    ListingOrder        = '#Form.ListingOrder#'     			
		WHERE Code = '#Form.CodeOld#' 
		</cfquery>	
		
	</cfif>
	
</cfif>


<cfif ParameterExists(Form.Delete)>     
	
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Contact type is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Contact
			WHERE Code   = '#Form.codeOld#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  