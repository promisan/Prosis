
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_LocationClass
	WHERE 
	Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <cf_tl id = "A record with this code has been registered already!" var = "vAlready">

   <cfoutput>
	   <script language="JavaScript">
	     alert("#vAlready#")
	   </script> 
   </cfoutput> 
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_LocationClass
		         (code,
				 Description,
				 ListingIcon,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		 	VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#Form.ListingIcon#',
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

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_LocationClass
		SET 
		    Code           = '#Form.code#',
		    Description    = '#Form.Description#',
			ListingIcon    = '#Form.ListingIcon#'
		WHERE code         = '#Form.CodeOld#'
	</cfquery>

	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT LocationClass
	      FROM   Location
	      WHERE  LocationClass = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
	 <cf_tl id = "Class is in use. Operation aborted." var = "1">
     <script language="JavaScript">
	   alert("#lt_text#")
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_LocationClass
			WHERE  Code = '#FORM.codeOld#'
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
