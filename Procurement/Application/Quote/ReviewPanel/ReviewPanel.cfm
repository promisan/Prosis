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
<cfoutput>

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
	
		<tr><td height="4"></td></tr>
		
		<cfset link = "#SESSION.root#/procurement/application/quote/reviewpanel/ReviewPanelMember.cfm?jobNo=#Object.ObjectKeyValue1#&PanelType=#URL.WParam#">
				
		<tr><td height="40" colspan="6" align="left">
		
		   <cf_selectlookup
		    class    = "Employee"
		    box      = "member"
			title    = "Add Panel Member"
			link     = "#link#"			
			dbtable  = "Purchase.dbo.stJobReviewPanel"
			des1     = "PersonNo">
					
		</td>
		</tr> 
			
		
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2">
		
			<cfdiv bind="url:#link#" id="member"/>
		
		</td>
		</tr>  
		
		<tr><td colspan="6" bgcolor="DADADA"></td></tr> 		
	
    </table>
      
</cfoutput>