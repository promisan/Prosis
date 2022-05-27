<cfparam name="URL.eventid" default="">
<cfparam name="URL.preason" default="">
<cfparam name="URL.mission" default="">
<cfparam name="URL.eventCode" default="">
<cfparam name="URL.triggerCode" default="">

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


<cfquery name="getInstruction" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission 
		WHERE  PersonEvent    = '#url.eventcode#'
		AND    Mission = '#url.mission#'			
</cfquery>

<cfif getInstruction.Instruction neq "">

  <script>  
	  ptoken.navigate('#session.root#/Staffing/Application/Employee/Events/getInstruction.cfm?eventcode=#url.eventcode#&mission=#url.mission#','myinstruction')
  </script>
  
 <cfelse>
 
 	<script>
		document.getElementById('myinstruction').innerHTML = ""
	</script> 

</cfif>

</cfoutput>

<cfif qReasons.recordcount neq 0>

    <script>
   	  document.getElementById("reasonbox").className = "labelmedium"
    </script>
    
	<cfoutput>
			
		<select name="reasoncode" id="reasoncode" class="regularxxl" style="width:95%">
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