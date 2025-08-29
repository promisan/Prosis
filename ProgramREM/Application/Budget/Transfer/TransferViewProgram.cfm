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
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr class="hide">
	<td colspan="2" height="300" id="result"></td>
	</tr>
	
	<tr><td height="3"></td></tr>
	
	<tr><td>
	<table width="97%" cellspacing="0" align="center" class="formpadding">
	
	<cfoutput>
		<input type="hidden" name="program" id="program" value="#url.program#">
		<input type="hidden" id="contributionlineid" name="contributionlineid" value="">
	</cfoutput>
	
	<tr><td style="width:200px" class="labelmedium"><cf_tl id="Planning Period">:</td>
	<td>
	
	<table><tr><td>
	
	
	<cfquery name="Param" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'	 
	</cfquery>
	
	<cfquery name="Period" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Period
		WHERE  Period IN (SELECT Period 
		                  FROM   ProgramAllotment
						  WHERE  ProgramCode IN (SELECT ProgramCode 
						                         FROM   Program 
												 WHERE  Mission = '#URL.Mission#')
						 ) 	
		AND    Period = '#url.period#' 			 
	</cfquery>
	
	<cfoutput>
	<select name="period" id="period" class="regularxl"
	    onchange="ColdFusion.navigate('TransferDialogEdition.cfm?mission=#url.mission#&editionid=#url.editionid#&period='+this.value,'editionbox')">
		<cfloop query="period">
			<option value="#period#" <cfif url.period eq period>selected</cfif>>#Period#</option>
		</cfloop>
	</select>	
	</cfoutput>
	
	</td>
	
	<td style="padding-left:10px;min-width:120px" class="labelmedium"><cf_tl id="Select Edition">:</td>
	<td id="editionbox"><cfinclude template="TransferDialogEdition.cfm"></td>	
	
	
	<td style="padding-left:10px" class="labelmedium"><cf_tl id="Resource">:</td>
	<td style="padding-left:10px" id="resourcebox"><cfinclude template="TransferDialogResource.cfm"></td></tr>
		
	</tr></table>
	</td>
	</tr>
	
	<tr><td class="labelmedium" style="height:28px"><cf_tl id="Transaction Type">:</td>
		<td class="labelmedium" colspan="6">
		<input type="radio"  class="radiol" name="actionclasssel" id="actionclasssel" value="Transfer" checked onclick="document.getElementById('actionclass').value='Transfer';resetfrom();resetto()"> <cf_tl id="Transfer">
		<input type="radio"  class="radiol" name="actionclasssel" id="actionclasssel" value="Amendment" onclick="document.getElementById('actionclass').value='Amendment';resetfrom();resetto()"> <cf_tl id="Amendment">
		<input type="hidden" class="radiol" name="actionclass"    id="actionclass"    value="Transfer">	
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Transaction Date">:</td>
		<td colspan="6">
		
		<cf_calendarscript>
		
		<cf_intelliCalendarDate9
					FieldName="TransactionDate" 
					Manual="True"	
					class="regularxl"											
					Default="#dateformat(now(),client.dateformatshow)#"
					AllowBlank="False">	
		
		</td>
		</tr>
	
	<tr><td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Memo">:</td>
	<td colspan="6">
		<textarea totlength="150" class="regular" onkeyup="return ismaxlength(this)" name="Memo" id="Memo" style="font-size:13px;padding:3px;height:35;width:90%"></textarea>	
	</tr>
	
	<tr>
	<td bgcolor="f6f6f6"
	    height="24" 
		style="border:1px dotted gray" 
		colspan="6" class="labelmedium" 
		align="center" 
		style="padding-left:5px">
		<cf_tl id="This function allows you to transfer or amendment funds" class="message"> <cf_tl id="within the same edition and period from one program/object/fund to another" class="message">.
		<br>
		<b><cf_tl id="You may only transfer or amendment amounts which have been cleared (alloted)" class="message">.</b>
	</td>
	</tr>
		
	<!--- ------------- --->
	<!--- main box info --->
	<!--- ------------- --->
	
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" id="linesfrom"></td></tr>	
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" id="linesto"></td></tr>	
	<tr><td colspan="2" id="process" align="center"></td></tr>
				
</table>

