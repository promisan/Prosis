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
<cfoutput>

<cfset url.unit           = "#attributes.unit#">
<cfset url.PostClass      = "#attributes.postClass#">
<cfset url.SelectionDate  = "#attributes.SelectionDate#">		
<cfset url.Fund           = "#attributes.Fund#">			
<cfset url.Tree           = "#attributes.Tree#">		
<cfset url.Summary        = "#attributes.Summary#">		

<cfif url.unit neq "" and url.mode eq "chart">

<table width="100%" cellspacing="0" cellpadding="0" bgcolor="ffffff">
		
	<tr>
	
		<td height="6" align="center" style="cursor: pointer;" 
		  onClick="details('e#attributes.Unit#','#attributes.unit#','fly')">
	
		<img src="#SESSION.root#/Images/arrowdown1.gif" alt="Show Employees" 
			id="e#attributes.Unit#Exp" 
			border="0" 
			align="absmiddle"
			class="regular">
			 
		<img src="#SESSION.root#/Images/arrow_up1.gif" 
			id="e#attributes.Unit#Min" alt="Hide" border="0" 
			align="absmiddle"
			class="hide">
	
		</td>
	
	</tr>		
				
	<tr>
			
			<cfif attributes.layout eq "show">
				<td class="regular" id="e#attributes.Unit#" style="padding:5px">
					<cfinclude template="OrgTreeAssignmentDetail.cfm">
				</td>
			<cfelse>
				<td id="e#attributes.Unit#" class="#attributes.layout#"></td>		
			</cfif>							
			
	</tr>

</table>				   

</cfif>

</cfoutput>