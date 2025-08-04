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

  <cfquery name="Log" 
   datasource="AppsSystem" 
   maxrows="30"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT    *
		FROM      stUpload
		WHERE     DataSource = '#url.DataSource#'
		ORDER BY Created DESC
  </cfquery>
 
  <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
  
  <tr><td height="10"></td></tr>
  <tr><td>
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
   
  <tr><td height="20"></td>
      <td class="labelit"><cf_tl id="Source"></td>
      <td class="labelit"><cf_tl id="Location"></td>
	  <td class="labelit"><cf_tl id="Version"></td>
	  <td class="labelit"><cf_tl id="Period closed"></td>
	  <td class="labelit" width="105"><cf_tl id="Datetime upload"></td>
	  <td class="labelit"><cf_tl id="Time zone"></td>
	  <td class="labelit" width="105"><cf_tl id="Datetime content"></td>
	  <td class="labelit"><cf_tl id="Time zone"></td>
	  <td class="labelit"><cf_tl id="Contact"></td>
  </tr>
  
  <tr><td colspan="9" class="linedotted"></td></tr>
    
  <cfoutput query="Log">
    
  <tr class="navigation_row"><td height="20" align="center" class="labelit">#CurrentRow#</td>
      <td class="labelit">#DataSource#</td>
      <td class="labelit">#Location#</td>
	  <td class="labelit">#SourceVersion#</td>
	  <td class="labelit">#SourcePeriodClosed#</td>
	  <td class="labelit">#DateFormat(TSUpload, CLIENT.DateFormatShow)# : #timeformat(TSUpload,"HH:MM")#</td>
	  <td class="labelit">#TSUploadZone#</td>
	  <td class="labelit">#DateFormat(TSContent, CLIENT.DateFormatShow)# : #timeformat(TSContent,"HH:MM")#</td>
	  <td class="labelit">#TSContentZone#</td>
	  <td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
  </tr>
      
  </cfoutput>
  
  </table>
  
  </td></tr>
  </table>
  
  <cfset ajaxOnLoad("doHighlight")>