<cfparam name="URL.eventcode" 	default="">

<cfif trim(url.eventcode) eq "">

	<div style="text-align:center;">
		<h2>[ <cf_tl id="Select a request type"> ]</h2>
	</div>
	
<cfelse>		
	
	<cfquery name="EventMission" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_PersonEventMission
			WHERE  	PersonEvent	= '#URL.eventcode#'	
			AND		Mission = '#url.mission#'	
			-- AND 	EnablePortal = '1'
	</cfquery> 
	
	<cfquery name="qReasons" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   L.*
			FROM     Ref_PersonGroupList L
					 INNER JOIN Ref_PersonEventTrigger T
					 	ON L.GroupCode = T.ReasonCode
			WHERE    T.EventCode    = '#URL.eventcode#'
			AND      T.EventTrigger = '#URL.triggercode#'
			AND      L.Operational = '1' 
	</cfquery>	
		
	<cfif EventMission.ReasonMode eq "dialog" OR qReasons.recordCount eq 0>	
		<cfset vTemplate = "EventBaseDialog.cfm">
	<cfelse>
		<cfset vTemplate = "EventBaseReason.cfm">
	</cfif>
	
	<cf_securediv 
		id="divEventDetail" 
		bind="url:#session.root#/staffing/portal/events/#vTemplate#?scope=portal&id=#url.personno#&mission=#url.mission#&event=#url.eventcode#&trigger=#url.triggercode#" 
		style="height:97%">

</cfif>
