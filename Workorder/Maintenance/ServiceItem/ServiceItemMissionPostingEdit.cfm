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

<cfif url.id3 eq "">
	<cf_screentop height="100%" label="Posting Period" option="Add a Posting Period" scroll="Yes" layout="webapp" user="no">
<cfelse>
	<cfset vyear = mid(url.id3, 1, 4)>
	<cfset vmonth = mid(url.id3, 6, 2)>
	<cfset vday = mid(url.id3, 9, 2)>
	
	<cfset vSelectionDate = createDate(vyear, vmonth, vday)>
	<cf_screentop height="100%" label="Service Item Mission Posting" option="Maintain #url.id1# - #url.id2# - #Dateformat(vSelectionDate, '#CLIENT.DateFormatShow#')#" scroll="Yes" layout="webapp" banner="yellow" user="no">
</cfif>

<cf_calendarscript>

<cfquery name="getMissionPosting" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItemMissionPosting
		WHERE  ServiceItem = '#url.id1#'		
		AND    Mission = '#url.id2#'
		
		<cfif url.id3 neq "">AND	SelectionDateExpiration = #vSelectionDate#<cfelse>AND 1 = 0</cfif>
		ORDER BY SelectionDateExpiration DESC
</cfquery>

<cfoutput>

<table class="hide">
	<tr ><td><iframe name="processMissionPostingEdit" id="processMissionPostingEdit" frameborder="0"></iframe></td></tr>	
</table>

<cfform method="post" action="ServiceItemMissionPostingSubmit.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#" 
  name="editformMissionPostingEdit" 
  target="processMissionPostingEdit">

<table width="90%" align="center" class="formpadding formspacing">

	<tr><td height="20"></td></tr>
	
	<tr>
		<td width="25%" height="25" class="labelmedium">Date Effective:</td>
		<td class="labelmedium">
			<cfif url.id3 eq "">
				
				<cfquery name="getLastPeriod"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   	SELECT 	Mission, ServiceItem, MAX(SelectionDateExpiration) as SelectionDate
					FROM 	ServiceItemMissionPosting
					WHERE 	ServiceItem	= '#url.id1#'
					AND		Mission = '#url.id2#'
					GROUP BY Mission, ServiceItem
					ORDER BY Mission, ServiceItem
				</cfquery>
				
				<cfif getLastPeriod.recordCount gt 0>
				
					<cfset sugestedPeriod = dateAdd("d",1,getLastPeriod.selectionDate)>
					
				<cfelse>
					
					<cfquery name="getItemMission"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT 	DatePostingCalculate
						FROM 	ServiceItemMission
						WHERE 	ServiceItem	= '#url.id1#'
						AND		Mission = '#url.id2#'						
					</cfquery>
				
					<cfif getItemMission.DatePostingCalculate neq "">
						
						<cfset auxPeriod = createDate(datePart("yyyy",getItemMission.DatePostingCalculate), datePart("m",getItemMission.DatePostingCalculate), 1)>
						<cfset sugestedPeriod = createDate(datePart("yyyy",getItemMission.DatePostingCalculate), datePart("m",getItemMission.DatePostingCalculate), datePart("d",dateAdd("d",-1,dateAdd("m",1,auxPeriod))))>
						
					<cfelse>
					
						<cfquery name="getParameterPosting"
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   	SELECT 	DatePostingCalculate
							FROM 	Ref_ParameterMission
							WHERE	Mission = '#url.id2#'
						</cfquery>
						
						<cfset auxPeriod = createDate(datePart("yyyy",getParameterPosting.DatePostingCalculate), datePart("m",getParameterPosting.DatePostingCalculate), 1)>
						<cfset sugestedPeriod = createDate(datePart("yyyy",getParameterPosting.DatePostingCalculate), datePart("m",getParameterPosting.DatePostingCalculate), datePart("d",dateAdd("d",-1,dateAdd("m",1,auxPeriod))))>
						
					</cfif>		
					
				</cfif>
				
				<cf_intelliCalendarDate9
					FieldName="SelectionDateEffective"
					Tooltip="Define the date posting date"
					Message="Select a valid Selection Date"
					class="regularxl"
					Default="#dateformat(sugestedPeriod, CLIENT.DateFormatShow)#"
					AllowBlank="False">
					
			<cfelse>
				#dateformat(getMissionPosting.SelectionDateEffective, CLIENT.DateFormatShow)#
				<input type="Hidden" name="SelectionDateEffective" id="SelectionDateEffective" value="#dateformat(getMissionPosting.SelectionDateEffective, CLIENT.DateFormatShow)#">
			</cfif>		
		</td>
	</tr>	
	
	<tr>
		<td width="25%" class="labelmedium" height="25">Date Expiration:</td>
		<td class="labelmedium">
		
			<cfif url.id3 eq "">
				
				<cfquery name="getLastPeriod"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   	SELECT 	Mission, ServiceItem, MAX(SelectionDateExpiration) as SelectionDate
					FROM 	ServiceItemMissionPosting
					WHERE 	ServiceItem	= '#url.id1#'
					AND		Mission = '#url.id2#'
					GROUP BY Mission, ServiceItem
					ORDER BY Mission, ServiceItem
				</cfquery>
				
				<cfif getLastPeriod.recordCount gt 0>
				
					<cfset auxPeriod = createDate(datePart("yyyy",dateAdd("m",1,getLastPeriod.selectionDate)), datePart("m",dateAdd("m",1,getLastPeriod.selectionDate)), 1)>
					<cfset sugestedPeriod = createDate(datePart("yyyy",auxPeriod), datePart("m",auxPeriod), datePart("d",dateAdd("d",-1,dateAdd("m",1,auxPeriod))))>
					
				<cfelse>
					
					<cfquery name="getItemMission"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT 	DatePostingCalculate
						FROM 	ServiceItemMission
						WHERE 	ServiceItem	= '#url.id1#'
						AND		Mission = '#url.id2#'						
					</cfquery>
				
					<cfif getItemMission.DatePostingCalculate neq "">
						
						<cfset auxPeriod = createDate(datePart("yyyy",getItemMission.DatePostingCalculate), datePart("m",getItemMission.DatePostingCalculate), 1)>
						<cfset sugestedPeriod = createDate(datePart("yyyy",getItemMission.DatePostingCalculate), datePart("m",getItemMission.DatePostingCalculate), datePart("d",dateAdd("d",-1,dateAdd("m",1,auxPeriod))))>
						
					<cfelse>
					
						<cfquery name="getParameterPosting"
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   	SELECT 	DatePostingCalculate
							FROM 	Ref_ParameterMission
							WHERE	Mission = '#url.id2#'
						</cfquery>
						
						<cfset auxPeriod = createDate(datePart("yyyy",getParameterPosting.DatePostingCalculate), datePart("m",getParameterPosting.DatePostingCalculate), 1)>
						<cfset sugestedPeriod = createDate(datePart("yyyy",getParameterPosting.DatePostingCalculate), datePart("m",getParameterPosting.DatePostingCalculate), datePart("d",dateAdd("d",-1,dateAdd("m",1,auxPeriod))))>
						
					</cfif>		
					
				</cfif>
				
				<cf_intelliCalendarDate9
					FieldName="SelectionDate"
					Tooltip="Define the date posting date"
					Message="Select a valid Selection Date"
					class="regularxl"
					Default="#dateformat(sugestedPeriod, CLIENT.DateFormatShow)#"
					AllowBlank="False">
					
			<cfelse>
				#dateformat(vSelectionDate, CLIENT.DateFormatShow)#
				<input type="Hidden" name="SelectionDate" id="SelectionDate" value="#dateformat(vSelectionDate, CLIENT.DateFormatShow)#">
			</cfif>		
		</td>
	</tr>

	<tr>
		<td width="25%" class="labelmedium" height="25">Cut-off Date:</td>
		<td>
			<cfif url.id3 neq "">
				<cfset sugestedPeriod = vSelectionDate>
			</cfif>
				
			<cf_intelliCalendarDate9
				FieldName="CutOffDate"
				Tooltip="Define the date cut-off date"
				Message="Select a valid cut-off Date"
				class="regularxl"
				Default="#dateformat(sugestedPeriod, CLIENT.DateFormatShow)#"
				AllowBlank="False">
				
		</td>
	</tr>


	<tr>
		<td class="labelmedium">Action Status:</td>
		<td class="labelmedium">
			<cfif url.id3 neq "">
			
				<cfquery name="validateStatus" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT DISTINCT ActionStatus
						FROM   ServiceItemMissionPosting
						WHERE  ServiceItem = '#url.id1#'		
						AND    Mission = '#url.id2#'
						AND	   SelectionDateExpiration < #vSelectionDate#
				</cfquery>
				
				<cfquery name="validateStatusMax" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT MAX(selectionDateExpiration) as MaxDate
						FROM   ServiceItemMissionPosting
						WHERE  ServiceItem = '#url.id1#'		
						AND    Mission = '#url.id2#'
						AND	   ActionStatus = '1'
				</cfquery>		
				
				<cfset showEdit = 0>
				
				<cfif validateStatus.recordCount eq 0 or (validateStatus.recordCount eq 1 and validateStatus.actionStatus eq "1")>
					<cfset showEdit = 1>
				</cfif>
				
				<cfif getMissionPosting.selectionDateExpiration eq validateStatusMax.maxDate>
					<cfset showEdit = 1>
				</cfif>				
								
				<cfif showEdit eq 1>
					<label><input type="radio" name="ActionStatus" id="ActionStatus" value="0" <cfif getMissionPosting.ActionStatus eq "0" or url.id3 eq "">checked</cfif>>Open</label>
					<label><input type="radio" name="ActionStatus" id="ActionStatus" value="1" <cfif getMissionPosting.ActionStatus eq "1">checked</cfif>>Closed</label>
				<cfelse>
					<label title="Close all prior postings before closing this one" style="cursor: pointer;"><b><cfif getMissionPosting.ActionStatus eq 0>Open<cfelseif getMissionPosting.ActionStatus eq 1>Closed</cfif></b></label>
					<input type="Hidden" name="ActionStatus" id="ActionStatus" value="#getMissionPosting.ActionStatus#">
				</cfif>
				
								
			<cfelse>
				<label><input type="radio" name="ActionStatus" id="ActionStatus" value="0" checked>Open</label>
				<label><input type="radio" name="ActionStatus" id="ActionStatus" value="1">Closed</label>
			</cfif>			
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium">Portal Processing:</td>
		<td class="labelmedium">
			<label><input type="radio" name="EnablePortalProcessing" id="EnablePortalProcessing" value="0" <cfif getMissionPosting.EnablePortalProcessing eq "0">checked</cfif>>Disabled</label>
			<label><input type="radio" name="EnablePortalProcessing" id="EnablePortalProcessing" value="1" <cfif getMissionPosting.EnablePortalProcessing eq "1" or url.id3 eq "">checked</cfif>>Enabled</label>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium">Batch Processing:</td>
		<td class="labelmedium">
			<label><input type="radio" name="EnableBatchProcessing" id="EnableBatchProcessing" value="0" <cfif getMissionPosting.EnableBatchProcessing eq "0" or url.id3 eq "">checked</cfif>>Disabled</label>
			<label><input type="radio" name="EnableBatchProcessing" id="EnableBatchProcessing" value="1" <cfif getMissionPosting.EnableBatchProcessing eq "1">checked</cfif>>Enabled</label>
		</td>
	</tr>	
	
	<tr><td height="15"></td></tr>		
	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="36">
	
	<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">	
	
	</td></tr>

</table>

</cfform>

</cfoutput>