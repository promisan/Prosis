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

<!--- form of events --->

<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code    = '#URL.event#'		
</cfquery>		

<cfquery name="Reason" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PersonGroupList
		WHERE 	 GroupCode     = '#url.Reason#'
		AND      GroupListCode = '#url.ReasonList#' 				
</cfquery>	

<cfquery name="check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  PersonNo, PositionNo, DateEffective, DateExpiration, OrgUnit
		FROM    PersonAssignment
	    WHERE   PersonNo >= '#url.personno#' 
		AND     AssignmentStatus IN ('0', '1') 
		AND     DateEffective     <  GETDATE() 
		AND     DateExpiration    >= GETDATE()-90
		AND     Incumbency > 0 
		AND     PositionNo IN (SELECT   PositionNo
	                           FROM     Position
	                           WHERE    Mission = '#url.mission#')
		ORDER BY DateExpiration DESC
</cfquery>

<cfoutput>

<cfform method="POST" name="eventform">
	
	<input type="hidden" name="Mission"     value="#url.Mission#">
	<input type="hidden" name="PersonNo"    value="#url.personNo#">
	<input type="hidden" name="Trigger"     value="#url.Trigger#">
	<input type="hidden" name="EventCode"   value="#url.Event#">
	<input type="hidden" name="Reason"      value="#url.Reason#">
	<input type="hidden" name="ReasonList"  value="#url.ReasonList#">
	<input type="hidden" name="PositionNo"  value="#check.positionno#">
	<input type="hidden" name="OrgUnit"     value="#check.orgunit#">

	<table style="width:90%" align="center" class="formpadding formspacing">
		
		<tr class="labelmedium"><td colspan="2" style="font-size:26px;font-weight:bold">#Event.Description# :<span style="font-weight:normal"> #Reason.Description#</td></tr>		
		<tr class="labelmedium"><td colspan="2" style="height:10px"></td></tr>
		<tr class="labelmedium"><td colspan="2" style="font-size:17px">#Reason.GroupListMemo#</td></tr>
			
		<tr><td style="height:20px"></td></tr>
		
		<tr></tr>
				
		<tr class="labelmedium">					
			<td style="font-size:17px;" colspan="2">I would like to request #Reason.Description# for the period:</td>
		</tr>	
		
		<cfif check.recordcount eq "0">
		
			<tr id="">					
			
				<td style="font-size:17px;padding-left:13px" width="25%"><cf_tl id="Alert">:</td>
				<td style="padding-left:10px">
						
					<font color="FF0000">No active post assignment found for you in #url.mission#.</font>
								
				</td>					  
			</tr>
		
		<cfelse>
		
			<tr><td style="height:20px"></td></tr>
					
			<tr class="labelmedium">
						
				<td style="font-size:17px;padding-left:13px" width="25%">#Event.ActionperiodLabel#<cf_tl id="Effective">:</td>
				<td style="padding-left:10px">
													
					<cf_space spaces="38">					
																
					<cf_intelliCalendarDate9
						FieldName="ActionDateEffective" 
						Default=""
						AllowBlank="True"
						Class="regularxxl">
						
				</td>
						  
			</tr>
				
			<tr id="expirybox">					
			
				<td style="font-size:17px;padding-left:13px" width="25%">#Event.ActionperiodLabel#<cf_tl id="Expiration">:</td>
				<td style="padding-left:10px">
						
					<cf_space spaces="38">	
																				
					<cf_intelliCalendarDate9
						FieldName="ActionDateExpiration" 
						Default=""
						AllowBlank="True"
						Class="regularxxl">
								
				</td>					  
			</tr>
				
			<tr><td style="height:20px"></td></tr>		
			
			<tr class="line"><td colspan="2"></td></tr>
			
			<tr><td style="height:10px"></td></tr>
			
			<tr><td id="process" colspan="2" align="center" style="padding-left:10px">
			<input class="button10g" style="font-size:17px;width:230px;height:33px" onclick="eventreasonsubmit('#url.ajaxid#')" type="button" name="Submit" value="Initiate request"></td>
			</tr>
			
		</cfif>	
		
	</table>

</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")>

