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
	document.getElementById('actiondatelabeleffective').innerHTML  = '#event.ActionPeriodLabel#'
	document.getElementById('actiondatelabelexpiration').innerHTML = '#event.ActionPeriodLabel#'
		
	<!--- show/hide expiration --->
	<cfif Event.ActionPeriod eq "1">	        
	   		document.getElementById("expirybox").className = "labelmedium"   
			document.getElementById("effectivebox").className = "labelmedium"
	<cfelse>
			document.getElementById("expirybox").className = "hide" 	
			document.getElementById("effectivebox").className = "hide"
	</cfif>
	
	<!--- show/hide unit/position --->
		
	<cfif Event.ActionPosition eq "1">
	   		document.getElementById("positionbox").className = "labelmedium"   
			document.getElementById("unitbox").className     = "hide" 
	<cfelseif Event.ActionPosition eq "0">		
			document.getElementById("positionbox").className = "hide" 	
			<cfif url.portal eq "0">
			document.getElementById("unitbox").className     = "labelmedium" 
			</cfif>
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

<script>
  ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getCondition.cfm?triggercode=#url.triggercode#&eventcode=#url.eventcode#&eventid=#url.eventid#&preason=','dCondition');
</script>

<cfif getInstruction.SubmissionMode eq "0">
 
   <script>
   try {
    document.getElementById('submitform').className    = 'hide'   
    document.getElementById('boxremarks').className    = 'hide'  
    document.getElementById('boxpriority').className   = 'hide'  
    document.getElementById('boxattachment').className = 'hide'
   } catch(e) {}
   </script>

<cfelse>

   <script>
    try { 
      document.getElementById('submitform').className    = 'regular'
      document.getElementById('boxremarks').className    = 'labelmedium2'
      document.getElementById('boxpriority').className   = 'labelmedium2'
      document.getElementById('boxattachment').className = 'regular'
	  } catch(e) {}
	  
   </script>
   
</cfif>


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
	
	 <!--- #GroupListCode# --->
			
		<select name="reasoncode" id="reasoncode" class="regularxxl" style="width:95%">
			<cfloop query="qReasons">
				<option value="#GroupListCode#" <cfif qCurrentEvent.ReasonListCode eq GroupListCode OR GroupListCode eq url.preason>selected</cfif>>#Description#</option>
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

