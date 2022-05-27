
<!--- set into a parameter --->

<cfparam name="url.mde" default="spa">

<cfif mde eq "spa">
    <cfset url.trigger = "POSTEVT">
	<cfset url.code    = "06">	
<cfelseif mde eq "ass">
    <cfset url.trigger = "MOVEMN">
	<cfset url.code    = "06">		
<cfelse>
	<cfset url.trigger = "CONTRA">
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
	
	AND      ( PositionNo IS NULL 
	           OR PositionNo IN (SELECT PositionNo FROM Position         WHERE PositionParentId = '#positionparentid#')
			   <!--- adjusted as otherwise in case of 0 incumbency it would not show --->
			   OR PositionNo IN (SELECT PositionNo 
			   				     FROM   PersonAssignment 
								 WHERE  PersonNo         = '#PersonNo#' 
								 AND    AssignmentStatus IN ('0', '1')								
								 AND    DateEffective   < getDate() 
								 AND    DateExpiration  > getDate() 
								 )
			   ) 
	AND      EventTrigger = '#url.trigger#' 
	-- AND      EventCode    = '#url.code#'
	AND      ActionStatus < '3'		
	ORDER BY Created DESC	
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

	<cfif personno eq client.personno>
	
		<cfoutput>
			<table  style="width:100%"><tr><td class="labelmedium" style="background-color:silver;font-size:12px" align="center" title="Please ask focal point to request on your behalf">
			<cfif mde eq "spa">
				<cf_tl id="Request SPA">
			<cfelseif mde eq "ass">
				<cf_tl id="Request Assignment Extension">	
			<cfelse>
				<cf_tl id="Request Appointment Extension">
			</cfif>	
			</td></tr></table>	
		</cfoutput>
				
	<cfelse>
	
	<cfif mde eq "spa">
	
	<cfelse>
	
		<table style="width:100%">
			<tr class="labelmedium">
			<cfoutput>
			<td style="padding-left:4px;width:25px;padding-right:5px;">
			<img src="#client.root#/images/finger.png" height="20" width="20" alt="" border="0">
			</td>
			<td style="padding-left:14px">		
			
				<a style="width:100%;font-size:12px" href="javascript:AddEvent('#PersonNo#','#Parent.PositionNo#','#url.ajaxid#','#url.trigger#','#url.code#','#thisorgunit#')">
				<cfif mde eq "spa">
					<cf_tl id="Request SPA">
				<cfelseif mde eq "ass">
					<cf_tl id="Extend Assignment">	
				<cfelse>
					<cf_tl id="Extend Appointment">
				</cfif>		
				</a> 
			</cfoutput>
			</tr>
		</table>
	
	</cfif>
	
	</cfif>

<cfelse>

	<cfset hasWorkflow = "1">

	<cfset link = "Staffing/Application/Employee/Events/EventDialog.cfm?id=#Active.EventId#">
	
	<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PE.*, P.FullName, RPE.EntityClass, RPE.Description
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
			OrgUnit          = "#Event.OrgUnit#" 
			PersonNo         = "#Event.PersonNo#" 
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Description#"			   
			ObjectKey4       = "#Active.eventid#"
			Ajaxid           = "#url.ajaxid#"			
			Show             = "Mini"
			HideCurrent      = "No"			
			ObjectURL        = "#link#">	

</cfif>
	