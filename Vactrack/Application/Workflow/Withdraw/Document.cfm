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

<cfquery name="Reason" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_StatusReason
</cfquery>

<cfquery name="SearchResult" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   DocumentCandidate
    WHERE  DocumentNo = '#Object.ObjectKeyValue1#'
	AND    PersonNo   = '#Object.ObjectKeyValue2#'
</cfquery>	

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="fbfbfb" class="formpadding">
       
  <cfoutput>	
  
  <tr><td height="1" colspan="2" bgcolor="E4E4e4"></td></tr>  
  <tr>
    <td colspan="2">
    <table width="98%" align="center" border="0" cellpadding="0" cellspacing="0" bordercolor="111111">
	
	<tr><td height="10"></td></tr>
	
	<TR>
    <TD>&nbsp;Level:</TD>
    <TD>&nbsp;
	
	  	<select name="StatusReason" size="1">
		<cfloop query="Reason">
		<option value="#Code#" <cfif Code eq searchresult.StatusReason>selected</cfif>>
    		#Description#
		</option>
		</cfloop>
	    </select>
					
	</td>
	
	<tr><td height="3" colspan="2"></td></tr> 
			
	</TABLE>
		
	</td></tr>
	
	<input name="savecustom" type="hidden"  value="Vactrack/Application/Workflow/WithDraw/DocumentSubmit.cfm">
	<input name="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
	<input name="Key2" type="hidden" value="#Object.ObjectKeyValue2#">
	
	</cfoutput>	

<tr><td height="1" colspan="2" bgcolor="#E4E4e4"></td></tr> 

</table>