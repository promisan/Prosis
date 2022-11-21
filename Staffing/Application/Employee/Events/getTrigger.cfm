
<cfparam name="URL.event"     	default="">

<cfparam name="URL.eventid" 	default="">

<cfparam name="URL.portal"  	default="0">
<cfparam name="URL.scope"    	default="">

<cfparam name="URL.ptrigger" 	default="">
<cfparam name="URL.pevent" 		default="">
<cfparam name="URL.preason" 	default="">


<cfif URL.eventId neq "">

	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   PersonEvent
		 WHERE  EventId = '#URL.eventId#'
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
					<!--- we filter for the inquiry personal portal --->
					<cfif url.scope eq "inquiry" and url.event eq "inquiry">
					AND    ET.ActionImpact = 'inquiry'
					<cfelseif url.event neq "">
					AND    PE.Code = '#url.event#'					
					</cfif>					
		         )
				 
		<cfif url.PositionNo neq "">
		AND      (EntityCode != 'VacCandidate' OR EntityCode is NULL)
		</cfif>		
		<cfif url.scope eq "portal">
		AND      Selfservice = 1
		</cfif>
		 
		ORDER BY ListingOrder
		
</cfquery>
	
<select name="triggercode"
        id="triggercode" 
		style="width:95%" 
		class="regularxxl" 
		onchange="_cf_loadingtexthtml='';ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Staffing/Application/Employee/Events/getEvent.cfm?personno=<cfoutput>#url.personno#</cfoutput>&triggercode='+this.value+'&eventid=&mission='+document.getElementById('mission').value+'&portal=<cfoutput>#url.portal#&scope=#url.scope#&pevent=#url.pevent#&preason=#url.preason#</cfoutput>','dEvent');">		
		<cfif qTriggers.recordcount gt "1">
			<option value="">Please select...</option>
		</cfif>
		<cfoutput query="qTriggers">
			<option value="#Code#" <cfif Code eq qEvent.EventTrigger OR Code eq url.ptrigger>selected</cfif>>#Description#</option>
		</cfoutput>
		
<select>		

<cfset AjaxOnLoad("checkevent")>
	
