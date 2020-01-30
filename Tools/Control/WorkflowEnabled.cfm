
<!---verify if workflow object is enabled for entity  --->

<cfparam name="Attributes.EntityCode"  default = "">
<cfparam name="Attributes.EntityClass" default = "">
<cfparam name="Attributes.Mission"     default = "">
<cfparam name="Attributes.datasource"  default = "appsOrganization">

<cfquery name="workflow" 
datasource="#Attributes.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Organization.dbo.Ref_EntityMission
	WHERE  EntityCode = '#attributes.EntityCode#'
	AND    Mission    = '#attributes.Mission#'
</cfquery>

<cfif workflow.WorkflowEnabled eq "1">

	<cfif Attributes.entityClass eq "">

		    <cfset Caller.WorkflowEnabled = 1>  
			
	<cfelse>
			
		<cfquery name="workflow" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization.dbo.Ref_EntityClassPublish
			WHERE  EntityCode    = '#attributes.EntityCode#'
			AND    EntityClass   = '#attributes.EntityClass#'
		</cfquery>
		
		<cfif workflow.recordcount eq "0">
		
			 <cfset Caller.WorkflowEnabled = 0> 
			 
		<cfelse>
		
			 <cfset Caller.WorkflowEnabled = 1> 	
			 		
		</cfif>
	
	</cfif>		
    
<cfelse>  

    <cfset Caller.WorkflowEnabled = 0> 
    
</cfif>  

 