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
<script>

function ActivityViewer(ComponentCode, Period) {
    window.location = "../ActivityProgram/ActivityView.cfm?ProgramCode=" + ComponentCode + "&Period=" + Period;
}

</script>

<cf_calendarscript>

<cfquery name="SubPeriods" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_SubPeriod
   ORDER BY SubPeriod
</cfquery>

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT  *
   FROM    #CLIENT.LanPrefix#ProgramActivityOutput A
   WHERE   A.OutputId = '#URL.OutputId#'
</cfquery>


<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
  
  <tr>
    <td width="100%">
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	
    <TR>
       <td height="17" class="labellarge"><b><cf_tl id="Output">:</b></td>
    </TR>
	
   <cfoutput>
	   <input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
	   <input type="hidden" name="ActivityPeriod" id="ActivityPeriod" value="#URL.Period#">
	   <input type="hidden" name="ActivityId" id="ActivityId" value="#URL.ActivityId#">
	   <input type="hidden" name="OutputId" id="OutputId" value="#URL.OutputId#">
   </cfoutput>
         
<cfoutput query="output">

  <tr><td style="padding-left:20px">
        
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
       
  <tr>
  
    <tr><td class="header" colspan="2" height="3"></td></tr>

	<tr><td class="header"></td>
	<td class="header">
		<table width="70%" border="0" cellspacing="0" cellpadding="0">
		
			<cfloop query="SubPeriods">
		   	  <td width="10%" class="labelmedium" id="SubPeriod">
				<input type="radio" name="SubPeriod" value="#SubPeriod#" 
				<cfif Output.ActivityPeriodSub eq '#SubPeriod#'>Checked</cfif>>#Description#
			</td>
			
			</cfloop>
		
		</table>
	</td></tr>
		
  	<tr><td class="header" colspan="2" height="3"></td></tr>
	
	<tr>
	<td class="labelmedium"><cf_tl id="Description">:</td>
	<td class="labelmedium">
	
	<cf_LanguageInput
			TableCode       = "ProgramActivityOutput" 
			Mode            = "Edit"
			Name            = "ActivityOutput"
			Value           = "#ActivityOutput#"
			Key1Value       = "#URL.ProgramCode#"
			Key2Value       = "#URL.Period#"
			Key3Value       = "#URL.OutputId#"
			Type            = "Input"
			size            ="80" 
			maxlength       ="300"
			Class           = "regularxl">
	</td>
	</tr>
			
	<tr><td class="header" colspan="2" height="3"></td></tr>
	<tr>
	<td class="labelmedium"><cf_tl id="Reference">:</td>
	<td><input type="text" name="Reference" value="#Reference#" size="10" maxlength="10" class="regularxl"></td>
	</tr>
	<tr><td class="header" colspan="2" height="3"></td></tr>
	<tr>
	<td class="labelmedium">Target: </d>
	<td>
	
	   <cf_intelliCalendarDate9
		FieldName="ActivityOutputDate" 
		Default="#Dateformat(ActivityOutputDate, CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="False">
	
	</td>
	</tr>
	
    <tr><td colspan="2" height="6"></td></tr>
	
   </cfoutput>
   
    </Table>	
   
</TABLE>

</td></tr>

</table>
