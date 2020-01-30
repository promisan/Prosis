
<!--- ajax workflow object to be show in the event is active ala Contract records --->

<cfquery name="getEvent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ContributionEvent
		WHERE      ContributionEventId = '#url.ajaxid#'	   	 	
</cfquery>

<cfquery name="getContribution" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Contribution
		WHERE      ContributionId = '#getEvent.ContributionId#'			
</cfquery>

<!--- show the workflow object --->
	
<cfset link = "ProgramREM/Application/Program/Donor/Event/ContributionEventView.cfm?ID=#url.ajaxid#">
 
<!--- ----------------------------------- --->	
<!--- create and show the workflow object --->
<!--- ----------------------------------- --->

<cfif getEvent.entityClass neq "">
	   					
	<cf_ActionListing 
	    TableWidth       = "100%"
	    EntityCode       = "EntDonorEvent"
		EntityClass      = "#getEvent.entityClass#"  
		EntityGroup      = "" 	
		EntityStatus     = ""		
		ajaxid           = "#url.ajaxid#"
		Mission          = "#getContribution.Mission#"
		OrgUnit          = "#getContribution.OrgUnitDonor#"
		ObjectReference  = "Reporting Event"
		ObjectReference2 = "#getContribution.Reference#"
		ObjectKey4       = "#url.ajaxid#"
		Show             = "Yes"	
	  	ObjectURL        = "#link#"
		DocumentStatus   = "0">
	
</cfif>	