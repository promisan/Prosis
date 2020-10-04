<cfparam name="URL.eventid" 	default="">
<cfparam name="URL.id" 			default="">

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT Code,
		       Description,
			   ActionInstruction
		FROM   Ref_PersonEvent RPE 
		WHERE  Code IN (SELECT EventCode 
		                FROM   Ref_PersonEventTrigger 
						WHERE  EventTrigger = '#url.triggercode#')
		<cfif URL.mission neq "">
		AND    Code IN (SELECT PersonEvent 
			            FROM   Ref_PersonEventMission 
						WHERE  Mission  = '#URL.mission#')
		</cfif>		
		<cfif url.portal eq "1">
		AND   (EnablePortal = 1)
		</cfif>
		ORDER BY ListingOrder	
</cfquery>	

<cfoutput query="qEvents">

	<cfquery name="EventMission" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_PersonEventMission
			WHERE  	PersonEvent	    = '#Code#'	
			AND		Mission = '#url.mission#'	
			AND 	EnablePortal = '1'
	</cfquery>
	
	<cfset vBg = "background:##EFEFEF;">
	<cfif trim(EventMission.MenuColor) neq "">
		<cfset vBg = "background:###EventMission.MenuColor#;">
	</cfif>
	
	<div class="clsEventButton btnEvent_#Code#" style="#vBg#" onclick="selectEvent('#Code#', '#vBg#');">
		<cfif trim(EventMission.MenuImagePath) neq "">
			<img src="#session.root#/#trim(EventMission.MenuImagePath)#" style="height:500px; width:auto;">
		<cfelse>
			<i class="fal fa-file-alt" style="font-size:140%; color:##FAFAFA;"></i>
		</cfif>
		<div style="font-size:75%; padding-top:10px; color:##FAFAFA;">#Description#</div>
		<cfif trim(ActionInstruction) neq "">
			<div style="font-size:50%; padding-top:5px;">#ActionInstruction#</div>
		</cfif>
	</div>
</cfoutput>