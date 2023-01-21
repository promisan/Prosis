
<cfset wflink = "Staffing/Application/Employee/Events/EventDialog.cfm?id=#url.ajaxid#">

<cfparam name="eventid" default="#url.ajaxid#">
				
<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PE.*, P.FullName, RPE.EntityClass, RPE.Description
		FROM   PersonEvent PE
			   INNER JOIN Person P ON PE.PersonNo = P.PersonNo
			   LEFT OUTER JOIN Ref_PersonEvent RPE ON RPE.Code = PE.EventCode
		WHERE  PE.EventId = '#eventid#'
</cfquery>

<!--- obtain the correct workflow object --->
			
<cfquery name="getTrigger" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EventTrigger
		WHERE  Code = '#Event.EventTrigger#'		
</cfquery>

<cfif getTrigger.EntityCode eq "VacCandidate">
						
	<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   OrganizationObject
			WHERE  ObjectId = '#eventid#'
			AND    Operational = 1		
	</cfquery>	
				
	<cfif Object.EntityCode eq "VacCandidate">
				
		<cfset qEntityCode = Object.EntityCode>		
		<cfset entityclass = Object.EntityClass>
							
	<cfelse>
			
		<cfset qEntityCode  = "PersonEvent">
		
		<cfif Event.EntityClass neq "">
			<cfset entityclass = Event.EntityClass>
		<cfelse>
			<cfset entityclass = "Standard">
		</cfif>
		
	</cfif>
			
<cfelse>

	<cfset qEntityCode  = "PersonEvent">
	
	<cfif Event.EntityClass neq "">
		<cfset entityclass = Event.EntityClass>
	<cfelse>
		<cfset entityclass = "Standard">
	</cfif>
		
</cfif>

<cfif Event.PersonNo neq "">

	<cfquery name="qCheck" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization.dbo.OrganizationObject
			WHERE  ObjectKeyValue4 = '#eventid#'
			AND    ObjectKeyValue1 = '#Event.PersonNo#'
			AND    EntityCode      = 'PersonEvent'
	</cfquery>

	<cfif qCheck.recordcount neq 0>
		<cfset vPersonNo = 1>
	<cfelse>
		<cfset vPersonNo = 0>
	</cfif>	

<cfelse>

	<cfset vPersonNo = 0>
	
</cfif>

<cfif qEntityCode eq "PersonEvent">
	
	<cfif vPersonNo eq 0>
			
		<cf_ActionListing 
		    EntityCode       = "PersonEvent"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			
			PersonNo         = "#Event.PersonNo#" 
			ObjectDue        = "#Event.DateEventDue#"
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Description#"			   
			ObjectKey4       = "#eventid#"
			Ajaxid           = "#url.ajaxid#"
			Annotation       = "No"
			Communicator     = "Yes"
			Show             = "Yes"
			HideCurrent      = "No"
			ToolBar          = "No"
			ObjectURL        = "#wflink#">
	
	<cfelse>
	
		<cf_ActionListing 
		    EntityCode       = "PersonEvent"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			
			PersonNo         = "#Event.PersonNo#" 
			ObjectDue        = "#Event.DateEventDue#"
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Description#"			   
			ObjectKey4       = "#eventid#"
			ObjectKey1 		 = "#Event.PersonNo#"
			Ajaxid           = "#url.ajaxid#"
			Annotation       = "No"
			Communicator     = "Yes"
			Show             = "Yes"
			HideCurrent      = "No"
			ToolBar          = "No"
			ObjectURL        = "#wflink#">
			
	</cfif>

<cfelse>

	<!--- added for relinked event --->

	<cf_ActionListing 
		    EntityCode       = "#qEntityCode#"
			EntityClass      = "#entityclass#"
			EntityStatus     = ""
			Mission          = "#Event.Mission#"
			OrgUnit          = "#Event.OrgUnit#" 
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Remarks#"			   
			ObjectKey1       = "#Object.ObjectKeyValue1#"
			ObjectKey2       = "#Object.ObjectKeyValue2#"
			ObjectKey3       = "#Object.ObjectKeyValue3#"
			ObjectKey4       = "#Object.ObjectKeyValue4#"
			Ajaxid           = "#url.ajaxid#"
			Annotation       = "No"
			Communicator     = "Yes"
			Show             = "Yes"
			HideCurrent      = "No"
			ToolBar          = "No"
			ObjectURL        = "#wflink#">

</cfif>