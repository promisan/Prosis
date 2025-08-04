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
						WHERE  EventTrigger = '#url.triggercode#'
						AND    ActionImpact = 'Action')
		<cfif URL.mission neq "">
		AND    Code IN (SELECT PersonEvent 
			            FROM   Ref_PersonEventMission 
						WHERE  Mission  = '#URL.mission#')
		</cfif>		
		<cfif url.portal eq "1">
		AND    EnablePortal = 1
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
		<div style="font-size:60%; padding-top:10px; color:##FAFAFA;">#Description#</div>
		<!---
		<cfif trim(ActionInstruction) neq "">
			<div style="font-size:50%; padding-top:5px;">#ActionInstruction#</div>
		</cfif>
		--->
	</div>
</cfoutput>