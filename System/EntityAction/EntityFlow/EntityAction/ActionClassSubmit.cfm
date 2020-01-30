
<cfparam name="Form.ClassOperational" default="0">
<cfparam name="Form.EntityParameter" default="">
<cfparam name="Form.EnableEMail" default="0">
<cfparam name="Form.EmbeddedFlow" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE  Ref_EntityClass
	  SET Operational      = '#Form.ClassOperational#',
		  EnableEMail      = '#Form.EnableEMail#',
		  EntityParameter  = '#Form.EntityParameter#',
 	      EntityClassName  = '#Form.EntityClassName#',
		  RefreshInterval  = '#form.RefreshInterval#',
		  EmbeddedFlow     = '#Form.EmbeddedFlow#' 
		  
		WHERE EntityClass = '#URL.ID2#'
	    AND   EntityCode = '#URL.EntityCode#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Ref_EntityClass" 
		Mode            = "Save"
		Key1Value       = "#URL.EntityCode#"
		Key2Value       = "#URL.ID2#"		
		Name1           = "EntityClassName">		
	
	<cfset url.id2 = "">
    <cfinclude template="ActionClass.cfm">		
	
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = '#URL.EntityCode#' 
		AND EntityClass = '#Form.EntityClass#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityClass
			            (EntityCode,
						 EntityClass,
						 EntityClassName,					
						 EntityParameter,
						 EnableEMail,
						 RefreshInterval,
						 EmbeddedFlow,
						 Operational)
			      VALUES ('#URL.EntityCode#',
					      '#Form.EntityClass#',
						  '#Form.EntityClassName#',					  			 
						  '#Form.EntityParameter#',
						  '#Form.EnableEMail#',
						  '#Form.RefreshInterval#',
						  '#Form.EmbeddedFlow#',
					      '#Form.ClassOperational#')
			</cfquery>
			
			<cf_LanguageInput
				TableCode       = "Ref_EntityClass" 
				Mode            = "Save"
				Key1Value       = "#URL.EntityCode#"
				Key2Value       = "#Form.EntityClass#"		
				Name1           = "EntityClassName">	
	</cfif>	
	
	<cfset url.id2 = "new">
    <cfinclude template="ActionClass.cfm">		
		   	
</cfif>
