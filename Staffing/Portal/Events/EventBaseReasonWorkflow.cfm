<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
	   
<cfquery name="Active" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     PersonEvent
	WHERE    PersonNo       = '#url.personno#' 
	AND      Mission        = '#url.mission#' 	
	AND      EventTrigger   = '#url.trigger#' 
	AND      EventCode      = '#url.eventcode#'
	AND      ReasonCode     = '#url.reasoncode#'
	AND      ReasonListCode = '#url.reasonlistcode#'
	AND      ActionStatus < '3'		
	ORDER BY Created DESC	
</cfquery>

<cfif Active.recordcount gt "0">

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
			OrgUnit          = "#Event.OrgUnit#" 
			PersonNo         = "#Event.PersonNo#" 
			ObjectReference  = "#Event.FullName#"
			ObjectReference2 = "#Event.Remarks#"			   
			ObjectKey4       = "#Active.eventid#"
			Ajaxid           = "#url.ajaxid#"			
			Show             = "Mini"
			HideCurrent      = "No"			
			ObjectURL        = "#link#">	
		
</cfif>	