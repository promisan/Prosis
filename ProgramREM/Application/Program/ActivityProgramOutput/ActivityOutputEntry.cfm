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
<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_calendarscript>
<cf_dialogREMProgram>

<table width="100%" border="0" bordercolor="silver"><tr><td>

	<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<!--- Query returning search results for activities  --->
<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT  A.*,	O.OrgUnitName as OrganizationName  
   FROM    #CLIENT.LanPrefix#ProgramActivity A LEFT OUTER JOIN Organization.dbo.#CLIENT.LanPrefix#Organization O ON A.OrgUnit = O.OrgUnit
   WHERE   A.ActivityId = '#URL.ActivityId#'
</cfquery>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>

<tr><td>

<cfform action="OutputEntryFullSubmit.cfm" method="POST" enablecab="No" name="OutputEntryFull">
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" frame="all">

  <!---
  <tr>
    <td width="100%" height="24">&nbsp;<font size="2" color="C0C0C0"><b>Activity</b>
	</td>
  </tr>
  --->
  
 <cfoutput>
        <tr><td height="36" align="center">
		<input class="button10g" type="button" value="Cancel" onClick="javascript:ActivityViewer('#URL.ProgramCode#','#URL.Period#')">
		<INPUT class="button10g" type="submit" value="Save">
		</td></tr>
 </cfoutput>
  
   <tr><td>
	  		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">  
	    
	 <tr>
	  <td width="100%" colspan="2">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<TR class="labelmedium line" style="border-top:1px solid silver" bgcolor="f4f4f4">		   
			<TD width="60%" align="left" style="padding-left:5px"><cf_tl id="Description"></TD>
			<td></td>
			<td width="12%" align="left"><cf_tl id="Target Date"></td>
			<TD width="8%" align="left"><cf_tl id="Reference"></TD>
			<TD align="left"></TD>	
		</TR>
	
		<cfset Client.recordNo = 0>
		
		<cfoutput query="SearchResult" group="ActivityDateStart">
				
			<cfoutput>
			 
				<tr bgcolor="yellow">				
					<TD class="labelmedium" style="padding-left:5px;padding-right:5px" colspan="2">#SearchResult.ActivityDescription#</TD>
					<TD class="labelmedium">#DateFormat(SearchResult.ActivityDate, CLIENT.DateFormatShow)#</TD>
					<TD class="labelmedium">#SearchResult.Reference#</TD>
					<tr><td height="5"></td></tr>
				</TR>
				
				<tr><td colspan="5"><cfinclude template="OutputEntryFull.cfm"></td></tr> 
				
			</cfoutput>
		
		</cfoutput>
	
		</table>
	
		</td>
	 </tr>
	
	</table>
	
	</td>
	</tr>
	
	</table>
  
</cfform>  
  
