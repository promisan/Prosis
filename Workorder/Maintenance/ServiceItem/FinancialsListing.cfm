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

<cfoutput>

<cfform action="FinancialsSubmit.cfm?id1=#url.id1#" method="post" name="editformFinancials">

<table width="99%" align="center" class="formpadding navigation_table">

<tr><td height="15"></td></tr>

	<tr class="labelmedium2 line fixlengthlist">
	  <td><cf_tl id="Entity">;</td>
	  
	  <td>
		  <table><tr>
			  <td align="center" style="width:25px;cursor:pointer" title="Operational">O</td>
			  <td align="center" style="width:25px;cursor:pointer" title="Show Expired Lines">S</td>
			  <td align="center" style="cursor:pointer" title="Expiration Days">Exp.Days</td>
		  </tr>
		  </table>
	  </td>
	  
	  <td style="cursor:pointer" title="Expiration Days">Journal</td>
	  <td style="cursor:pointer" title="Set how invoice is submitted"><cf_tl id="Invoice mode"></td>
	  <td style="cursor:pointer" title="eMail address"><cf_tl id="e-mail"></td>
	  <td style="cursor:pointer" align="right"><cf_tl id="Created"></td>
	
	</tr>	
	<tr class="labelit line fixlengthlist" style="background-color:f1f1f1">		
	  <td></td> 	 
	  <td style="cursor:pointer" title="Define the date charges will be recalculated for this services for each batch run">Charges Calculate</td>
	  <td style="cursor:pointer" title="Define the date as of which financial posting should commence for this service">Posting Start</td>
	  <td style="cursor:pointer" title="Define the date as of which financial posting should calculate for this service">Posting Calculate</td>
	  <td style="cursor:pointer" title="Define the date as of which portal tagging should commence for this service">Portal date</td>
	  <td style="cursor:pointer" align="center">Posting Details</td>
	</tr>
		
	 <cfquery name="Mis" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission	
		WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
	</cfquery>
	
	<cfloop query="Mis">
			
		<cfquery name="getMission" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ServiceItemMission
			WHERE  ServiceItem = '#url.id1#'		
			AND    Mission = '#mission#'
		</cfquery>
			
		<tr class="navigation_row line fixlengthlist">
	     	<td class="labelmedium" height="27">#Mission#</td>	
			
			<td><table><tr>
		    <td align="center">
				<input type="Checkbox" class="radiol" name="#mission#_Operational" id="#mission#_Operational" <cfif GetMission.Operational eq "1">checked</cfif>>
			</td>
			
			<td align="center" style="padding-left:3px">	
				<input type="Checkbox" class="radiol" name="#mission#_ShowExpiredLines" id="#mission#_ShowExpiredLines" <cfif GetMission.SettingShowExpiredLines eq "1">checked</cfif>>
			</td>
			
			<td align="center">
			
				<cfinput type="Text" 
					name="#mission#_DaysExpiration" 
	                id="#mission#_DaysExpiration"
					value="#getMission.SettingDaysExpiration#" 
					required="No" 
					message="Please, enter a valid positive integer for expiration days for #mission#." 
					size="1" 
					maxlength="3" 
					validate="integer" 
					range="0," 
					class="regularxl" 
					style="text-align:center;">
			</td>
			
			</tr></table></td>
			
			<td> 
						
			 <cfquery name="getJournal" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM Journal
					WHERE Mission = '#mission#'			
				</cfquery>
				
				<select name="#mission#_Journal" id="#mission#_Journal" style="width:250px"  class="regularxl">
			        <option value="">[<cf_tl id="undefined">]</option>
					<cfloop query="getJournal">
					<option value="#Journal#" <cfif getJournal.journal eq journal>selected</cfif>>#Journal# #Description#</option>
					</cfloop>
			
				</select>
								   	
			</td>
			
			<td>
			
			    <select name="#mission#_InvoiceMode" id="#mission#_InvoiceMode" style="width:150px"  class="regularxl">
			        <option value="0"><cf_tl id="manual"></option>
					<option value="1" <cfif getMission.InvoiceMode eq "1">selected</cfif>><cf_tl id="Direct"></option>								
				</select>
			
			
			</td>
			
			<td>
						
				<cfinput type="Text" 
					name="#mission#_eMailAddress" 	                
					value="#getMission.eMailAddress#" 
					required="No" 
					message="Default eMail address to be used for sending." 
					size="25" 
					maxlength="50" 					
					class="regularxl">
					
			</td>
			
			<td align="right">#dateformat(getMission.created,client.dateformatshow)#</td>
			
			</tr>
			
			<tr class="line labelmedium2 fixlengthlist" style="background-color:f1f1f1">
			
				<td style="background-color:e1e1e1;padding-left:10px;border-right:1px solid silver"><cf_tl id="Batch billing"></td>
				
				<td>			
				
					<cf_intelliCalendarDate9
					FieldName="#mission#_DateChargesCalculate"
					Tooltip="Define the date charges will be recalculated for this services for each batch run"
					Message="Select a valid Charges Calc. Date"
					class="regularxl"
					Default="#dateformat(getMission.DateChargesCalculate, CLIENT.DateFormatShow)#"
					AllowBlank="True">
					
				</td>
				
				<td>
				
					<cf_intelliCalendarDate9
					FieldName="#mission#_DatePostingStart"
					Tooltip="Define the date as of which financial posting should commence for this service"
					Message="Select a valid Posting Calc. Date"
					class="regularxl"
					Default="#dateformat(getMission.DatePostingStart, CLIENT.DateFormatShow)#"
					AllowBlank="True">
					
				</td>
				
				<td>
				
					<cf_intelliCalendarDate9
					FieldName="#mission#_DatePostingCalculate"
					Tooltip="Define the date as of which financial posting should calculate for this service"
					Message="Select a valid Posting Calc. Date"
					class="regularxl"
					Default="#dateformat(getMission.DatePostingCalculate, CLIENT.DateFormatShow)#"
					AllowBlank="True">
					
				</td>
				
				<td>
				
					<cf_intelliCalendarDate9
					FieldName="#mission#_DatePortalProcessing"
					Tooltip="Define the date as of which portal tagging should commence for this service"
					Message="Select a valid Portal Proc. Date"
					class="regularxl"
					Default="#dateformat(getMission.DatePortalProcessing, CLIENT.DateFormatShow)#"
					AllowBlank="True">
					
				</td>
				
				<td align="center">
					<table width="100%" align="center">
						<tr>
							<td align="right" width="99%" class="labelit">
								<cf_securediv id="detailMissionPosting_#mission#"  bind="url:Financials_MissionPosting.cfm?id1=#url.id1#&id2=#mission#">
							</td>
							<td style="padding-left:4px">							
								<img src="#SESSION.root#/Images/addline.png" 
								style="cursor: pointer;" title="Add Mission Postings" width="13" height="14" border="0" align="absmiddle" 
								onClick="javascript: addMissionPosting('#url.id1#', '#mission#');"	>	
							</td>
						</tr>
					</table>			
				</td>	
				
			</tr>
		
			
	</cfloop>
	
	<tr><td height="5"></td></tr>		
		
	
	<tr>
	<td colspan="10" align="center" height="36">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">	
	</td>
	</tr>
		
</tr>
</table>

</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")>
<cfset ajaxonload("doHighlight")>