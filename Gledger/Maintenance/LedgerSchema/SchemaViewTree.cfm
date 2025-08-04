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

<cfparam name="url.idmenu" default="">

<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule
				  WHERE SystemModule = 'Accounting')
</cfquery>

<table width="100%" style="height:100%">
   
   <tr>
  <td valign="top" style="height:100%">
  
  	<cf_divscroll>
	
		<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<TR><TD style="padding:5px">
		
		<cf_UItree
			id="Root"
			title="<span style='font-size:16px;color:gray;padding-bottom:3px' class='labellarge'>Entities</span>"
			expand="Yes">		
				   
		   <cfif MissionSelect.recordcount lte "3">
		        <cfset exp = "Yes">
		   <cfelse>
		     	<cfset exp = "No">
		   </cfif>
			
	    	<cfoutput query="MissionSelect">	
			
				<cf_UItreeitem value="#Mission#"
					display="<span style='font-size:16px;padding-bottom:2px'>#Mission#</span>"
					parent="Root"
					expand="#exp#">				  
									
				 <cf_tl id="Ledger Journal" var="vVar1">
				 
				 <cf_UItreeitem value="#Mission#_1"
					display="<span style='font-size:14px;padding-bottom:2px'>#vVar1#</span>"
					parent="#Mission#"
					target="right"					
					href="Journal/RecordListing.cfm?mission=#mission#"
					expand="#exp#">							
								
				 <cf_tl id="Chart of Accounts" var="vVar2">
				 
				  <cf_UItreeitem value="#Mission#_2"
					display="<span style='font-size:14px;padding-bottom:2px'>#vVar2#</span>"
					parent="#Mission#"
					target="right"					
					href="Accounts/AccountListing.cfm?mission=#mission#&idmenu=#url.idmenu#"
					expand="#exp#">			
									
				 <cf_tl id="Custom Statement" var="vVar3">
				 
				  <cf_UItreeitem value="#Mission#_3"
					display="<span style='font-size:14px;padding-bottom:2px'>#vVar3#</span>"
					parent="#Mission#"
					target="right"					
					href="Statement/PresentationListing.cfm?mission=#mission#&idmenu=#url.idmenu#"
					expand="#exp#">			
								 					
				 <cf_tl id="Validate Schema" var="vVar4">
				 
				 <cf_UItreeitem value="#Mission#_4"
					display="<span style='font-size:14px;padding-bottom:2px'>#vVar4#</span>"
					parent="#Mission#"
					target="right"					
					href="Validate/Validate.cfm?mission=#mission#"
					expand="#exp#">			
				
							
			</cfoutput>
			
		</cf_UItree>	
			
		</TD></TR>	
		</table>
 	
	</cf_divscroll>
 
  </td>
  </tr>
</table>


