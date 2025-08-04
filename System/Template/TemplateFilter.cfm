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

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<cfparam name="URL.site" default="">
<cfparam name="URL.group" default="">
<cfparam name="URL.root" default="#SESSION.root#">
<cfparam name="URL.version" default="">
<cfparam name="URL.filter" default="0">

<cfinclude template="TemplateLogScript.cfm">
	
<cfajaximport tags="cfprogressbar">

<cf_actionlistingscript>
<cf_filelibraryscript>

<cfif url.filter eq "0">

	<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
	<tr class="hide" height="1"><td id="result"></td></tr>
	
	<tr><td id="detail" valign="top">	
		<!--- Search form --->
		<form name="formlocate">
			<cfdiv bind="url:TemplateLog.cfm?group=#url.group#&site=#url.site#&version=#url.version#">
		</form>
	</td>
	</tr>
		
	</table>

<cfelse>
	
	<!--- Search form --->
	<cfform target="detail" name="formlocate" onsubmit="return false">
	
	<cfquery name="Group" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT TemplateGroup
		FROM  ParameterSiteGroup	
	</cfquery>
		
	<table width="100%" height="100%" align="center" border="0" class="formpadding">
	
	<tr class="hide"><td id="result"></td></tr>
	
	<tr><td height="100">
	
	<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td></td></tr>
	<tr>		
		<td height="24" colspan="2" class="labellarge">Find Modified Templates</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr><td height="3"></td></tr>
			
		<TR>
	
		<TD class="labelit">Application Directory:</TD>
				
		<td align="left" valign="top">
		<select name="Group" id="Group" size="1" class="regularxl">
		    <option value="" selected>All</option>
		    <cfoutput query="Group">
			<option value="#TemplateGroup#">/#TemplateGroup#</option>
			</cfoutput>
		    </select>
		</td>	
			
		<TD></TD>
				
		<td align="left" valign="top">
		
		</td>	
		<TD>
		
		</TR>
		
	
		<TR>
		<TD class="labelit">Template Name:</TD>
				
		<td align="left" valign="top">
		   <input class="regularxl" type="text" name="FileName" id="FileName" value="" size="40">
		</td>	
				
		</tr>
				
		<TR>
		<TD class="labelit">Content:</TD>				
		<td align="left" valign="top">
		   <input class="regularxl" type="text" name="TemplateContent" id="TemplateContent" value="" size="40">
		</td>					
		</tr>
				
		<cf_calendarscript>		
				
		<TR>
		<TD class="labelmedium" width="170">Version Date Selection:</TD>
		<TD>	
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		
		 <cf_intelliCalendarDate9
			FieldName="datestart" 
			Default="#dateformat(now()-1,CLIENT.DateFormatShow)#"
			Class="regularxl"
			AllowBlank="False">
			
			</td>
			<td class="labelit">&nbsp; to :</td>
		<td>
		
		<cf_intelliCalendarDate9
			FieldName="dateend" 
			Default="#dateformat(now(),CLIENT.DateFormatShow)#"
			Class="regularxl"
			AllowBlank="False">	
			
		</td></tr>
		</table>	
			
		</TD>
		</tr>
		
		<tr><td height="4"></td></tr>
		
		<tr><td colspan="2" class="line"></td></tr>
	
	</TABLE>
	</td></tr>
		
	<tr><td align="center" height="30">
	<cfoutput>
	<input type="reset"  class="button10g" value="Reset">
	<input type="button" name="Submit" id="Submit" value="Find" class="button10g" onclick="filter()">
	</cfoutput>
	
	</td></tr>
	
	<tr><td id="detail" height="100%" valign="top"></td></tr>
	
	</CFFORM>
	
	</table>
	
</cfif>	

