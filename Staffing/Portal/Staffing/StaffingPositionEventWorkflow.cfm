
<!--- set into a parameter --->

<cfparam name="url.mde" default="spa">

<cfif mde eq "spa">
    <cfset url.trigger = "T03">
	<cfset url.code    = "06">	
<cfelse>
	<cfset url.trigger = "T01">
	<cfset url.code    = "07">	
</cfif>

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Position	 
	 WHERE    PositionParentId = '#positionparentid#'	
	 ORDER BY PositionNo DESC 
</cfquery>

<cfquery name="Active" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     PersonEvent
	WHERE    PersonNo   = '#personno#' 
	AND      Mission    = '#Parent.Mission#' 
	AND      (PositionNo IS NULL OR PositionNo = '#Parent.PositionNo#') 
	AND      EventTrigger = '#url.trigger#' 
	AND      EventCode    = '#url.code#'
	AND      ActionStatus < '3'			
</cfquery>

<!--- check if the workflow is open --->

<cfset status = "1">

<cfif Active.recordcount eq "0">

	<cfset status = "0">

<cfelseif Active.recordcount gte "1">
				   
	<cf_wfActive objectkeyvalue4="#Active.EventId#">
	
	<cfif wfStatus eq "Closed">	
		<cfset status = "0">
	</cfif>
	
</cfif>	

<cfif status eq "0">

	<cfoutput>
	<a href="javascript:AddEvent('#PersonNo#','#Parent.PositionNo#','#url.ajaxid#','#url.trigger#','#url.code#')">
	<cfif mde eq "spa">
		<cf_tl id="Request SPA">
	<cfelse>
		<cf_tl id="Contract Extension">
	</cfif>	
	
	</a> 
	</cfoutput>

<cfelse>

	<cfset link = "Staffing/Application/Employee/Events/EventDialog.cfm?id=#Active.EventId#">
	
	<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PE.*, P.FullName, RPE.EntityClass
		FROM   PersonEvent PE
			   INNER JOIN Person P ON PE.PersonNo = P.PersonNo
			   LEFT OUTER JOIN Ref_PersonEvent RPE ON RPE.Code = PE.EventCode
		WHERE  PE.EventId = '#Active.eventid#'
	</cfquery>
	
	<cfif Event.EntityClass neq "">
		<cfset entityclass = Event.EntityClass>
	<cfelse>
		<cfset entityclass = "Standard">
	</cfif>
	
	<cf_ActionListing 
		    EntityCode       = "PersonEvent"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			PersonNo         = "#Event.PersonNo#" 
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Remarks#"			   
			ObjectKey4       = "#Active.eventid#"
			Ajaxid           = "#url.ajaxid#"			
			Show             = "Mini"
			HideCurrent      = "No"			
			ObjectURL        = "#link#">	

</cfif>

 	
 		
	
	
	