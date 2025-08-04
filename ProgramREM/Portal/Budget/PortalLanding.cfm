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

<cf_screentop html="no">

<table cellpadding="0" cellspacing="0" width="100%" height="100%">

	<tr>
		<td>
		
			<table cellpadding="0" cellspacing="0" width="100%" height="100%">
							
				<tr>
					<td height="39px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
						<cfinclude template="../../../Portal/SelfService/Extended/LogonProcessMenu.cfm">
					</td>
				</tr>
				
				<tr>					
					<td>
						<div style="width:100%; height:100%; overflow-y:auto">
							<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">								
								
								<tr>
									<td bgcolor="white" valign="top" id="menucontent" name="menucontent">
									
									<cfif client.personno eq "">									
										<table width="100%" height="50">
											<tr>
												<td align="center">
										    		<font face="Verdana" size="2">Your profile has not been initiatized. Please contact the Administrator</font>
										    	</td>
											</tr>
										</table>									
									<cfelse>
									
									  <cfoutput>
									  
									  <!--- iframe opening --->
									  									
									  <iframe src="#SESSION.root#/ProgramREM/Portal/Budget/BudgetView.cfm?webapp=#url.webapp#&id=#client.personno#&scope=portal&mid=#url.mid#&mission=#client.mission#" 
										    name="contentframe" 
											id="contentframe" 
											width="100%" 
											height="100%" 
											frameborder="0">									  
									  </iframe>	
									  
									  </cfoutput>								
									  
									</cfif>									
									
									</td>
								</tr>
								
							</table>
						</div>
					</td>
				</tr>
				
			</table>
			
		</td>
	</tr>
	
</table>
