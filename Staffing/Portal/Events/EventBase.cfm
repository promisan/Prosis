<cfparam name="URL.eventcode" 	default="">

<cfif trim(url.eventcode) eq "">

	<div style="text-align:center;">
		<h2>[ <cf_tl id="Select a request type"> ]</h2>
	</div>
	
<cfelse>

	<cfquery name="Event" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PersonEvent
			WHERE  Code    = '#URL.eventcode#'		
	</cfquery>		
	
	<cfquery name="EventMission" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	Ref_PersonEventMission
			WHERE  	PersonEvent	= '#URL.eventcode#'	
			AND		Mission = '#url.mission#'	
			AND 	EnablePortal = '1'
	</cfquery>	
	
	<cfif EventMission.ReasonMode eq "dialog">

		<cf_securediv id="divEventDetail" bind="url:#session.root#/staffing/portal/events/EventBaseDialog.cfm?scope=portal&id=#url.personno#&mission=#url.mission#&event=#url.eventcode#&trigger=#url.triggercode#" style="height:100%">
		
	<cfelse>
	
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
						 GroupListMemo,
						 GroupListImagePath,
						 GroupListOrder, 
						 Operational, 
						 Created
				FROM     Ref_PersonGroupList
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
				<div class="col-lg-12">
					<div class="clsEventButtonReason btnReason_#GroupListCode#" onclick="selectReason('#url.personno#','#url.mission#','#url.triggercode#', '#url.eventcode#', '#GroupListCode#');">
						<div style="float:left; width:10%; text-align:center; padding-top:10px; padding-bottom:10px;">
							<cfif trim(GroupListImagePath) neq "">
								<img src="#session.root#/#trim(GroupListImagePath)#" style="height:100px; width:auto;">
							<cfelse>
								<i class="fal fa-file-alt" style="font-size:600%;"></i>
							</cfif>
						</div>
						<div style="float:left; width:85%; text-align:left; padding-bottom:10px;">
							<div style="font-size:150%; padding-top:10px;">#trim(Description)#</div>
							<div style="font-size:125%; color:##808080; padding-top:5px;">#trim(GroupListMemo)#</div>
						</div>
					</div>
				</div>
			</cfoutput>
			<cfif qReasons.recordCount eq 0>
				<cfoutput>
					<div class="col-lg-12">
						<div class="clsEventButtonReason btnReason_" onclick="selectReason('#url.personno#','#url.mission#','#url.triggercode#', '#url.eventcode#', '');">
							<div style="float:left; width:10%; text-align:center; padding-top:10px; padding-bottom:10px;">
								<i class="fal fa-file-alt" style="font-size:600%;"></i>
							</div>
							<div style="float:left; width:85%; text-align:left; padding-bottom:10px;">
								<div style="font-size:150%; padding-top:10px;"><cf_tl id="Make a request for"> #event.description#</div>
							</div>
						</div>
					</div>
				</cfoutput>
			</cfif>
		</div>
		
	</cfif>

</cfif>
