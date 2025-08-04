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

<cfquery name="qEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ReasonCode
		FROM   Ref_PersonEventTrigger
		WHERE  EventTrigger = '#URL.triggercode#'
		AND    EventCode    = '#URL.eventcode#'   
</cfquery>		 

<cfquery name="qReasons" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  GroupCode, 
				GroupListCode, 
				Description, 
				GroupListOrder, 
				Operational, 
				Created
		FROM    Ref_PersonGroupList
		WHERE 	GroupCode = '#qEvent.ReasonCode#' AND Operational = '1'
		ORDER BY GroupListOrder
</cfquery>	

<cfoutput>	

<cfif qReasons.recordcount gte "1"> 
	
	<select name="reasoncode" id="reasoncode" class="regularxl">
		<cfloop query="qReasons">
			<option value="#GroupListCode#" <cfif url.ReasonListCode eq GroupListCode>selected</cfif>>#GroupListCode#-#Description#</option>
		</cfloop>
	<select>		
			
	<input type="hidden" id="Reason" name="Reason" value="#qEvent.ReasonCode#">
	
	<script>
	 document.getElementById('reasonbox').className = "labelmedium"
	</script>
	
<cfelse>

	<input type="hidden" id="GroupCode" name="GroupCode"   value="">
	<input type="hidden" id="Reason" name="Reason" value="">
	
	<script>
	 document.getElementById('reasonbox').className = "hide"
	</script>

</cfif>	

</cfoutput>