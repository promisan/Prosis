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

<Script language="JavaScript">

function ActivityViewer(ComponentCode, Period) {
    window.location = "../ActivityProgram/ActivityView.cfm?ProgramCode=" + ComponentCode + "&Period=" + Period;
}

function ClearRow(RowNum) {

  se = document.getElementsByName("Period"+RowNum)
  count = 0
  
  while (se[count])  {  
     se[count].style.fontWeight='normal'
     count++
  }
 
 }

</Script>

<cfquery name="Outputs" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_SubPeriod
   ORDER BY SubPeriod
</cfquery>

<cfparam name="URL.SubPeriod" Default="">

<cfif URL.SubPeriod neq "">

	<cfquery name="SP" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DisplayOrder FROM Ref_SubPeriod
	WHERE  SubPeriod = '#URL.SubPeriod#'
	</cfquery>
	
</cfif>


<cf_tl id="Period" var="1" >
<cfset vPeriod="#lt_text#">

<cf_tl id="Reference" var="1" >
<cfset vReference="#lt_text#">

<cf_tl id="Output" var="1" >
<cfset vOutput="#lt_text#">

<cf_tl id="Milestone output" var="1" >
<cfset vMilestone="#lt_text#">

<cf_tl id="Target" var="1" >
<cfset vTarget="#lt_text#">


<table width="100%" border="0" cellspacing="0" cellpadding="0" frame="all">
  
  <tr>
    <td width="100%">
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<cfoutput>
    <tr><td height="17" class="labellarge" style="font-size:23px;height:40px">#vMilestone#:</b></td></tr>
	</cfoutput>
	   
   <cfoutput>
      <input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
      <input type="hidden" name="ActivityPeriod" id="ActivityPeriod" value="#URL.Period#">
      <input type="hidden" name="ActivityId" id="ActivityId" value="#URL.ActivityId#">
   </cfoutput>
   
   <cfloop index="iPeriod" from="1" to="#Outputs.RecordCount#">

   <cfset Client.recordNo = iPeriod>
   
   <tr><td height="4"></td></tr>
   <tr><td>
      
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
       
  <tr>
  
  	<cfoutput>
    <TD width="10%" class="labelit" bgcolor="d4d4d4" style="padding-left:5px;border:1px solid gray">#vPeriod#:</TD>
	</cfoutput>
    <td class="header" style="padding-left:10px">
	
	<cfif URL.SubPeriod neq "">
		<cfoutput query="SP">
		<cfset PeriodCheck = "#DisplayOrder#">	
		</cfoutput>
	<cfelse>
		<cfset PeriodCheck = "#Client.recordNo#">		
	</cfif>
	
	<!---	Below is to highlight radio button text when selecting using java...--->
	
	<cfset CurrentPeriod = 1>	
	<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">		
	<cfset i=0>	
	
	<cfloop query="Outputs">
	     <td class="labelit" id="Period#iPeriod#" style="<cfif CurrentPeriod eq iPeriod>font-weight: bold;</cfif>">
			<input type="radio" 
			    class="radiol" 
				name="SubPeriod_#iPeriod#" 
				onClick="ClearRow(#iPeriod#);Period#iPeriod#[#i#].style.fontWeight='bold'" value="#SubPeriod#" 
			<cfif CurrentPeriod eq iPeriod>Checked</cfif>>
		 </td>
		 <td align="left" style="padding-left:4px;padding-right:8px">#left(Description,3)#</td>
		
		<cfset i=i+1>
		<Cfset CurrentPeriod = CurrentPeriod + 1>
		
	</cfloop>
	</table>
	</cfoutput>
	
	</td>	
	</TR>
	
    <tr><td colspan="2" height="3"></td></tr>
	
	<cfoutput>
	<tr class="labelmedium">
	<td valign="top" width="100" style="padding-top:4px;padding-left:70px">#vOutput#:</td>
	<td>
	
	<cf_LanguageInput
			TableCode       = "ProgramActivityOutput" 
			Mode            = "Edit"
			Name            = "ActivityOutput"
			NameSuffix      = "_#iPeriod#"
			Value           = ""
			Key1Value       = ""
			Key2Value       = ""
			Key3Value       = ""
			Type            = "Input"
			size            = "100" 
			maxlength       = "300"
			Class           = "regularxl">
	</td>
	</tr>
			
	<tr><td colspan="2" height="3"></td></tr>
	<tr class="labelmedium">
	<td width="100" style="padding-left:70px">#vReference#:</td>
	<td style="padding-left:20px">
	<table><tr><td>
	<input type="text" name="Reference_#iPeriod#" class="regularxl" size="10" maxlength="10">
	</td>
	<td style="padding-left:20px" class="labelit">
	    #vTarget#:&nbsp;
		</td>
		<td> 
	
		   <cf_intelliCalendarDate9
			FieldName="TargetDate_#iPeriod#" 
			Default=""
			class="regularxl"
			AllowBlank="True">
		
		</td></tr></table>
	
	</td>
	</tr>
	<tr><td colspan="2" height="10"></td></tr>
    <tr><td colspan="2" class="top" height="1"></td></tr>
    <tr><td colspan="2" height="3"></td></tr>
    </cfoutput>
	
	</td></tr>
   
    </Table>
	
   </CFLoop>
   
</TABLE>

</td></tr>

</table>

<cfset ajaxonload("doCalendar")>
