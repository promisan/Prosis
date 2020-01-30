
<cfif ParameterExists(Form.Save)> 

<cfquery name="Verify" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_UnitClass
	WHERE code  = '#Form.code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
	 history.back()
     
   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_UnitClass
		         (Code,
				 Description,
				 listingOrder,
				  OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.Code#','#Form.Description#', #Form.listingOrder#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_UnitClass" 
			Mode            = "Save"
			DataSource      = "AppsWorkOrder"
			Key1Value       = "#Form.Code#"
			Name1           = "Description">	
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfparam name="Form.Code" default="#Form.CodeOld#">

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_UnitClass
		SET 
		      Code   = '#Form.Code#', 
			  Description = '#Form.Description#',
			  listingOrder = #Form.listingOrder#
		WHERE Code   = '#Form.CodeOld#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Ref_UnitClass" 
		Mode            = "Save"
		DataSource      = "AppsWorkOrder"
		Key1Value       = "#Form.Code#"
		Name1           = "Description">	

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
		
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_UnitClass
		WHERE Code = '#FORM.Code#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
