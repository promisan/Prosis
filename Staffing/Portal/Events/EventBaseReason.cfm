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
<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code    = '#URL.event#'		
</cfquery>		

<cfquery name="EventMission" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_PersonEventMission
		WHERE  	PersonEvent	= '#URL.event#'	
		AND		Mission = '#url.mission#'	
		AND 	EnablePortal = '1'
</cfquery>

<cfquery name="qEvent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ReasonCode
		FROM   Ref_PersonEventTrigger
		WHERE  EventCode    = '#URL.event#'
		AND    EventTrigger = '#URL.trigger#'
</cfquery>		 

<cfquery name="qReasons" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   GroupCode, 
				 GroupListCode, 
				 (	SELECT   count(*)
					FROM     PersonEvent
					WHERE    PersonNo       = '#url.id#' 
					AND      Mission        = '#url.mission#' 	
					AND      EventTrigger   = '#url.trigger#' 
					AND      EventCode      = '#url.event#'
					AND      ReasonCode     = '#qEvent.ReasonCode#'
					-- AND   ReasonListCode = GroupListCode
					AND      ActionStatus < '3'	) as Active,				 
				 Description, 
				 GroupListMemo,
				 GroupListImagePath,
				 GroupListOrder, 
				 Operational, 
				 Created
		FROM     Ref_PersonGroupList L
		WHERE 	 GroupCode   = '#qEvent.ReasonCode#' 
		AND      Operational = '1'
		ORDER BY GroupListOrder
</cfquery>	

<div class="clsInstruction" style="padding-left:6px;padding-right:10px;font-size:34px">
	<cf_tl id="#Event.Description#">	
</div>		
		
<cfif trim(eventMission.Instruction) neq "">
	<cfoutput>
		<div class="clsInstruction" style="padding:10px">
			#eventMission.Instruction#
		</div>
	</cfoutput>
</cfif>

<div class="row">
	<cfoutput query="qReasons">
	
		<cfset url.ajaxid = "evt_#GroupListCode#">		
		
		<div class="col-lg-12">
			<div class="clsEventButtonReason btnReason_#GroupListCode#" 
			     onclick="<cfif active eq '0'>selectReason('#url.id#','#url.mission#','#url.trigger#', '#url.event#', '#GroupCode#', '#GroupListCode#','#url.ajaxid#');</cfif>">
				<div style="float:left; width:10%; text-align:center; padding-top:10px; padding-bottom:10px;">
					<cfif trim(GroupListImagePath) neq "">
						<img src="#session.root#/#trim(GroupListImagePath)#" style="height:100px; width:auto;">
					<cfelse>
						<i class="fal fa-file-alt" style="font-size:600%;"></i>
					</cfif>
				</div>			
				
				 <input type="hidden" 
					   name="workflowlink_#url.ajaxid#" 
					   id="workflowlink_#url.ajaxid#" 		   
					   value="EventBaseReasonWorkflow.cfm">		
										
				 <input type="hidden" 
					   name="workflowcondition_#url.ajaxid#" 
					   id="workflowcondition_#url.ajaxid#" 		   
					   value="?mission=#url.mission#&personno=#url.id#&trigger=#url.trigger#&eventcode=#url.event#&reasoncode=#groupcode#&reasonlistcode=#grouplistcode#&ajaxid=#url.ajaxid#">	
				
				
				<div style="float:left; width:85%; text-align:left; padding-bottom:10px;">
					<div style="font-size:150%; padding-top:10px;">#trim(Description)#</div>
					<div style="font-size:125%; color:##808080; padding-top:5px;">#trim(GroupListMemo)#</div>
					<div style="font-size:125%; color:##808080; padding-top:5px;">
					
					<cfif active eq "0">
					
						<cfdiv id="#url.ajaxid#">					
					
					<cfelse>
																									
						<cf_securediv id="#url.ajaxid#" 
							bind="url:#session.root#/staffing/portal/events/EventBaseReasonWorkflow.cfm?mission=#url.mission#&personno=#url.id#&trigger=#url.trigger#&eventcode=#url.event#&reasoncode=#groupcode#&reasonlistcode=#grouplistcode#&ajaxid=#url.ajaxid#">
						
					</cfif>	
					
					</div>
				</div>
			</div>
		</div>
	</cfoutput>
	
</div>