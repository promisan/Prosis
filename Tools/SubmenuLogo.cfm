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

<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   xl#Client.languageId#_Ref_SystemModule
	WHERE  SystemModule = '#Attributes.Module#' 
</cfquery>	

<cfset logo = "">
		
<cfif FileExists("#SESSION.rootpath#\images\logos\#attributes.module#\#attributes.module#_#attributes.selection#.jpg")>	

    <cfset logo = "#attributes.module#/#attributes.module#_#attributes.selection#.jpg">		
	
<cfelseif FileExists("#SESSION.rootpath#\images\logos\#attributes.module#\#attributes.module#_#attributes.selection#.png")>	

	 <cfset logo = "#attributes.module#/#attributes.module#_#attributes.selection#.png">		
			
</cfif>
		
<cfif logo neq "">	
		
		<cfoutput>
			
			<table width="100%" border="0">
			<tr>
				<td width="5%">
				</td>

				<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
					<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
						<tr>
							<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
							</td>
						</tr>						
						<tr>
							<td style="z-index:5; position:absolute; top:24px; left:32px">
								<img src="#SESSION.root#/images/logos/#logo#" style="width:48px;">
							</td>
						</tr>
						<tr>
							<td style="z-index:3; position:absolute; top:14px; left:100px; color:##45617d; font-size:32px; font-weight:200;">
								<cfif Module.SystemModule eq "WarehouseDGACM">
									<cfset Module.Description = "DataWarehouse">
									#Module.Description#
								<cfelse>
								#Module.Description#
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td style="position:absolute; top:56px; left:100px; color:##45617d;font-size:14px; font-weight:400; z-index:4">
								#attributes.selection#
							</td>
						</tr>
						
					</table>
				</td>
			</tr>
			</table>
			
		</cfoutput>
	
</cfif>
