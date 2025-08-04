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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset Criteria = ''>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td>

<table width="95%" align="right" border="0" cellspacing="0" cellpadding="0" rules="cols" style="border-collapse: collapse">

<cfform action="" method="POST" name="treeform">

   <tr><td height="8"></td></tr>	
      
	<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Indicator
	WHERE IndicatorCode = '#URL.Indicator#'
	</cfquery>
   	
  <cfif Indicator.IndicatorTemplate neq "" and Indicator.IndicatorTemplateAjax eq "1">
  
	  <tr>
	  <td width="80">&nbsp;Hide Header</td>
	  <td><input type="checkbox" name="hidetop" value="1" checked></td>
	  </tr>	
  
  </cfif>
  
  <tr><td height="6"></td></tr>	
  <tr><td colspan="2"> 						
		<cf_ProgramIndicatorAudit mode="details"
				targetid = "#URL.targetid#"
				period =  "#URL.Period#">
	 </td>
  </tr>	 
  <tr><td height="4"></td></tr>	
  <tr><td height="1" colspan="2" class="line"></td></tr>	
  <tr><td height="6"></td></tr>	
  
  </cfform>
  
</table>       	
</td></tr></table>
