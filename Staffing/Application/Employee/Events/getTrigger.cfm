<cfparam name="URL.eventid" default="">
<cfparam name="URL.portal"  default="0">

<cfif URL.eventId neq "">

	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  EventId='#URL.eventId#'
	</cfquery>		 

<cfelse>

	<cfquery name="qEvent" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  1=0
	</cfquery>		
	
</cfif>	

<cfquery name="qTriggers" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   Code,
		         Description,
		         ListingOrder,
		         OfficerUserId,
		         OfficerLastName,
		         OfficerFirstName,
		         Created
				 
		FROM     Ref_EventTrigger
		
		WHERE    Code IN (
				  	SELECT  EventTrigger
					FROM    Ref_PersonEventTrigger ET 
					        INNER JOIN Ref_PersonEvent PE         ON ET.EventCode=PE.Code 
							INNER JOIN Ref_PersonEventMission REM ON REM.PersonEvent=ET.EventCode
					WHERE   REM.Mission = '#url.mission#'
					<cfif url.portal eq "1">
						AND   (PE.EnablePortal = 1 or Code = '#qEvent.EventTrigger#')
					</cfif>
					
		         )
				 
		<cfif url.PositionNo neq "">
		AND      (EntityCode != 'VacCandidate' OR EntityCode is NULL)
		</cfif>		
		 
		ORDER BY ListingOrder
		
</cfquery>
	
<select name="triggercode"
        id="triggercode" 
		style="width:300px" 
		class="regularxl" 
		onchange="_cf_loadingtexthtml='';ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Staffing/Application/Employee/Events/getEvent.cfm?triggercode='+this.value+'&eventid=&mission='+document.getElementById('mission').value+'&portal=#url.portal#','dEvent');">		
		<option value="">Please select...</option>
		<cfoutput query="qTriggers">
			<option value="#Code#" <cfif Code eq qEvent.EventTrigger>selected</cfif>>#Description#</option>
		</cfoutput>
		
<select>		

<cfset AjaxOnLoad("checkevent")>
	
