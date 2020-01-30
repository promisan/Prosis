
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AddressType
	WHERE  AddressType = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
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
			INSERT INTO Ref_AddressType
		         (AddressType,
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
		UPDATE Ref_AddressType
		SET 
		    AddressType    = '#Form.code#',
		    Description    = '#Form.Description#',
			ListingOrder   = '#Form.ListingOrder#'
		WHERE AddressType   = '#Form.CodeOld#'
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
	      SELECT AddressType
	      FROM   CustomerAddress
	      WHERE  AddressType = '#Form.codeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
	 
	 <cfoutput>	 
		 <cf_tl id = "Class is in use. Operation aborted." var = "1">
    	 <script language="JavaScript">
		   alert("#lt_text#")
    	 </script> 
	 </cfoutput> 
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_AddressType
			WHERE  AddressType = '#FORM.codeOld#'
	    </cfquery>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     	 action="Delete" 
						 	 content="#Form#">
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
