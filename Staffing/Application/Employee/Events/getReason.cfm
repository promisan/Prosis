<cfparam name="URL.eventid" default="">
<cfparam name="URL.preason" default="">

<cfif URL.eventId neq "">

	<cfquery name="qCurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  EventId = '#URL.eventId#'
	</cfquery>		 

<cfelse>

	<cfquery name="qCurrentEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  1=0
	</cfquery>	
		
</cfif>	

<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code    = '#URL.eventcode#'		
</cfquery>		

<cfquery name="qEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ReasonCode
		FROM   Ref_PersonEventTrigger
		WHERE  EventCode    = '#URL.eventcode#'
		AND    EventTrigger = '#URL.triggercode#'
</cfquery>		 

<cfquery name="qReasons" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   GroupCode, 
				 GroupListCode, 
				 Description, 
				 GroupListOrder, 
				 Operational, 
				 Created
		FROM     Ref_PersonGroupList
		WHERE 	 GroupCode   = '#qEvent.ReasonCode#' 
		AND      Operational = '1'
		ORDER BY GroupListOrder
</cfquery>		

<cfoutput>

<script language="JavaScript">

    <!--- set label --->
	document.getElementById('actiondatelabeleffective').innerHTML = '#event.ActionPeriodLabel#'
	document.getElementById('actiondatelabelexpiration').innerHTML = '#event.ActionPeriodLabel#'
	
	<!--- show/hide expiration --->
	<cfif Event.ActionPeriod eq "1">
	   		document.getElementById("expirybox").className = "labelmedium"   
	<cfelse>
			document.getElementById("expirybox").className = "hide" 	
	</cfif>
	
	<!--- show/hide unit/position --->
		
	<cfif Event.ActionPosition eq "1">
	   		document.getElementById("positionbox").className = "labelmedium"   
			document.getElementById("unitbox").className     = "hide" 
	<cfelseif Event.ActionPosition eq "0">		
			document.getElementById("positionbox").className = "hide" 	
			document.getElementById("unitbox").className     = "labelmedium" 
	<cfelse>
			document.getElementById("positionbox").className = "hide" 	
			document.getElementById("unitbox").className     = "hide" 
	</cfif>

</script>

</cfoutput>

<cfif qReasons.recordcount neq 0>

    <script>
   	  document.getElementById("reasonbox").className = "labelmedium"
    </script>
    
	<cfoutput>
			
		<select name="reasoncode" id="reasoncode" class="regularxl" style="width:95%">
			<cfloop query="qReasons">
				<option value="#GroupListCode#" <cfif qCurrentEvent.ReasonListCode eq GroupListCode OR GroupListCode eq url.preason>selected</cfif>>#GroupListCode#-#Description#</option>
			</cfloop>
		<select>			
		<input type="hidden" id="GroupCode" name="GroupCode" value="#qEvent.ReasonCode#">
		
	</cfoutput>
	
<cfelse>

   <script>
   	document.getElementById("reasonbox").className = "hide"	
   </script>
   
	N/A
	<input type="hidden" id="reasoncode" name="reasoncode" value="">
	<input type="hidden" id="GroupCode"  name="GroupCode"  value="">

</cfif>	