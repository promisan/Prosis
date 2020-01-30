<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	Position
		WHERE 	PositionNo = '#url.positionNo#'
</cfquery>

<cfquery name="WorkSchedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	WorkSchedule
		WHERE 	Code = '#url.workSchedule#'
</cfquery>

<cf_tl id="Replace Work Schedule" var="vTitle">
<cf_tl id="Replace schedule for tasks for" var="vOption">

<cf_screentop height="100%"
	scroll="yes" 
	bannerheight="60" 
	jQuery="Yes"
	label="#vTitle#" 
	option="#vOption# #url.positionNo# - #WorkSchedule.Description#" 
	layout="webapp" 
	user="no"
	banner="blue">

<cfoutput>
	<script>
		function editWorkOrderLineSchedule(id, mode) {
			w = #CLIENT.width# - 60;
	        h = #CLIENT.height# - 130;
			window.open("#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleEdit.cfm?mode="+mode+"&scheduleid=" + id, "WorkOrderLineSchedule", "left=20, top=20, width="+w+"px, height="+h+"px, status=yes, toolbar=yes, scrollbars=no, resizable=yes");
		}
	</script>
</cfoutput>

<table class="hide">
	<tr><td><iframe name="processReplaceWorkSchedule" id="processReplaceWorkSchedule"></iframe></td></tr>
</table>

<cfform name="frmReplaceWorkSchedule" method="POST" action="#session.root#/Staffing/Application/WorkSchedule/Position/ReplaceWorkScheduleSubmit.cfm?positionNo=#url.positionNo#&positionParentId=#url.positionParentId#&workSchedule=#url.workSchedule#" target="processReplaceWorkSchedule">

	<cfoutput>
		<table width="98%" align="center" class="formpadding">
		 
			<tr>
				<td width="15%" class="labelmedium"><cf_tl id="Original">:</td>
				<td class="labellarge">
					#WorkSchedule.description#
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			
			<tr>
				<td class="labelmedium"><cf_tl id="New">:</td>
				<td class="labellarge">
					<cfquery name="WorkScheduleList" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT 	W.*
						    FROM 	WorkSchedule W
							WHERE 	W.Code <> '#url.workSchedule#'
							AND		EXISTS
									(
										SELECT 	'X'
										FROM	WorkScheduleOrganization
										WHERE	WorkSchedule = W.Code
										AND		OrgUnit = (SELECT OrgUnitOperational FROM Position WHERE PositionNo = '#url.positionNo#')
									)
					</cfquery>
					
					<cfselect 
						name="newSchedule" 
						id="newSchedule" 
						query="WorkScheduleList" 
						queryposition="below" 
						value="code" 
						display="description" 
						class="regularxl" 
						required="Yes"
						message="Please, select a valid work schedule">
							<option value="">
					</cfselect>
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			
			<tr>
				<td colspan="2" class="labelmedium"><cf_tl id="Assigned Tasks">:</td>
			</tr>
			<tr><td colspan="2" class="linedotted"></td></tr>
			<tr><td height="5"></td></tr>
			
			<cf_verifyOperational module="WorkOrder" Warning="No">
			
			<cfif operational eq 1>
			<tr>
				<td colspan="2">
					<cfdiv id="divDetail" bind="url:#session.root#/Staffing/Application/WorkSchedule/Position/ReplaceWorkScheduleDetail.cfm?positionNo=#url.positionNo#&workSchedule={newSchedule}&fromWorkSchedule=#url.workSchedule#">
				</td>
			</tr>
			</cfif>
			
			<tr><td height="5"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="5"></td></tr>
			
			<tr>
				<td colspan="2" align="center">
					<cf_tl id="Replace" var="vVal">
					<cf_tl id="This action will replace the work schedule for the position and the selected tasks. Continue?" var="vMes">
					<input type="Submit" class="button10g" style="width:120px;height:25px" name="submit" id="submit" value="#vVal#" onclick="if(confirm('#vMes#')){ return true; }else{ return false; }">
				</td>
			</tr>
			
		</table>
	</cfoutput>

</cfform>