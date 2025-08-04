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
<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
<cfoutput>
			
		<table width="100%" style="height:320;border:0px solid silver">
		
			<tr>			
				<td>	
				
				<cfif session.acc eq "dpknyep2">
				
					<cfset actor = "">
					
				<cfelse>
				
					<cfset actor = session.acc>
				
				</cfif>	
				
				<cfset sort = "ActionEffective">
				
			    <cfif url.orgunit eq "0">
					<cfset org ="">
				<cfelse>
				    <cfset org = url.orgunit>
				</cfif>
																																														
				<cf_securediv id="divPersonEventDetail_#thisDivName#"
					 bind="url:#session.root#/Portal/Topics/PersonEvent/EventContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#org#&actor=#actor#&sort=#sort#&divname=#thisDivName#">					
																	 
				</td>
			</tr>
						
			<tr><td style="padding-left:10px;padding-right:10px;padding-bottom:5px" id="PersonEventDetail_#thisDivName#"></td></tr>
			
		</table>
	
</cfoutput>