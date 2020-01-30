
<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotmentAction
		WHERE      ActionId = '#url.ajaxid#'	   	 	
</cfquery>

<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Program
		WHERE      ProgramCode = '#get.ProgramCode#'	   	 	
</cfquery>

<cfquery name="getOrganization" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramPeriod
		WHERE      ProgramCode = '#get.ProgramCode#'	
		AND        Period      = '#get.period#'   	 	
</cfquery>

<cfquery name="getAction" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Ref_AllotmentAction
		WHERE      Code = '#get.ActionClass#'	   	 	
</cfquery>

<!--- show the workflow object --->
	
<cfset link = "ProgramREM/Application/Budget/Action/AllotmentActionView.cfm?ID=#url.ajaxid#">
 
<!--- ----------------------------------- --->	
<!--- create and show the workflow object --->
<!--- ----------------------------------- --->

<cfif getAction.entityClass neq "">


	   					
	<cf_ActionListing 
	    TableWidth       = "100%"
	    EntityCode       = "EntBudgetAction"
		EntityClass      = "#getAction.entityClass#"  
		EntityGroup      = "" 	
		EntityStatus     = ""		
		ajaxid           = "#url.ajaxid#"
		Mission          = "#getProgram.Mission#"
		OrgUnit          = "#getOrganization.OrgUnit#"
		ObjectReference  = "Allotment Transaction"
		ObjectReference2 = "#getProgram.ProgramName#"
		ObjectKey4       = "#url.ajaxid#"
		Show             = "Yes"	
		Reset            = "Yes"
	  	ObjectURL        = "#link#"
		DocumentStatus   = "0">
	
</cfif>	