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
		SELECT *
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
		WHERE 	 GroupCode   = '#qEvent.ConditionCode#' 
		AND      Operational = '1'
		ORDER BY GroupListOrder
</cfquery>	


<cfif qReasons.recordcount neq 0>

    <script>
   	  document.getElementById("conditionbox").className = "labelmedium"
    </script>
    
	<cfoutput>
			
		<select name="conditioncode" id="conditioncode" class="regularxxl" style="width:95%">
			<cfloop query="qReasons">
				<option value="#GroupListCode#" <cfif qCurrentEvent.Contractno eq GroupListCode OR GroupListCode eq URL.preason>selected</cfif>>#Description#</option>
			</cfloop>
		<select>			
		<input type="hidden" id="GroupConditionCode" name="GroupConditionCode" value="#qEvent.ConditionCode#">
		
	</cfoutput>
	
<cfelse>

   <script>
   	document.getElementById("conditionbox").className = "hide"	
   </script>
   
	N/A
	<input type="hidden" id="conditioncode" name="conditioncode" value="">
	<input type="hidden" id="GroupConditionCode"  name="GroupConditionCode"  value="">

</cfif>	


