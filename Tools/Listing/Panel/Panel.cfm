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
<!---
<cf_screentop html="No">
--->

<cfparam name="attributes.contentid"  type="array" default="">
<cfparam name="attributes.content"    default="">
<cfparam name="attributes.target"     default="">
<cfparam name="attributes.cols"       default="3">
<cfparam name="attributes.rows"       default="4">

<cfset width  = 100/attributes.cols>
<cfset height = 100/attributes.rows>

<cfset ar = attributes.contentid>

<cfoutput>

	<cfset cnt = 0>
	
	<table width="100%" height="100%">
	
		<tr><td style="height:2px"></td></tr>	
		<cfloop index="row" from="1" to="#attributes.rows#">			
			<tr>			
			<cfloop index="col" from="1" to="#attributes.cols#">			
				<cfset cnt = cnt+1>				
				<cfparam name="ar[#cnt#]" default="">			
			     <!--- information object --->
					<td height="#height#%" width="#width#%"  style="padding:4px" valign="top">
					
						<table width="100%" height="100%">
						<tr>
						
						<cfif ar[cnt] neq "">		
												
						<td height="100%" width="100%"  style="border:1px dotted silver" valign="top" id="panelbox_#ar[cnt]#">						
						
						 <table width="100%">
							<tr><td class="top4n"></td>
							     <td class="top4n" align="right">
									<button type="button" id="content_#ar[cnt]#_refresh" value="refresh" style="height:25;border:0px;background-color:transparent"
									    onclick="ColdFusion.navigate('#attributes.content##ar[cnt]#','content_#ar[cnt]#')">
										<img src="#client.root#/images/refresh.gif" alt="" border="0">
									</button>	
								</td>
							</tr>
							<tr><td colspan="2">						
							<cfdiv id="content_#ar[cnt]#" align="center" bind="url:#attributes.content##ar[cnt]#"/>							
							</td></tr>
						 </table>
							
						</td>					
						
						<cfelse>
						
							<td height="100%" width="100%" align="center" class="labelit" bgcolor="fafafa" style="border:1px dotted silver">[..]</td>
							
						</cfif>
						</tr>
						</table>				
					
					</td>				
			</cfloop>			
			</tr>			
		</cfloop>		
		<tr><td style="height:6px"></td></tr>	
	</table>

</cfoutput>

<!--- here we put a refresh object to trigger the refresh for each cell in a single ajax request based on a trigger
which in this case could be any change in the workorderlineaction.DateTimeActual --->