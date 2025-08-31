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
<cfset vOption = "Maintain">
<cfset vBanner = "yellow">
<cfif URL.WorkSchedule eq "">
	<cfset vOption = "Add">
	<cfset vBanner = "blue">
</cfif>

<cf_tl id="Schedule" var="vSchedule">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#vSchedule#" 
			  option="#vOption# #url.mission# Schedule" 
			  close="parent.ColdFusion.Window.destroy('scheduledialog',true)"
			  JQuery="yes"
			  banner="#vBanner#">
			  
<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   WorkSchedule
	WHERE  Code   = '#URL.WorkSchedule#'	
</cfquery>

<table class="hide">
	<tr><td><iframe name="processSchedule" id="processSchedule" frameborder="0"></iframe></td></tr>
</table>
			  
<cfform 
	name="frmSchedule" 
	method="POST" 
	action="#session.root#/Staffing/Application/WorkSchedule/Planning/WorkScheduleEditSubmit.cfm?mission=#url.mission#&Mandate=#url.mandate#&WorkSchedule=#URL.WorkSchedule#"
	target="processSchedule">

<cfoutput>
	<table width="90%" align="center" class="formpadding formspacing">
	
		<tr>
			<td width="30%" class="labelmedium">
				<cf_tl id="Code">:
			</td>
			<td class="labelmedium">
				<cfif URL.WorkSchedule eq "">
				
					<cf_tl id="Please enter a code" var="vCodeMessage">
				
					<cfinput type="text" 
					   value="#get.Code#" 
				       name="Code" 
					   message="#vCodeMessage#"
					   required="yes" 
					   size="10" 
				       maxlength="20" 
					   class="regularxl">
				<cfelse>
					<b>#get.Code#</b>
					<input type="Hidden" name="Code" id="Code" value="#get.Code#">
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="labelmedium">
				<cf_tl id="Name">:
			</td>
			<td>
			
				<cf_tl id="Please enter a name" var="vNameMessage">
				<cfinput type="text" 
			       name="Description" 
				   value="#get.Description#" 
				   message="#vNameMessage#" 
				   required="yes" 
				   size="30" 
			       maxlength="50" 
				   class="regularxl">
				   
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium">
				<cf_tl id="Class">:
			</td>
			<td>
			
				<cfquery name="getClass" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ScheduleClass
						ORDER BY ListingOrder ASC
				</cfquery>
				
				<cfselect 
					name="ScheduleClass" 
					id="ScheduleClass" 
					query="getClass" 
					display="Description" 
					value="Code" 
					selected="#get.ScheduleClass#" 
					class="regularxl" 
					queryposition="below">
					<option value="">
				</cfselect>
				   
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium">
				<cf_tl id="Slot">:
			</td>
			
			<td>
				
				<cf_tl id="Please enter a numeric order" var="vOrderMessage">
				
				<table><tr><td>
				
				<input type="radio" 
			       name="HourMode" 
				   value="60" <cfif get.HourMode eq "60" or url.workSchedule eq "">checked</cfif>>
				  </td>
				  <td class="labelmedium" style="padding-left:5px">full hour</td>
				  <td style="padding-left:10px">
				  <input type="radio" 
			       name="HourMode" 
				   value="30" <cfif get.HourMode eq "30">checked</cfif>>
				  </td>
				  <td class="labelmedium" style="padding-left:5px">30"</td>
				  <td style="padding-left:10px">
				  <input type="radio" 
			       name="HourMode" 
				   value="20" <cfif get.HourMode eq "20">checked</cfif>>
				  </td>
				  <td class="labelmedium" style="padding-left:5px">20"</td>
				    <td style="padding-left:10px">
				  <input type="radio" 
			       name="HourMode" 
				   value="15" <cfif get.HourMode eq "15">checked</cfif>>
				  </td>
				  <td class="labelmedium" style="padding-left:5px">15"</td>
				  
				  </tr>
				  </table> 
				  
				  <input type="hidden" name="OldHourMode" id="OldHourMode" value="#get.HourMode#">
				   
			</td>
		</tr>
					
		<tr>
			<td class="labelmedium"><cf_tl id="Actions per slot">:</td>
			<td class="labelmedium">
			    <table>
				<tr class="labelmedium">
					<td><input name="MultipleActions" class="radiol" type="Radio" value="1" <cfif get.MultipleActions eq 1 or url.workSchedule eq "">checked</cfif>></td>
					<td style="padding-left:5px"><cf_tl id="Multiple"></td>
					<td style="padding-left:8px"><input name="MultipleActions" class="radiol" type="Radio" value="0" <cfif get.MultipleActions eq 0>checked</cfif>></td>
					<td style="padding-left:5px"><cf_tl id="One (1)"></td>
					<td style="padding-left:20px">[workorder]</td>
				</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium">
				<cf_tl id="Sort">:
			</td>
			<td>
				
				<cf_tl id="Please enter a numeric order" var="vOrderMessage">
				
				<cfinput type="text" 
			       name="ListingOrder" 
				   value="#get.ListingOrder#" 
				   message="#vOrderMessage#" 
				   required="yes" 
				   validate="integer" 
				   size="1" 
			       maxlength="3" 
				   class="regularxl" 
				   style="text-align:center;">
				   
			</td>
		</tr>
		
		
		
		<tr>
			<td class="labelmedium"><cf_tl id="Operational">:</td>
			<td class="labelmedium">
			    <table>
				<tr class="labelmedium">
					<td><input name="operational" id="operational" class="radiol" type="Radio" value="1" <cfif get.operational eq 1 or url.workSchedule eq "">checked</cfif>></td>
					<td style="padding-left:5px"><cf_tl id="Yes"></td>
					<td style="padding-left:8px"><input name="operational" id="operational" class="radiol" type="Radio" value="0" <cfif get.operational eq 0>checked</cfif>></td>
					<td style="padding-left:5px"><cf_tl id="No"></td>
				</tr>
				</table>
			</td>
		</tr>
		
		<tr><td height="3"></td></tr>	
		<tr><td colspan="2" class="linedotted"></td></tr>	
		<tr><td height="3"></td></tr>	
			
		<tr>	
			<td align="center" colspan="2">	
				<cf_tl id="Save" var="vSave">
				<cfif url.workSchedule eq "">
					<input class="button10g" type="submit" style="width:140px" name="Save" id="Save" value="  #vSave#  ">
				<cfelse>
					<cf_tl id="This action will remove the hours defined in your schedule.  Do you want to continue?" var="vSaveMessage">
    				<input class="button10g" type="submit" style="width:140px" name="Save" id="Save" value="  #vSave#  " onclick="if ($('##OldHourMode').val() < $('input[name=HourMode]:checked').val()) { if (confirm('#vSaveMessage#')) { return true; } else { return false;} }">
				</cfif>
			</td>	
		</tr>
	
	</table>
	
</cfoutput>

</cfform>