<!--
    Copyright © 2025 Promisan B.V.

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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif Form.EventMemo eq "">
	<cf_message message = "You must enter a memo/explanation" return="back">
    <cfabort>
</cfif>

<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM ApplicantEvent E
	WHERE E.PersonNo   = '#URL.PersonNo#'
	AND  E.Owner = '#Form.Owner#'
	AND E.Eventid IN (SELECT ObjectKeyValue4
	                  FROM   Organization.dbo.OrganizationObject O, Organization.dbo.OrganizationObjectAction OA
					  WHERE  O.ObjectId = OA.ObjectId
					  AND    OA.ActionStatus = '0'
					  AND    O.Operational = 1)	
</cfquery>

<cfif Check.recordcount gte "1">
	<cf_message message = "Candidate has already one or more outstanding documents" return="back">
    <cfabort>
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.EventDate#">
<cfset dte = #dateValue#>

<cfset CLIENT.Submission = "Manual">


<!--- verify is candidate applicant record exist --->

<cfif URL.ID eq "{00000000-0000-0000-0000-000000000000}">

	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ApplicantAssessment
		WHERE PersonNo = '#URL.PersonNo#'
		AND Owner 	= '#Form.Owner#'
    </cfquery>

	<cfif Check.recordcount eq "0">

		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ApplicantAssessment
		       (PersonNo, 
			    Owner,
				OfficerUserName, 
				OfficerLastName, 
				OfficerFirstName)
		VALUES ('#URL.PersonNo#',
		        '#Form.Owner#',
		     	'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
		</cfquery>

	</cfif>

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ApplicantEvent
	       (PersonNo, 
		    EventCategory, 
			Owner,
			EventDate, 
			EventMemo, 
			PersonStatus, 
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName)
	VALUES ('#URL.PersonNo#',
	        '#Form.EventCategory#',
			'#Form.Owner#',
	        #dte#,
			'#Form.EventMemo#',
			'#Form.PersonStatus#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>	
	
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 EventId
	FROM ApplicantEvent 
	WHERE PersonNo = '#URL.PersonNo#'
	ORDER BY Created DESC 
	</cfquery>

<cfset eventId = "#Check.eventid#">

<cfelse>

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ApplicantEvent 
	       SET EventCategory = '#Form.EventCategory#', 
			   EventDate     = #dte#,  
			   EventMemo     = '#Form.EventMemo#', 
			   PersonStatus  = '#Form.PersonStatus#' 
	WHERE EventId = '#URL.ID#'
	</cfquery>

<cfset eventId = "#URL.ID#">

</cfif>

<cfoutput>

  <script>
  	window.location = "DocumentEdit.cfm?mode=view&ID=#eventId#"
  </script>	
	
</cfoutput>


