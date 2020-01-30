<cfoutput>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<cf_tl id = "A record with this code has been registered already!" var = "vAlready">
<cf_tl id = "Disposal code is in use. Operation aborted." var = "vDisposal">

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Disposal
		WHERE 
		Code   = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   		<script language="JavaScript">
   
     		alert("#vAlready#")
     
   		</script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_Disposal
		         (Code,
				 Description,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  	VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		  
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Insert" 
							 content="#Form#">
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Disposal
		SET 
	    	Code           = '#Form.code#',
		    Description    = '#Form.Description#'
		WHERE Code         = '#Form.CodeOld#'
	</cfquery>
			  
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action ="Update" 
					 	 content="#Form#">
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT 	DisposalMethod
      	FROM 	AssetDisposal
      	WHERE 	DisposalMethod = '#Form.codeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     	<script language="JavaScript">    
	   		alert("#vDisposal#")	        
     	</script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Disposal
			WHERE Code = '#FORM.codeOld#'
	    </cfquery>
		
				  
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Delete" 
							 content="#Form#">
	
	</cfif>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  

</cfoutput>