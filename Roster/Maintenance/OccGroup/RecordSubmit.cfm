
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM OccGroup
WHERE OccupationalGroup  = '#Form.OccupationalGroup#' 

</cfquery>

    <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
      
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO OccGroup
		         (OccupationalGroup,
				 Description, 
				 DescriptionFull,
				 Acronym,
				 ParentGroup,
				 ListingOrder,
				 Status,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.OccupationalGroup#', 
		          '#Form.Description#',
				  '#Form.DescriptionFull#',
				  '#Form.Acronym#',
				  <cfif Form.ParentGroup neq "">
				  '#Form.ParentGroup#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.ListingOrder#',
				  '#Form.Status#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>
				  
		<cf_LanguageInput
				TableCode       = "OccGroup" 
				Mode            = "Save"
				DataSource      = "AppsSelection"
				Key1Value       = "#Form.OccupationalGroup#"
				Name1           = "DescriptionFull">					  
				  		  
		<cf_LanguageInput
					TableCode       = "OccGroup" 
					Mode            = "Save"
					DataSource      = "AppsSelection"
					Key1Value       = "#Form.OccupationalGroup#"
					Name1           = "Description">
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
   
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OccGroup
		SET   Description           = '#Form.Description#', 
			  DescriptionFull       = '#Form.DescriptionFull#',
			  Acronym               = '#Form.Acronym#',
			  <cfif Form.ParentGroup neq "">
			  ParentGroup           = '#Form.ParentGroup#',
			  <cfelse>
			  ParentGroup           = NULL,
			  </cfif>		
			  ListingOrder          = '#Form.ListingOrder#',
			  Status = '#Form.Status#'
		WHERE OccupationalGroup   = '#Form.OccupationalGroup#'
	</cfquery>
	
	<cf_LanguageInput
				TableCode       = "OccGroup" 
				Mode            = "Save"
				DataSource      = "AppsSelection"
				Key1Value       = "#Form.OccupationalGroup#"
				Name1           = "Description">
				
	<cf_LanguageInput
				TableCode       = "OccGroup" 
				Mode            = "Save"
				DataSource      = "AppsSelection"
				Key1Value       = "#Form.OccupationalGroup#"
				Name1           = "DescriptionFull">				

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM      FunctionTitle
     WHERE     OccupationalGroup = '#Form.OccupationalGroup#'
    </cfquery>
	
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Occupational Group is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM OccGroup
	WHERE OccupationalGroup   = '#Form.OccupationalGroup#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  