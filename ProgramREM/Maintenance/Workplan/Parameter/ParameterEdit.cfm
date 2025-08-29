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
 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<cf_screentop html="no">

<cf_PreventCache>
 
<cfset add          = "0">
<cfset save         = "0"> 
<cfinclude template = "../../HeaderMaintain.cfm"> 	

 
<cfquery name="Get" 
datasource="AppsePas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter 
</cfquery>

<cfquery name="Per" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractPeriod
	ORDER BY Code
</cfquery>

<CFFORM action="ParameterSubmit.cfm" method="post" name="parameterform" id="parameterform">

 <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">

   
   <tr class="line">
   <td height="24" class="labellarge"><b>&nbsp;EPas Global parameters:</b></td></tr>
   </tr>
   
 </table>


<table width="90%" align="center">
<tr><td>

<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	
    <TR>
    <td width="180" class="labelit">Application Name:</b></td>
    <td colspan="3">
  	    <cfoutput query="get">
		<input type="text" name="ApplicationName" value="#ApplicationName#" size="30" maxlength="50" class="regularxl">
		</cfoutput>
    </td>
	
	</TR>
  
    <!--- Field: ProgramNo --->
    <TR class="linedotted">
    <td width="180" class="labelit">Last PasNo:</b></td>
    <td colspan="3">
  	    <cfoutput query="get">
		<input type="text" name="PasNo" value="#PasNo#" size="10" maxlength="10" style="text-align: right;">
		<input type="hidden" name="ParameterKey" value="#ParameterKey#">
		</cfoutput>
    </td>
	
	</TR>
	
			
	 <!--- Field: Period --->
    <TR>
    <td class="labelit">Default Period:</b></td>
    <td colspan="3" class="labelit">
	
		<select name="PeriodDefault" message="Please select a default period" required="Yes" style="text-align: right;" class="regularxl">
		<cfoutput query="Per">
		<option value="#Code#" <cfif #Get.PeriodDefault# eq #Code#> SELECTED</cfif>>
		#Code#
		</option>
		</cfoutput>
			    
   	</select>
	  	 
    </TD>
	</TR>
	
	<tr class="linedotted"><td></td><td class="labelit" colspan="3">The default period that the system will display.</td></tr>
	
		
	   <!--- Field: Prosis Document Root --->
    <TR>
    <td class="labelit">Template Root:</b></td>
    <td colspan="3" class="labelit">
  	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="TemplateRoot" value="#TemplateRoot#" message="Please enter the correct root" required="Yes" size="40" maxlength="70">
		</cfoutput>
    </td>
	</tr>
	
	<tr class="linedotted">
	<td class="labelit">Home:</td>
    <TD colspan="3" class="labelit">
  	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="TemplateHome" value="#TemplateHome#" message="Please enter the correct local path" required="Yes" size="60" maxlength="70">
		
		</cfoutput>
    </TD>
	</TR>	
	
		
	<!--- Field: Prosis Applicantion Root Path--->
    <TR>
    <td class="labelit">Disable main objective/task:</b></td>
    <TD class="labelit" colspan="3">
  	    <cfoutput query="get">
		<input type="radio" name="HideObjective" value="1" <cfif #HideObjective# eq "1">checked</cfif>>Yes
		<input type="radio" name="HideObjective" value="0" <cfif #HideObjective# eq "0">checked</cfif>>No
		
		</cfoutput>
    </TD>
	</TR>	
	
	<TR class="linedotted">
    <td class="labelit">No of tasks:</b></td>
    <TD colspan="3">
  	 <cfinput type="Text"
       name="MinTasks"
       value="#Get.MinTasks#"
       range="1,4"
       width="1"
	   class="amount"
       validate="integer"
       required="No"
       visible="Yes"
       enabled="Yes"
       size="1"> 
	   - 
	   <cfinput type="Text"
       name="NoTasks"
       range="1,9"
	   size="1"
	   class="amount"
	   value="#Get.NoTasks#"
       validate="integer"
       required="No"
	   visible="Yes"
       enabled="Yes"> 
	   
    </TD>
	</TR>	
	
	
	<TR class="linedotted">
    <td class="labelit">Disable training/education section:</b></td>
    <TD class="labelit" colspan="3">
  	    <cfoutput query="get">
		<input type="radio" name="HideTraining" value="1" <cfif #HideTraining# eq "1">checked</cfif>>Yes
		<input type="radio" name="HideTraining" value="0" <cfif #HideTraining# eq "0">checked</cfif>>No
		
		</cfoutput>
    </TD>
	</TR>	
	
	
	<TR class="linedotted">
    <td class="labelit">Show calendar dialog:</b></td>
    <TD class="labelit" colspan="3">
  	    <cfoutput query="get">
		<input type="radio" name="ShowCalendar" value="1" <cfif #ShowCalendar# eq "1">checked</cfif>>Enabled
		<input type="radio" name="ShowCalendar" value="0" <cfif #ShowCalendar# eq "0">checked</cfif>>Disabled
		
		</cfoutput>
    </TD>
	</TR>	
		
	<cfquery name="Language" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_SystemLanguage
	 WHERE Operational IN ('0','1','2')
	</cfquery> 

	 <tr class="linedotted">
		 <td class="labelit">Interface language:</b></td>
		 <td height="15" align="left">
		 <select name="LanguageCode" style="background: f9f9f9; font-size : 10;" class="regularxl">
		  <cfoutput query="Language">
			  <option value="#Code#" <cfif #Code# eq "#Get.LanguageCode#">selected</cfif>>
			  	#LanguageName#
			  </option>
		  </cfoutput>
		</select>
	
		</td>
	</tr>
		
	
	<tr>
		<td height="23" colspan="4" align="center" valign="middle" class="labelit">
		    <input type="button"    name="Update" 
		   value=" Update " class="button10g"
	       onclick="ColdFusion.navigate('ParameterSubmit.cfm','divsubmit','','','POST','parameterform');">&nbsp;
    	</td>
	</tr>
	
</TABLE>
</td></tr>
</table>

</td></tr>

</table>

</CFFORM>

<div id="divsubmit"></div>


