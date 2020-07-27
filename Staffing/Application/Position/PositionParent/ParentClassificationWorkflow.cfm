
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#URL.ajaxid#'	 
</cfquery>

<cfset link = "Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?id2=#url.ajaxid#">			

<!--- prepare for a new workflow --->

<cfparam name="url.class"  default="normal">

<cfif url.class eq "normal">

	<cf_ActionListing 
	    EntityCode       = "PostClassification"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		tablewidth       = "99%"
		Mission          = "#Parent.mission#"	
		ObjectReference  = "Classification"
		ObjectReference2 = "#Parent.PostGrade#" 	
	    ObjectKey1       = "#url.ajaxid#"	
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes">

<cfelseif url.class eq "init">
	
	<cfquery name="CloseCurrent" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE  Organization.dbo.OrganizationObject
			 SET     Operational = 0
			 WHERE   ObjectKeyValue1 = '#url.ajaxid#'
			 AND     EntityCode = 'PostClassification'							 
	</cfquery>
			
	<!--- add flow and show --->
		
	<cf_ActionListing 
	    EntityCode       = "PostClassification"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		tablewidth       = "99%"
		Mission          = "#Parent.mission#"	
		ObjectReference  = "Classification"
		ObjectReference2 = "#Parent.PostGrade#" 	
	    ObjectKey1       = "#url.ajaxid#"	
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		HideCurrent      = "No">
		
	<script>
		document.getElementById('classificationadd').className = "hide"
	</script>		
	
<cfelseif url.class eq "disable">

	<cfquery name="CloseCurrent" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE  Organization.dbo.OrganizationObject
			 SET     Operational = 0
			 WHERE   ObjectKeyValue1 = '#url.ajaxid#'
			 AND     EntityCode = 'PostClassification'	
			  AND     Operational     = 1								 
	</cfquery>
	
<cfelseif url.class eq "delete">	
	
	<cfquery name="CloseCurrent" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 DELETE  Organization.dbo.OrganizationObject			
			 WHERE   ObjectKeyValue1 = '#url.ajaxid#'
			 AND     EntityCode      = 'PostClassification'	
			 AND     Operational     = 1						 
	</cfquery>	
		
	<script>
		document.getElementById('classificationdelete').className = "hide"
	</script>	

</cfif>

